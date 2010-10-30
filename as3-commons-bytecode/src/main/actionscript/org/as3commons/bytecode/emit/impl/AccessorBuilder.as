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

	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.util.BuildUtil;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.AccessorAccess;

	public class AccessorBuilder extends PropertyBuilder implements IAccessorBuilder {

		private static const PRIVATE_VAR_NAME_TEMPLATE:String = "_{0}";
		private static const GETTER_SUFFIX:String = '/get';
		private static const SETTER_SUFFIX:String = '/set';

		private var _access:AccessorAccess;
		private var _property:IPropertyBuilder;

		public function AccessorBuilder() {
			super();
			_access = AccessorAccess.READ_WRITE;
		}

		public function get access():AccessorAccess {
			return _access;
		}

		public function set access(value:AccessorAccess):void {
			_access = value;
		}

		override public function build():Object {
			var result:Array = [];
			var mb:IMethodBuilder;
			var mi:MethodInfo;

			var trait:SlotOrConstantTrait = createSlotTrait();

			result[result.length] = trait;

			if ((_access === AccessorAccess.READ_ONLY) || (_access === AccessorAccess.READ_WRITE)) {
				mb = createGetter(trait);
				mi = mb.build();
				mi.methodName = createAccessorName(GETTER_SUFFIX);
				result[result.length] = mi;
				mb.trait.traitKind = TraitKind.GETTER;
			}
			if ((_access === AccessorAccess.WRITE_ONLY) || (_access === AccessorAccess.READ_WRITE)) {
				mb = createSetter(trait);
				mi = mb.build();
				mi.methodName = createAccessorName(SETTER_SUFFIX);
				result[result.length] = mi;
				mb.trait.traitKind = TraitKind.SETTER;
			}
			return result;
		}

		protected function createSlotTrait():SlotOrConstantTrait {
			if (_property == null) {
				_property = createDefaultVariableBuilder();
			}
			return SlotOrConstantTrait(_property.build());
		}

		protected function createAccessorName(suffix:String):String {
			return name + suffix;
		}

		public function get property():IPropertyBuilder {
			return _property;
		}

		public function set property(value:IPropertyBuilder):void {
			_property = value;
		}

		protected function createMethod():IMethodBuilder {
			var mb:IMethodBuilder = new MethodBuilder();
			mb.name = name;
			mb.packageName = packageName;
			return mb;
		}

		protected function createGetter(trait:SlotOrConstantTrait):IMethodBuilder {
			var mb:IMethodBuilder = createMethod();
			mb.returnType = type;
			addGetterOpcodes(mb, trait);
			return mb;
		}

		protected function addGetterOpcodes(mb:IMethodBuilder, trait:SlotOrConstantTrait):void {
			mb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.getproperty, [trait.traitMultiname]) //
				.addOpcode(Opcode.returnvalue);
		}

		protected function createSetter(trait:SlotOrConstantTrait):IMethodBuilder {
			var mb:IMethodBuilder = createMethod();
			mb.returnType = BuiltIns.VOID.fullName;
			mb.defineArgument(type);
			addSetterOpcodes(mb, trait);
			return mb;
		}

		protected function addSetterOpcodes(mb:IMethodBuilder, trait:SlotOrConstantTrait):void {
			mb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.getlocal_1) //
				.addOpcode(Opcode.initproperty, [trait.traitMultiname]) //
				.addOpcode(Opcode.returnvoid);
		}

		protected function createDefaultVariableBuilder():IPropertyBuilder {
			var vb:PropertyBuilder = new PropertyBuilder();
			vb.visibility = MemberVisibility.PRIVATE;
			vb.isConstant = isConstant;
			vb.isFinal = isFinal;
			vb.isStatic = isStatic;
			vb.name = StringUtils.substitute(PRIVATE_VAR_NAME_TEMPLATE, name);
			vb.type = type;
			vb.initialValue = initialValue;
			return vb;
		}

		override protected function buildTrait():TraitInfo {
			return null;
		}

	}
}