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
			if (_property == null) {
				_property = createDefaultVariableBuilder();
			}
			var trait:SlotOrConstantTrait = SlotOrConstantTrait(_property.build());
			result[result.length] = trait;
			if ((_access === AccessorAccess.READ_ONLY) || (_access === AccessorAccess.READ_WRITE)) {
				mb = createGetter(trait);
				mi = mb.build();
				mi.methodName = mi.methodName + '/get';
				result[result.length] = mi;
				mb.trait.traitKind = TraitKind.GETTER;
			}
			if ((_access === AccessorAccess.WRITE_ONLY) || (_access === AccessorAccess.READ_WRITE)) {
				mb = createSetter(trait);
				mi = mb.build();
				mi.methodName = mi.methodName + '/set';
				result[result.length] = mi;
				mb.trait.traitKind = TraitKind.SETTER;
			}
			return result;
		}

		public function get property():IPropertyBuilder {
			return _property;
		}

		public function set property(value:IPropertyBuilder):void {
			_property = value;
		}

		protected function createMethod():MethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.name = name;
			mb.packageName = packageName;
			return mb;
		}

		protected function createGetter(trait:SlotOrConstantTrait):IMethodBuilder {
			var mb:IMethodBuilder = createMethod();
			mb.returnType = type;
			var mbb:IMethodBodyBuilder = mb.defineMethodBody();
			mbb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.getproperty, [trait.traitMultiname]) //
				.addOpcode(Opcode.returnvalue);
			return mb;
		}

		protected function createSetter(trait:SlotOrConstantTrait):IMethodBuilder {
			var mb:IMethodBuilder = createMethod();
			mb.returnType = BuiltIns.VOID.fullName;
			mb.defineArgument(type);
			var mbb:IMethodBodyBuilder = mb.defineMethodBody();
			mbb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.getlocal_1) //
				.addOpcode(Opcode.initproperty, [trait.traitMultiname]) //
				.addOpcode(Opcode.returnvoid);
			return mb;
		}

		protected function createDefaultVariableBuilder():IPropertyBuilder {
			var vb:PropertyBuilder = new PropertyBuilder();
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