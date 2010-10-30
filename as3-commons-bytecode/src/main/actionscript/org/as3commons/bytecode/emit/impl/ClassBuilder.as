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
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMetaDataBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.util.AbcDeserializer;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Type;

	public class ClassBuilder extends BaseBuilder implements IClassBuilder {

		public static const STATIC_CONSTRUCTOR_NAME:String = "{0}:{1}::{0}:{1}$cinit";
		public static const CONSTRUCTOR_NAME:String = "{0}.{1}/{1}";
		private static const MULTIPLE_CONSTRUCTORS_ERROR:String = "A class can only have one constructor defined";
		private static const PERIOD:String = '.';
		private static const DUPLICATE_METHOD_ERROR:String = "Duplicate method {0}.{1} in class {2}";

		private var _ctorBuilder:ICtorBuilder;
		private var _implementedInterfaceNames:Array;
		private var _methodBuilders:Array;
		protected var _accessorBuilders:Array;
		private var _variableBuilders:Array;
		private var _superClassName:String;
		private var _isDynamic:Boolean = false;
		private var _isFinal:Boolean;
		private var _metadata:Array;
		private var _traits:Array;
		private var _abcFile:AbcFile;
		private var _addedMethods:Dictionary;

		public function ClassBuilder(abcFile:AbcFile = null) {
			super();
			initClassBuilder(_abcFile);
		}

		protected function initClassBuilder(abcFile:AbcFile):void {
			_methodBuilders = [];
			_accessorBuilders = [];
			_variableBuilders = [];
			_implementedInterfaceNames = [];
			_metadata = [];
			_traits = [];
			_superClassName = BuiltIns.OBJECT.fullName;
			_abcFile = abcFile;
			_addedMethods = new Dictionary();
		}

		public function get superClassName():String {
			return _superClassName;
		}

		public function set superClassName(value:String):void {
			if (value != null) {
				_superClassName = value;
			}
		}

		public function get isDynamic():Boolean {
			return _isDynamic;
		}

		public function set isDynamic(value:Boolean):void {
			_isDynamic = value;
		}

		public function get isFinal():Boolean {
			return _isFinal;
		}

		public function set isFinal(value:Boolean):void {
			_isFinal = value;
		}

		public function get metadata():Array {
			return _metadata;
		}

		public function set metadata(value:Array):void {
			_metadata = value;
		}

		public function defineMetaData():IMetaDataBuilder {
			var mdb:MetaDataBuilder = new MetaDataBuilder();
			_metadata[_metadata.length] = mdb;
			return mdb;
		}

		protected function buildMetadata():Array {
			var result:Array = [];
			for each (var mdb:MetaDataBuilder in _metadata) {
				result[result.length] = mdb.build();
			}
			return result;
		}

		public function implementInterface(name:String):void {
			if (_implementedInterfaceNames.indexOf(name) < 0) {
				_implementedInterfaceNames[_implementedInterfaceNames.length] = name;
			}
		}

		public function implementInterfaces(names:Array):void {
			for each (var name:String in names) {
				implementInterface(name);
			}
		}

		public function defineConstructor():ICtorBuilder {
			if (_ctorBuilder == null) {
				_ctorBuilder = new CtorBuilder();
				_ctorBuilder.packageName = packageName;
			}
			return _ctorBuilder;
		}

		public function defineMethod(name:String = null, nameSpace:String = null):IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.packageName = packageName + PERIOD + this.name;
			mb.name = name;
			mb.namespace = nameSpace;
			_methodBuilders[_methodBuilders.length] = mb;
			return mb;
		}

		public function defineAccessor(name:String = null, type:String = null, initialValue:* = undefined):IAccessorBuilder {
			var ab:IAccessorBuilder = createAccessorBuilder(name, type, initialValue);
			_accessorBuilders[_accessorBuilders.length] = ab;
			return ab;
		}

		protected function createAccessorBuilder(name:String, type:String, initialValue:* = undefined):IAccessorBuilder {
			var ab:IAccessorBuilder = new AccessorBuilder();
			ab.packageName = packageName + PERIOD + this.name;
			ab.name = name;
			ab.type = type;
			ab.initialValue = initialValue;
			return ab;
		}

		public function defineProperty(name:String = null, type:String = null, initialValue:* = undefined):IPropertyBuilder {
			var vb:PropertyBuilder = new PropertyBuilder();
			vb.packageName = packageName;
			vb.name = name;
			vb.type = type;
			vb.initialValue = initialValue;
			_variableBuilders[_variableBuilders.length] = vb;
			return vb;
		}

		public function calculateHierarchDepth(className:String, applicationDomain:ApplicationDomain):uint {
			var type:Type = Type.forName(className, applicationDomain);
			var result:uint = 3;
			for each (var name:String in type.extendsClasses) {
				result++;
			}
			return result;
		}

		public function build(applicationDomain:ApplicationDomain):Array {
			var hierarchyDepth:uint = calculateHierarchDepth(superClassName, applicationDomain);
			var methods:Array = createMethods(metadata, (hierarchyDepth + 1));
			var variableTraits:Array = createVariables();
			methods = methods.concat(createAccessors(variableTraits));
			var classInfo:ClassInfo = createClassInfo(variableTraits, hierarchyDepth++);
			var instanceInfo:InstanceInfo = createInstanceInfo(hierarchyDepth);
			instanceInfo.classInfo = classInfo;
			var metadata:Array = buildMetadata();
			for each (var mi:MethodInfo in methods) {
				if (!methodExists(mi)) {
					if (mi.as3commonsByteCodeAssignedMethodTrait.isStatic) {
						classInfo.traits[classInfo.traits.length] = mi.as3commonsByteCodeAssignedMethodTrait;
					} else {
						instanceInfo.traits[instanceInfo.traits.length] = mi.as3commonsByteCodeAssignedMethodTrait;
					}
				} else {
					throw new IllegalOperationError(StringUtils.substitute(DUPLICATE_METHOD_ERROR, mi.as3commonsByteCodeAssignedMethodTrait.traitMultiname.nameSpace.name, mi.methodName, this.name));
				}
			}

			for each (var st:SlotOrConstantTrait in variableTraits) {
				if (st.isStatic) {
					classInfo.traits[classInfo.traits.length] = st;
				} else {
					instanceInfo.traits[instanceInfo.traits.length] = st;
				}
			}
			return [classInfo, instanceInfo, methods, metadata];
		}

		protected function createVariables():Array {
			var result:Array = [];
			for each (var vb:IPropertyBuilder in _variableBuilders) {
				result[result.length] = vb.build();
			}
			return result;
		}

		protected function createMethods(metadata:Array, initScopeDepth:uint):Array {
			var result:Array = [];
			for each (var mb:IMethodBuilder in _methodBuilders) {
				var mi:MethodInfo = mb.build(initScopeDepth);
				metadata = metadata.concat(mi.as3commonsByteCodeAssignedMethodTrait.metadata);
				result[result.length] = mi;
			}
			return result;
		}

		protected function createAccessors(variableTraits:Array = null):Array {
			var result:Array = [];
			for each (var ab:IAccessorBuilder in _accessorBuilders) {
				var lst:Array = ab.build() as Array;
				for each (var obj:Object in lst) {
					if (obj is MethodInfo) {
						result[result.length] = obj;
					} else if (variableTraits != null) {
						variableTraits[variableTraits.length] = obj;
					}
				}
			}
			return result;
		}

		protected function createInstanceInfo(initScopeDepth:uint):InstanceInfo {
			var ii:InstanceInfo = new InstanceInfo();
			ii.isFinal = isFinal;
			ii.isInterface = false;
			//TODO: inspect methods and properties to see if any of them are protected,
			//based on this set isProtected: 
			//ii.isProtected = isProtected;
			ii.isSealed = !isDynamic;
			ii.classMultiname = MultinameUtil.toQualifiedName(packageName + MultinameUtil.DOUBLE_COLON + name);
			ii.superclassMultiname = MultinameUtil.toQualifiedName((StringUtils.hasText(_superClassName)) ? _superClassName : BuiltIns.OBJECT.fullName);
			if (ii.isProtected) {
				ii.protectedNamespace = MultinameUtil.toLNamespace(packageName + MultinameUtil.DOUBLE_COLON + name, NamespaceKind.PROTECTED_NAMESPACE);
			}
			if (_ctorBuilder == null) {
				_ctorBuilder = createDefaultConstructor();
			}
			ii.instanceInitializer = _ctorBuilder.build();
			ii.instanceInitializer.methodBody.initScopeDepth = initScopeDepth++;
			ii.instanceInitializer.methodBody.maxScopeDepth = initScopeDepth;
			ii.instanceInitializer.methodName = StringUtils.substitute(CONSTRUCTOR_NAME, packageName, name);
			for each (var interfaceName:String in _implementedInterfaceNames) {
				ii.interfaceMultinames[ii.interfaceMultinames.length] = MultinameUtil.toMultiName(interfaceName);
			}
			return ii;
		}

		protected function createClassInfo(variableTraits:Array, initScopeDepth:uint, isInterface:Boolean = false):ClassInfo {
			var staticvariables:Array = [];
			if (variableTraits != null) {
				for each (var slot:SlotOrConstantTrait in variableTraits) {
					if (slot.isStatic) {
						staticvariables[staticvariables.length] = slot;
					}
				}
			}
			var ci:ClassInfo = new ClassInfo();
			var cb:ICtorBuilder = createStaticConstructor(staticvariables, isInterface);
			cb.isStatic = true;
			ci.staticInitializer = cb.build();
			ci.staticInitializer.methodBody.initScopeDepth = initScopeDepth++;
			ci.staticInitializer.methodBody.maxScopeDepth = initScopeDepth;
			ci.staticInitializer.as3commonsBytecodeName = AbcDeserializer.STATIC_INITIALIZER_BYTECODENAME;
			ci.staticInitializer.methodName = StringUtils.substitute(STATIC_CONSTRUCTOR_NAME, packageName, name);
			return ci;
		}

		protected function createDefaultConstructor():ICtorBuilder {
			var ctorBuilder:ICtorBuilder = defineConstructor();
			ctorBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.constructsuper, [0]) //
				.addOpcode(Opcode.returnvoid);
			return ctorBuilder;
		}

		protected function createStaticConstructor(staticvariables:Array, isInterface:Boolean):ICtorBuilder {
			var ctorBuilder:ICtorBuilder = new CtorBuilder();
			ctorBuilder.packageName = packageName;
			if (!isInterface) {
				ctorBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.pushscope);
				for each (var slot:SlotOrConstantTrait in staticvariables) {
					ctorBuilder.addOpcodes(createInitializer(slot));
				}
				ctorBuilder.addOpcode(Opcode.returnvoid);
			}

			return ctorBuilder;
		}

		protected function createInitializer(slot:SlotOrConstantTrait):Array {
			var result:Array = [];
			//TODO: Add slot initialization logic
			return result;
		}

		protected function methodExists(methodInfo:MethodInfo):Boolean {
			Assert.notNull(methodInfo, "methodInfo argument must not be null");
			var methodKey:String = methodInfo.as3commonsByteCodeAssignedMethodTrait.traitMultiname.nameSpace.name + methodInfo.methodName;
			if (_addedMethods[methodKey] == null) {
				_addedMethods[methodKey] = true;
				return false;
			}
			return true;
		}

	}
}