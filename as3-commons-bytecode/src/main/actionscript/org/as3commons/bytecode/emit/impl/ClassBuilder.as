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
	import org.as3commons.bytecode.emit.IVariableBuilder;
	import org.as3commons.bytecode.util.AbcDeserializer;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Type;

	public class ClassBuilder extends BaseBuilder implements IClassBuilder {

		public static const METHOD_NAME:String = "{0}.{1}/{1}";
		private static const MULTIPLE_CONSTRUCTORS_ERROR:String = "A class can only have one constructor defined";

		private var _ctorBuilder:ICtorBuilder;
		private var _implementedInterfaceNames:Array;
		private var _methodBuilders:Array;
		private var _accessorBuilders:Array;
		private var _variableBuilders:Array;
		private var _superClassName:String;
		private var _isDynamic:Boolean = false;
		private var _isFinal:Boolean;
		private var _isProtected:Boolean = true;
		private var _metadata:Array;
		private var _traits:Array;

		public function ClassBuilder() {
			super();
			initClassBuilder();
		}

		protected function initClassBuilder():void {
			_methodBuilders = [];
			_accessorBuilders = [];
			_variableBuilders = [];
			_implementedInterfaceNames = [];
			_metadata = [];
			_traits = [];
			_superClassName = BuiltIns.OBJECT.fullName;
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

		public function get isProtected():Boolean {
			return _isProtected;
		}

		public function set isProtected(value:Boolean):void {
			_isProtected = value;
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

		public function defineConstructor():ICtorBuilder {
			if (_ctorBuilder != null) {
				throw new IllegalOperationError(MULTIPLE_CONSTRUCTORS_ERROR);
			}
			var _ctorBuilder:ICtorBuilder = new CtorBuilder();
			_ctorBuilder.packageName = packageName
			return _ctorBuilder;
		}

		public function defineMethod(name:String = null):IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.packageName = packageName;
			mb.name = name;
			_methodBuilders[_methodBuilders.length] = mb;
			return mb;
		}

		public function defineAccessor():IAccessorBuilder {
			var ab:AccessorBuilder = new AccessorBuilder();
			ab.packageName = packageName;
			_accessorBuilders[_accessorBuilders.length] = ab;
			return ab;
		}

		public function defineVariable(name:String = null, type:String = null, initialValue:* = undefined):IVariableBuilder {
			var vb:VariableBuilder = new VariableBuilder();
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
			var ci:ClassInfo = createClassInfo(variableTraits, hierarchyDepth++);
			var ii:InstanceInfo = createInstanceInfo(hierarchyDepth);
			ii.classInfo = ci;
			var metadata:Array = buildMetadata();
			for each (var mi:MethodInfo in methods) {
				if (mi.as3commonsByteCodeAssignedMethodTrait.isStatic) {
					ci.traits[ci.traits.length] = mi.as3commonsByteCodeAssignedMethodTrait;
				} else {
					ii.traits[ii.traits.length] = mi.as3commonsByteCodeAssignedMethodTrait;
				}
			}

			for each (var st:SlotOrConstantTrait in variableTraits) {
				if (st.isStatic) {
					ci.traits[ci.traits.length] = st;
				} else {
					ii.traits[ii.traits.length] = st;
				}
			}
			return [ci, ii, methods, metadata];
		}

		private function createVariables():Array {
			var result:Array = [];
			for each (var vb:IVariableBuilder in _variableBuilders) {
				result[result.length] = vb.build();
			}
			return result;
		}

		private function createMethods(metadata:Array, initScopeDepth:uint):Array {
			var result:Array = [];
			for each (var mb:IMethodBuilder in _methodBuilders) {
				var arr:Array = mb.build(initScopeDepth);
				var mi:MethodInfo = arr[0];
				metadata = metadata.concat(arr[1]);
				result[result.length] = mi;
			}
			return result;
		}

		protected function createAccessors(variableTraits:Array):Array {
			var result:Array = [];
			for each (var ab:IAccessorBuilder in _accessorBuilders) {
				var lst:Array = ab.build() as Array;
				for each (var obj:Object in lst) {
					if (obj is MethodInfo) {
						result[result.length] = obj;
					} else {
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
			ii.isProtected = isProtected;
			ii.isSealed = !isDynamic;
			ii.classMultiname = MultinameUtil.toQualifiedName(packageName + MultinameUtil.DOUBLE_COLON + name);
			ii.superclassMultiname = MultinameUtil.toQualifiedName((StringUtils.hasText(_superClassName)) ? _superClassName : MultinameUtil.OBJECT_NAME);
			ii.isFinal = isFinal;
			ii.isInterface = false;
			ii.isProtected = isProtected;
			ii.isSealed = !isDynamic;
			if (ii.isProtected) {
				ii.protectedNamespace = MultinameUtil.toLNamespace(packageName + MultinameUtil.DOUBLE_COLON + name, NamespaceKind.PROTECTED_NAMESPACE);
			}
			if (_ctorBuilder == null) {
				_ctorBuilder = createDefaultConstructor();
			}
			ii.instanceInitializer = _ctorBuilder.build()[0];
			ii.instanceInitializer.methodBody.initScopeDepth = initScopeDepth++;
			ii.instanceInitializer.methodBody.maxScopeDepth = initScopeDepth;
			ii.instanceInitializer.methodName = StringUtils.substitute(METHOD_NAME, packageName, name);
			for each (var interfaceName:String in _implementedInterfaceNames) {
				ii.interfaceMultinames[ii.interfaceMultinames.length] = MultinameUtil.toQualifiedName(interfaceName);
			}
			return ii;
		}

		protected function createClassInfo(variableTraits:Array, initScopeDepth:uint):ClassInfo {
			var staticvariables:Array = [];
			for each (var slot:SlotOrConstantTrait in variableTraits) {
				if (slot.isStatic) {
					staticvariables[staticvariables.length] = slot;
				}
			}
			var ci:ClassInfo = new ClassInfo();
			var cb:ICtorBuilder = createStaticConstructor(staticvariables);
			cb.isStatic = true;
			ci.staticInitializer = cb.build()[0];
			ci.staticInitializer.methodBody.initScopeDepth = initScopeDepth++;
			ci.staticInitializer.methodBody.maxScopeDepth = initScopeDepth;
			ci.staticInitializer.as3commonsBytecodeName = AbcDeserializer.STATIC_INITIALIZER_BYTECODENAME;
			return ci;
		}

		protected function createDefaultConstructor():ICtorBuilder {
			var ctorBuilder:ICtorBuilder = defineConstructor();
			ctorBuilder.defineMethodBody() //add default opcodes:
				.addOpcode(new Op(Opcode.getlocal_0)) //
				.addOpcode(new Op(Opcode.pushscope)) //
				.addOpcode(new Op(Opcode.getlocal_0)) //
				.addOpcode(new Op(Opcode.constructsuper, [0])) //
				.addOpcode(new Op(Opcode.returnvoid));
			return ctorBuilder;
		}

		protected function createStaticConstructor(staticvariables:Array):ICtorBuilder {
			var ctorBuilder:ICtorBuilder = defineConstructor();
			var mb:IMethodBodyBuilder = ctorBuilder.defineMethodBody() //add default opcodes:
				.addOpcode(new Op(Opcode.getlocal_0)) //
				.addOpcode(new Op(Opcode.pushscope));
			for each (var slot:SlotOrConstantTrait in staticvariables) {
				mb.addOpcodes(createInitializer(slot));
			}
			mb.addOpcode(new Op(Opcode.returnvoid));
			return ctorBuilder;
		}

		protected function createInitializer(slot:SlotOrConstantTrait):Array {
			var result:Array = [];
			//TODO: Add slot initialization logic
			return result;
		}

	}
}