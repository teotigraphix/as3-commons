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

	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMetaDataBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IVariableBuilder;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.StringUtils;

	public class ClassBuilder extends BaseBuilder implements IClassBuilder {

		private static const MULTIPLE_CONSTRUCTORS_ERROR:String = "A class can only have one constructor defined";
		private static const OBJECT_BASE_CLASS_NAME:String = "Object";

		private var _ctorBuilder:ICtorBuilder;
		private var _implementedInterfaceNames:Array;
		private var _methodBuilders:Array;
		private var _accessorBuilders:Array;
		private var _variableBuilders:Array;
		private var _superClassName:String = OBJECT_BASE_CLASS_NAME;
		private var _isDynamic:Boolean = false;
		private var _isFinal:Boolean;
		private var _isProtected:Boolean;
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
		}

		public function get superClassName():String {
			return _superClassName;
		}

		public function set superClassName(value:String):void {
			_superClassName = value;
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
			var _ctorBuilder:ICtorBuilder = new CtorBuilder(this.name);
			_ctorBuilder.packageName = packageName
			return _ctorBuilder;
		}

		public function defineMethod():IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.packageName = packageName;
			_methodBuilders[_methodBuilders.length] = mb;
			return mb;
		}

		public function defineAccessor():IAccessorBuilder {
			var ab:AccessorBuilder = new AccessorBuilder();
			ab.packageName = packageName;
			_accessorBuilders[_accessorBuilders.length] = ab;
			return ab;
		}

		public function defineVariable():IVariableBuilder {
			var vb:VariableBuilder = new VariableBuilder();
			vb.packageName = packageName;
			_variableBuilders[_variableBuilders.length] = vb;
			return vb;
		}

		public function build():Array {
			var methods:Array = createMethods(metadata);
			var variableTraits:Array = createVariables();
			methods = methods.concat(createAccessors(variableTraits));
			var ci:ClassInfo = createClassInfo(methods, variableTraits);
			var ii:InstanceInfo = createInstanceInfo();
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

		private function createMethods(metadata:Array):Array {
			var result:Array = [];
			for each (var mb:IMethodBuilder in _methodBuilders) {
				var arr:Array = mb.build();
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

		protected function createInstanceInfo():InstanceInfo {
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
			if (_ctorBuilder == null) {
				_ctorBuilder = createDefaultConstructor();
			}
			ii.instanceInitializer = _ctorBuilder.build()[0];
			for each (var interfaceName:String in _implementedInterfaceNames) {
				ii.interfaceMultinames[ii.interfaceMultinames.length] = MultinameUtil.toQualifiedName(interfaceName);
			}
			return ii;
		}

		protected function createClassInfo(methodInfos:Array, variableTraits:Array):ClassInfo {
			var ci:ClassInfo = new ClassInfo();
			var cb:ICtorBuilder = createStaticConstructor();
			cb.isStatic = true;
			ci.staticInitializer = cb.build()[0];
			return ci;
		}

		protected function createDefaultConstructor():ICtorBuilder {
			var ctorBuilder:ICtorBuilder = defineConstructor();
			ctorBuilder.defineMethodBody().addOpcode(new Op(Opcode.getlocal_0)).addOpcode(new Op(Opcode.pushscope)).addOpcode(new Op(Opcode.returnvoid));
			return ctorBuilder;
		}

		protected function createStaticConstructor():ICtorBuilder {
			var ctorBuilder:ICtorBuilder = defineConstructor();
			return ctorBuilder;
		}

	}
}