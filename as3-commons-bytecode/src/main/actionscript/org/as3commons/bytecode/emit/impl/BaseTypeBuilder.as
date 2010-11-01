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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMetaDataBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.ITypeBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.util.AbcDeserializer;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * @author Roland Zwaga
	 */
	public class BaseTypeBuilder extends BaseBuilder implements ITypeBuilder {

		public static const STATIC_CONSTRUCTOR_NAME:String = "{0}:{1}::{0}:{1}$cinit";
		private static const NOT_IMPLEMENTED_ERROR:String = "Not implemented in base class";
		private static const PERIOD:String = '.';
		protected static const DUPLICATE_METHOD_ERROR:String = "Duplicate method {0}.{1} in class {2}";
		private static const CONSTANTKIND_OPCODE_LOOKUP:Dictionary = new Dictionary();
		{
			CONSTANTKIND_OPCODE_LOOKUP[ConstantKind.DOUBLE] = Opcode.pushdouble;
			CONSTANTKIND_OPCODE_LOOKUP[ConstantKind.INT] = Opcode.pushint;
			CONSTANTKIND_OPCODE_LOOKUP[ConstantKind.FALSE] = Opcode.pushfalse;
			CONSTANTKIND_OPCODE_LOOKUP[ConstantKind.TRUE] = Opcode.pushtrue;
			CONSTANTKIND_OPCODE_LOOKUP[ConstantKind.UINT] = Opcode.pushuint;
			CONSTANTKIND_OPCODE_LOOKUP[ConstantKind.UTF8] = Opcode.pushstring;
		}

		private var _methodBuilders:Array;
		private var _accessorBuilders:Array;
		private var _addedMethods:Dictionary;
		private var _metadata:Array;

		public function BaseTypeBuilder(name:String = null, visibility:MemberVisibility = null, nameSpace:String = null) {
			super(name, visibility, nameSpace);
			initBaseTypeBuilder();
		}

		protected function initBaseTypeBuilder():void {
			_methodBuilders = [];
			_accessorBuilders = [];
			_metadata = [];
			_addedMethods = new Dictionary();
		}

		/**
		 * @inheritDoc
		 */
		public function defineMethod(name:String = null, nameSpace:String = null):IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.packageName = packageName + PERIOD + this.name;
			mb.name = name;
			mb.namespace = nameSpace;
			_methodBuilders[_methodBuilders.length] = mb;
			return mb;
		}

		/**
		 * @inheritDoc
		 */
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

		/**
		 * @inheritDoc
		 */
		public function get metadata():Array {
			return _metadata;
		}

		/**
		 * @private
		 */
		public function set metadata(value:Array):void {
			_metadata = value;
		}

		/**
		 * @inheritDoc
		 */
		public function defineMetaData(name:String = null, arguments:Array = null):IMetaDataBuilder {
			var mdb:MetaDataBuilder = new MetaDataBuilder();
			mdb.name = name;
			mdb.arguments = arguments;
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

		protected function createClassInfo(slotTraits:Array, methods:Array, initScopeDepth:uint, isInterface:Boolean = false):ClassInfo {
			var classInfo:ClassInfo = new ClassInfo();
			for each (var mi:MethodInfo in methods) {
				if (!methodExists(mi)) {
					if (MethodTrait(mi.as3commonsByteCodeAssignedMethodTrait).isStatic) {
						classInfo.traits[classInfo.traits.length] = mi.as3commonsByteCodeAssignedMethodTrait;
					}
				} else {
					throw new IllegalOperationError(StringUtils.substitute(DUPLICATE_METHOD_ERROR, mi.as3commonsByteCodeAssignedMethodTrait.traitMultiname.nameSpace.name, mi.methodName, this.name));
				}
			}
			var staticSlots:Array = [];

			if (slotTraits != null) {
				for each (var slot:SlotOrConstantTrait in slotTraits) {
					if (slot.isStatic) {
						staticSlots[staticSlots.length] = slot;
					}
				}
			}
			var cb:ICtorBuilder = createStaticConstructor(staticSlots, isInterface);
			cb.isStatic = true;
			classInfo.staticInitializer = cb.build();
			classInfo.staticInitializer.methodBody.initScopeDepth = initScopeDepth++;
			classInfo.staticInitializer.methodBody.maxScopeDepth = initScopeDepth;
			classInfo.staticInitializer.as3commonsBytecodeName = AbcDeserializer.STATIC_INITIALIZER_BYTECODENAME;
			classInfo.staticInitializer.methodName = StringUtils.substitute(STATIC_CONSTRUCTOR_NAME, packageName, name);
			return classInfo;
		}

		protected function createDefaultConstructor():ICtorBuilder {
			return null;
		}

		protected function createStaticConstructor(staticSlots:Array, isInterface:Boolean):ICtorBuilder {
			var ctorBuilder:ICtorBuilder = new CtorBuilder();
			ctorBuilder.packageName = packageName;
			if (!isInterface) {
				ctorBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.pushscope);
				for each (var slot:SlotOrConstantTrait in staticSlots) {
					ctorBuilder.addOpcodes(createInitializer(slot));
				}
				ctorBuilder.addOpcode(Opcode.returnvoid);
			}

			return ctorBuilder;
		}

		protected function createInitializer(slot:SlotOrConstantTrait):Array {
			var result:Array = [];
			if (!(slot.defaultValue === undefined)) {
				result[result.length] = new Op(Opcode.findproperty, [slot.traitMultiname]);
				result[result.length] = new Op(determinePushOpcode(slot), [slot.defaultValue]);
				result[result.length] = new Op(Opcode.initproperty, [slot.traitMultiname]);
			}
			return result;
		}

		protected function determinePushOpcode(slot:SlotOrConstantTrait):Opcode {
			return Opcode(CONSTANTKIND_OPCODE_LOOKUP[slot.vkind]);
		}

		public function build(applicationDomain:ApplicationDomain):Array {
			throw new IllegalOperationError(NOT_IMPLEMENTED_ERROR);
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