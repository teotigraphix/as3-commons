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
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.Multiname;
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
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Type;

	public class AbcBuilder implements IAbcBuilder {

		private static const PACKAGE_NAME_EXISTS_ERROR:String = "Package with name {0} is already defined.";
		private static const SCRIPT_INFO_METHOD_NAME:String = "script{0}$init";

		private var _packageBuilders:Dictionary;

		public function AbcBuilder() {
			super();
			init();
		}

		private function init():void {
			_packageBuilders = new Dictionary;
		}

		public function definePackage(name:String):IPackageBuilder {
			if (_packageBuilders[name] != null) {
				throw new IllegalOperationError(StringUtils.substitute(PACKAGE_NAME_EXISTS_ERROR, name));
			}
			var pb:PackageBuilder = new PackageBuilder(name);
			_packageBuilders[name] = pb;
			return pb;
		}

		/**
		 * Returns an <code>AbcFile</code> containing all the generated type information,
		 * ready to be loaded into an AVM.
		 * @return The specified <code>AbcFile</code>.
		 */
		public function build(applicationDomain:ApplicationDomain = null):AbcFile {
			var abcFile:AbcFile = new AbcFile();
			var classNames:Array = [];
			applicationDomain = (applicationDomain) ? applicationDomain : ApplicationDomain.currentDomain;
			var idx:uint = 0;
			for each (var pb:IPackageBuilder in _packageBuilders) {
				var arr:Array = pb.build(applicationDomain);
				for each (var inst:Object in arr) {
					if (inst is ClassInfo) {
						var classInfo:ClassInfo = ClassInfo(inst);
						abcFile.addClassInfo(classInfo);
						abcFile.addMethodInfo(classInfo.staticInitializer);
						abcFile.addMethodBody(classInfo.staticInitializer.methodBody);
					} else if (inst is InstanceInfo) {
						var instanceInfo:InstanceInfo = InstanceInfo(inst);
						abcFile.addInstanceInfo(instanceInfo);
						abcFile.addMethodInfo(instanceInfo.instanceInitializer);
						abcFile.addMethodBody(instanceInfo.instanceInitializer.methodBody);
						var scriptInfo:ScriptInfo = createScriptInfo(InstanceInfo(inst).classMultiname.fullName, InstanceInfo(inst).superclassMultiname, InstanceInfo(inst).classInfo, applicationDomain, idx++);
						abcFile.addScriptInfo(scriptInfo);
						abcFile.addMethodInfo(scriptInfo.scriptInitializer);
						abcFile.addMethodBody(scriptInfo.scriptInitializer.methodBody);
					} else if (inst is MethodInfo) {
						addMethodInfo(abcFile, MethodInfo(inst));
					} else if (inst is Metadata) {
						abcFile.addMetadataInfo(Metadata(inst));
					}
				}
			}
			return abcFile;
		}

		protected function createScriptInfo(className:String, superClass:BaseMultiname, classInfo:ClassInfo, applicationDomain:ApplicationDomain, index:uint):ScriptInfo {
			var scriptInfo:ScriptInfo = new ScriptInfo();
			scriptInfo.scriptInitializer = createScriptInitializer(className, superClass, classInfo, applicationDomain);
			scriptInfo.traits[scriptInfo.traits.length] = createClassTrait(className, index);
			return scriptInfo;
		}

		protected function createClassTrait(className:String, index:uint):ClassTrait {
			var trait:ClassTrait = new ClassTrait();
			trait.classIndex = index;
			trait.traitKind = TraitKind.CLASS;
			trait.traitMultiname = MultinameUtil.toQualifiedName(className);
			return trait;
		}

		protected function createScriptInitializer(className:String, superClass:BaseMultiname, classInfo:ClassInfo, applicationDomain:ApplicationDomain):MethodInfo {
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
			mb.addOpcode(new Op(Opcode.getlocal_0)) //
				.addOpcode(new Op(Opcode.pushscope)) //
				.addOpcode(new Op(Opcode.getscopeobject, [0]));
			var type:Type = Type.forName(superClassName, applicationDomain);
			var extendedClasses:Array = type.extendsClasses.reverse();
			extendedClasses[extendedClasses.length] = superClassName;
			extendedClasses[extendedClasses.length] = className;
			var popscopes:Array = [];
			var mn:QualifiedName;
			for each (var clsName:String in extendedClasses) {
				mn = MultinameUtil.toQualifiedName(clsName);
				mb.addOpcode(new Op(Opcode.findpropstrict, [mn])) //
					.addOpcode(new Op(Opcode.getproperty, [mn])) //
					.addOpcode(new Op(Opcode.pushscope));
				popscopes[popscopes.length] = new Op(Opcode.popscope);
			}
			mn = MultinameUtil.toQualifiedName(className);
			mb.addOpcode(new Op(Opcode.newclass, [classInfo]));
			mb.addOpcodes(popscopes);
			mb.addOpcode(new Op(Opcode.initproperty, [mn]));
			mb.addOpcode(new Op(Opcode.returnvoid));
			mi.methodBody = mb.build();
			mi.methodBody.methodSignature = mi;
			mi.methodBody.maxScopeDepth++;
			mi.methodBody.maxStack = 2;
			return mi;
		}

		protected function addMethodInfo(abcFile:AbcFile, methodInfo:MethodInfo):void {
			abcFile.addMethodInfo(methodInfo);
			abcFile.addMethodBody(methodInfo.methodBody);
		}

	}

}