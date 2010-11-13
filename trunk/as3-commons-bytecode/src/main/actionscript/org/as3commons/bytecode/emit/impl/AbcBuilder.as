/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.emit.impl {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.NamedMultiname;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.ScriptInfo;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.impl.event.ExtendedClassesNotFoundError;
	import org.as3commons.bytecode.swf.AbcClassLoader;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Type;

	/**
	 * Dispatched when the class loader has finished loading the SWF/ABC bytecode in the Flash Player/AVM.
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the class loader has encountered an IO related error.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Dispatched when the class loader has encountered a SWF verification error.
	 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]
	/**
	 * The <code>AbcBuilder</code> is the main entry point for the emit API. Here is
	 * an example of how to generate a simple class:
	 * <listing version="3.0">
	 * function generateClass():void {
	 *   var abcBuilder:IAbcBuilder = new AbcBuilder();
	 *   var classBuilder:IClassBuilder = abcBuilder.definePackage("com.classes.generated").defineClass("MyGeneratedClass");
	 *   classBuilder.defineProperty("myProperty", "String", "default value");
	 *   classBuilder.defineAccessor("myOtherProperty", "int", 10).access = AccessorAccess.READ_ONLY;
	 *   abcBuilder.addEventListener(Event.COMPLETE, completeHandler);
	 *   abcBuilder.buildAndLoad(); //loads the generated class into the current application domain
	 * }
	 * function completeHandler(event:Event):void {
	 *   var clazz:Class = ApplicationDomain.currentDomain.getDefinition("com.classes.generated.MyGeneratedClass") as Class;
	 *   var instance:Object = new class();
	 *   var propertyValue:String = instance.myProperty;
	 *   var otherPropertyValue:int = instance.myOtherProperty;
	 *   //propertyValue == "default value"
	 *   //otherPropertyValue == 10
	 *   instance.myOtherProperty = 20; //ERROR! Accessor is read-only (getter)
	 * }
	 * </listing>
	 * To add methods and method bodies to a class a certain knowledge of AVM opcodes is required:
	 * <listing version="3.0">
	 * function generateClass():void {
	 *   var abcBuilder:IAbcBuilder = new AbcBuilder();
	 *   var classBuilder:IClassBuilder = abcBuilder.definePackage("com.classes.generated").defineClass("MyGeneratedClass");
	 *   var methodBuilder:IMethodBuilder = classBuilder.defineMethod("multiplyByHundred");
	 *   methodBuilder.returnType("int");
	 *   methodBuilder.defineArgument("int");
	 *   methodBuilder.addOpcode(Opcode.getlocal_0)
	 *                .addOpcode(Opcode.pushscope)
	 *                .addOpcode(Opcode.getlocal_1)
	 *                .addOpcode(Opcode.pushint, [100])
	 *                .addOpcode(Opcode.multiply)
	 *                .addOpcode(Opcode.setlocal_1)
	 *                .addOpcode(Opcode.getlocal_1)
	 *                .addOpcode(Opcode.returnvalue);
	 *   abcBuilder.addEventListener(Event.COMPLETE, completeHandler);
	 *   abcBuilder.buildAndLoad(); //loads the generated class into the current application domain
	 * }
	 * function completeHandler(event:Event):void {
	 *   var clazz:Class = ApplicationDomain.currentDomain.getDefinition("com.classes.generated.MyGeneratedClass") as Class;
	 *   var instance:Object = new class();
	 *   var i:int = instance.multiplyByHundred(10);
	 *   // i == 1000
	 * }
	 * </listing>
	 * @author Roland Zwaga
	 */
	public class AbcBuilder extends EventDispatcher implements IAbcBuilder {

		private var _loader:AbcClassLoader;
		private var _packageBuilders:Dictionary;
		private var _abcFile:AbcFile;

		/**
		 * Creates a new <code>AbcBuilder</code> instance.
		 */
		public function AbcBuilder(abcFile:AbcFile = null) {
			super();
			init(abcFile);
		}

		private function init(abcFile:AbcFile):void {
			_packageBuilders = new Dictionary();
			_abcFile = abcFile;
		}

		/**
		 * Internal <code>AbcClassLoader</code> instance used by the <code>buildAndLoad()</code> method.
		 */
		protected function get loader():AbcClassLoader {
			if (_loader == null) {
				_loader = new AbcClassLoader();
				_loader.addEventListener(Event.COMPLETE, redispatch);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, redispatch);
				_loader.addEventListener(IOErrorEvent.VERIFY_ERROR, redispatch);
			}
			return _loader;
		}

		/**
		 * Redispatches the specified <code>AbcClassLoader</code> <code>Event</code>.
		 * @param event The specified <code>AbcClassLoader</code> <code>Event</code>.
		 */
		protected function redispatch(event:Event):void {
			dispatchEvent(event);
		}

		/**
		 * <p>If the specified package name already exists, the exisiting <code>IPackageBuilder</code>
		 * will be returned instead of a new instance.</p>
		 * @inheritDoc
		 */
		public function definePackage(name:String):IPackageBuilder {
			var pb:PackageBuilder;
			if (_packageBuilders[name] != null) {
				pb = _packageBuilders[name];
			} else {
				pb = new PackageBuilder(name, _abcFile);
				pb.addEventListener(ExtendedClassesNotFoundError.EXTENDED_CLASSES_NOT_FOUND, classNotFoundHandler);
				_packageBuilders[name] = pb;
			}
			return pb;
		}

		/**
		 *
		 * @param event
		 *
		 */
		protected function classNotFoundHandler(event:ExtendedClassesNotFoundError):void {
			var nameList:Array = extractExtendedClasses(event.className, event.applicationDomain);
			for each (var name:String in nameList) {
				event.extendedClasses[event.extendedClasses.length] = name;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function build(applicationDomain:ApplicationDomain = null):AbcFile {
			if (_abcFile == null) {
				_abcFile = new AbcFile();
			}
			var classNames:Array = [];
			applicationDomain = (applicationDomain) ? applicationDomain : ApplicationDomain.currentDomain;
			var idx:uint = 0;
			for each (var pb:IPackageBuilder in _packageBuilders) {
				var arr:Array = pb.build(applicationDomain);
				idx = addAbcObjects(arr, _abcFile, applicationDomain, idx);
			}
			return _abcFile;
		}

		/**
		 * @inheritDoc
		 */
		public function buildAndLoad(applicationDomain:ApplicationDomain = null, newApplicationDomain:ApplicationDomain = null):AbcFile {
			var abcFile:AbcFile = build(applicationDomain);
			loader.loadAbcFile(abcFile, newApplicationDomain);
			return abcFile;
		}

		/**
		 *
		 * @param instances Array of builder objects that represent the various elements to be added to the <code>AbcFile</code>.
		 * @param abcFile The <code>AbcFile</code> that will be populated with the builder results.
		 * @param applicationDomain The <code>ApplicationDomain</code> used to lookup superclasses.
		 * @param index The current class index in the <code>AbcFile</code>.
		 * @return The current class index in the <code>AbcFile</code>.
		 */
		protected function addAbcObjects(instances:Array, abcFile:AbcFile, applicationDomain:ApplicationDomain, index:uint):uint {
			Assert.notNull(instances, "instances argument must not be null");
			Assert.notNull(abcFile, "abcFile argument must not be null");
			Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			for each (var inst:Object in instances) {
				if (inst is ClassInfo) {
					addClassInfo(abcFile, ClassInfo(inst))
				} else if (inst is InstanceInfo) {
					addInstanceInfo(abcFile, InstanceInfo(inst));
					addScriptInfo(abcFile, InstanceInfo(inst), applicationDomain, index++);
				} else if (inst is MethodInfo) {
					addMethodInfo(abcFile, MethodInfo(inst));
				} else if (inst is Metadata) {
					abcFile.addMetadataInfo(Metadata(inst));
				} else if (inst is Array) {
					addAbcObjects((inst as Array), abcFile, applicationDomain, index);
				}
			}
			return index;
		}

		/**
		 * Adds the specified <code>ClassInfo</code> and its constructor <code>MethodInfo</code> to the specified <code>AbcFile</code>.
		 * @param abcFile The specified <code>AbcFile</code>.
		 * @param classInfo The specified <code>ClassInfo</code>.
		 */
		protected function addClassInfo(abcFile:AbcFile, classInfo:ClassInfo):void {
			abcFile.addClassInfo(classInfo);
			addMethodInfo(abcFile, classInfo.staticInitializer);
		}

		/**
		 * Adds the specified <code>InstanceInfo</code> and its constructor <code>MethodInfo</code> to the specified <code>AbcFile</code>.
		 * @param abcFile The specified <code>AbcFile</code>.
		 * @param instanceInfo The specified <code>InstanceInfo</code>.
		 */
		protected function addInstanceInfo(abcFile:AbcFile, instanceInfo:InstanceInfo):void {
			abcFile.addInstanceInfo(instanceInfo);
		}

		/**
		 * Creates a <code>ScriptInfo</code> instance based on the specified <code>InstanceInfo</code> and adds it and its constructor
		 * <code>MethodInfo</code> to the specified <code>AbcFile</code>.
		 * @param abcFile The specified <code>AbcFile</code>.
		 * @param instanceInfo The specified <code>InstanceInfo</code>.
		 * @param applicationDomain The <code>ApplicationDomain</code> used to lookup superclasses.
		 * @param index The current class index in the <code>AbcFile</code>.
		 */
		protected function addScriptInfo(abcFile:AbcFile, instanceInfo:InstanceInfo, applicationDomain:ApplicationDomain, index:uint):void {
			var scriptInfo:ScriptInfo = createClassScriptInfo(instanceInfo.classMultiname.fullName, instanceInfo.superclassMultiname, instanceInfo.classInfo, applicationDomain, index, instanceInfo.isInterface);
			abcFile.addScriptInfo(scriptInfo);
			addMethodInfo(abcFile, scriptInfo.scriptInitializer);
		}

		/**
		 * Creates a <code>ScriptInfo</code> instance based on the specified <code>InstanceInfo</code>.
		 * @param className The class name of the generated class
		 * @param superClass A <code>BaseMultiName</code> representing the super class.
		 * @param classInfo The <code>ClassInfo</code> associated with the new <code>ScriptInfo</code>.
		 * @param applicationDomain The <code>ApplicationDomain</code> used to lookup superclasses.
		 * @param index The current class index in the <code>AbcFile</code>.
		 * @return The new <code>ScriptInfo</code> instance.
		 */
		protected function createClassScriptInfo(className:String, superClass:BaseMultiname, classInfo:ClassInfo, applicationDomain:ApplicationDomain, index:uint, isInterface:Boolean):ScriptInfo {
			var scriptInfo:ScriptInfo = new ScriptInfo();
			if (!isInterface) {
				scriptInfo.scriptInitializer = createClassScriptInitializer(className, superClass, classInfo, applicationDomain);
			} else {
				scriptInfo.scriptInitializer = createInterfaceScriptInitializer(className, classInfo);
			}
			scriptInfo.traits[scriptInfo.traits.length] = createClassTrait(className, index, classInfo);
			return scriptInfo;
		}

		/**
		 * Creates a <code>ClassTrait</code> instance for the specified class name and class index.
		 * @param className The specified class name.
		 * @param index The current class index in the <code>AbcFile</code>.
		 * @return the new <code>ClassTrait</code>.
		 */
		protected function createClassTrait(className:String, index:uint, classInfo:ClassInfo):ClassTrait {
			var trait:ClassTrait = new ClassTrait();
			trait.classIndex = index;
			trait.classInfo = classInfo;
			trait.traitKind = TraitKind.CLASS;
			trait.traitMultiname = MultinameUtil.toQualifiedName(className);
			return trait;
		}

		protected function createInterfaceScriptInitializer(className:String, classInfo:ClassInfo):MethodInfo {
			var mn:QualifiedName = MultinameUtil.toQualifiedName(className);
			var mi:MethodInfo = new MethodInfo();
			mi.methodName = "";
			mi.returnType = MultinameUtil.toQualifiedName(BuiltIns.ANY.fullName, NamespaceKind.NAMESPACE);
			var mb:IMethodBodyBuilder = new MethodBodyBuilder();
			mb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.findpropstrict, [mn]) //
				.addOpcode(Opcode.pushnull) //
				.addOpcode(Opcode.newclass, [classInfo]) //
				.addOpcode(Opcode.initproperty, [mn]) //
				.addOpcode(Opcode.returnvoid);
			mi.methodBody = mb.buildBody();
			mi.methodBody.methodSignature = mi;
			return mi;
		}

		/**
		 * Creates a <code>MethodInfo</code> instance that represents the initializer method for a <code>ScriptInfo</code>.
		 * @param className The class name associated with the <code>ScriptInfo</code>.
		 * @param superClass The super class name associated with the <code>ScriptInfo</code>.
		 * @param classInfo The <code>ClassInfo</code> name associated with the <code>ScriptInfo</code>.
		 * @param applicationDomain The <code>ApplicationDomain</code> used to lookup the <code>superClass</code>.
		 * @return The new <code>MethodInfo</code> instance.
		 */
		protected function createClassScriptInitializer(className:String, superClass:BaseMultiname, classInfo:ClassInfo, applicationDomain:ApplicationDomain):MethodInfo {
			var superClassName:String = "";
			if (superClass is QualifiedName) {
				superClassName = QualifiedName(superClass).fullName;
			} else if (superClass is NamedMultiname) {
				superClassName = NamedMultiname(superClass).name;
			}
			var mi:MethodInfo = new MethodInfo();
			mi.methodName = "";
			mi.returnType = MultinameUtil.toQualifiedName(BuiltIns.ANY.fullName, NamespaceKind.NAMESPACE);
			var mb:IMethodBodyBuilder = new MethodBodyBuilder();
			mb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getscopeobject, [0]);
			var extendedClasses:Array = extractExtendedClasses(superClassName, applicationDomain);
			if (superClassName == BuiltIns.OBJECT.fullName) {
				extendedClasses = [BuiltIns.OBJECT.fullName].concat(extendedClasses);
			}
			extendedClasses[extendedClasses.length] = superClassName;
			if (superClassName != BuiltIns.OBJECT.fullName) {
				extendedClasses[extendedClasses.length] = superClassName;
			}
			var popscopes:Array = [];
			var mn:QualifiedName;
			var len:int = extendedClasses.length;
			for (var i:int = 0; i < len; i++) {
				var clsName:String = extendedClasses[i];
				mn = MultinameUtil.toQualifiedName(clsName);
				mb.addOpcode(Opcode.findpropstrict, [mn]) //
					.addOpcode(Opcode.getproperty, [mn]);
				if (i < (len - 1)) {
					mb.addOpcode(Opcode.pushscope);
					popscopes[popscopes.length] = new Op(Opcode.popscope);
				}
			}
			mn = MultinameUtil.toQualifiedName(className);
			mb.addOpcode(Opcode.newclass, [classInfo]);
			mb.addOpcodes(popscopes);
			mb.addOpcode(Opcode.initproperty, [mn]);
			mb.addOpcode(Opcode.returnvoid);
			mi.methodBody = mb.buildBody();
			mi.methodBody.methodSignature = mi;
			return mi;
		}

		protected function extractExtendedClasses(superClassname:String, applicationDomain:ApplicationDomain):Array {
			var extendedClasses:Array = [];
			if (applicationDomain.hasDefinition(superClassname)) {
				var type:Type = Type.forName(superClassname, applicationDomain);
				return type.extendsClasses.reverse();
			} else {
				var packageName:String = MultinameUtil.extractPackageName(superClassname);
				var packageBuilder:PackageBuilder = _packageBuilders[packageName];
				if (packageBuilder != null) {
					packageBuilder.extractExtendeClasses(extendedClasses, superClassname, applicationDomain);
				}
			}
			return extendedClasses;
		}

		/**
		 * Adds the specified <code>MethodInfo</code>, its associated <code>MethodBody</code> and, if present,
		 * its associated <code>Metadata</code> entries to the specified <code>AbcFile</code>.
		 * @param abcFile the specified <code>AbcFile</code>.
		 * @param methodInfo the specified <code>MethodInfo</code>.
		 */
		protected function addMethodInfo(abcFile:AbcFile, methodInfo:MethodInfo):void {
			abcFile.addMethodInfo(methodInfo);
			if (methodInfo.methodBody != null) {
				abcFile.addMethodBody(methodInfo.methodBody);
			}
			if ((methodInfo.as3commonsByteCodeAssignedMethodTrait != null) && (methodInfo.as3commonsByteCodeAssignedMethodTrait.hasMetadata)) {
				for each (var mdi:Metadata in methodInfo.as3commonsByteCodeAssignedMethodTrait.metadata) {
					abcFile.addMetadataInfo(mdi);
				}
			}
		}

	}

}