/*
 * Copyright 2007-2011 the original author or authors.
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
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.event.AccessorBuilderEvent;
	import org.as3commons.bytecode.emit.util.BuildUtil;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.as3commons_reflect;

	/**
	 *
	 */
	[Event(name="buildGetter", type="org.as3commons.bytecode.emit.event.AccessorBuilderEvent")]
	/**
	 *
	 */
	[Event(name="buildSetter", type="org.as3commons.bytecode.emit.event.AccessorBuilderEvent")]
	/**
	 * Generates a setter and/or getter method along with an optional private property
	 * that together form an accessor on a class.
	 * @author Roland Zwaga
	 */
	public class AccessorBuilder extends PropertyBuilder implements IAccessorBuilder {

		public static const PRIVATE_VAR_NAME_TEMPLATE:String = "_{0}";
		public static const GETTER_SUFFIX:String = '/get';
		public static const SETTER_SUFFIX:String = '/set';
		public static const ACCESSOR_NAME:String = '{0}/{1}{2}{3}';

		private var _access:AccessorAccess;
		private var _property:IPropertyBuilder;
		private var _getterMethodInfo:MethodInfo;
		private var _setterMethodInfo:MethodInfo;
		private var _createPrivateProperty:Boolean = true;

		as3commons_bytecode function setGetter(getterMethodInfo:MethodInfo):void {
			Assert.notNull(getterMethodInfo, "getterMethodInfo argument must not be null");
			_getterMethodInfo = getterMethodInfo;
		}

		as3commons_bytecode function setSetter(setterMethodInfo:MethodInfo):void {
			Assert.notNull(setterMethodInfo, "setterMethodInfo argument must not be null");
			_setterMethodInfo = setterMethodInfo;
		}

		/**
		 * Creates a new <code>AccessorBuilder</code> instance.
		 */
		public function AccessorBuilder() {
			super();
			_access = AccessorAccess.READ_WRITE;
		}

		/**
		 * @inheritDoc
		 */
		public function get access():AccessorAccess {
			return _access;
		}

		/**
		 * @private
		 */
		public function set access(value:AccessorAccess):void {
			_access = value;
		}

		/**
		 * <p>Creates a getter method, a setter method and a property based on the <code>AccessorAccess</code>
		 * value.</p>
		 * @inheritDoc
		 */
		override public function build():Object {
			var result:Array = [];
			var mb:IMethodBuilder;
			var mi:MethodInfo;

			var trait:SlotOrConstantTrait = (_createPrivateProperty) ? createSlotTrait() : null;

			if (trait != null) {
				result[result.length] = trait;
			}

			var event:AccessorBuilderEvent;
			if ((_access === AccessorAccess.READ_ONLY) || (_access === AccessorAccess.READ_WRITE)) {
				event = new AccessorBuilderEvent(AccessorBuilderEvent.BUILD_GETTER, this, trait);
				dispatchEvent(event);
				mb = (event.builder != null) ? event.builder : createGetter(trait);
				mi = mb.build();
				mi.methodName = createAccessorName(GETTER_SUFFIX);
				result[result.length] = mi;
				mb.trait.traitKind = TraitKind.GETTER;
			}
			if ((_access === AccessorAccess.WRITE_ONLY) || (_access === AccessorAccess.READ_WRITE)) {
				event = new AccessorBuilderEvent(AccessorBuilderEvent.BUILD_SETTER, this, trait);
				dispatchEvent(event);
				mb = (event.builder != null) ? event.builder : createGetter(trait);
				mi = mb.build();
				mi.methodName = createAccessorName(SETTER_SUFFIX);
				result[result.length] = mi;
				mb.trait.traitKind = TraitKind.SETTER;
			}
			return result;
		}

		/**
		 * When no <code>property</code> value has been explicitly assigned, a default <code>PropertyBuilder</code>
		 * is created, otherwise the specified <code>PropertyBuilder</code> is used to return the specified <code>SlotOrConstantTrait</code>.
		 * @return The specified <code>SlotOrConstantTrait</code>
		 */
		protected function createSlotTrait():SlotOrConstantTrait {
			if (_property == null) {
				_property = createDefaultPropertyBuilder();
			}
			return SlotOrConstantTrait(_property.build());
		}

		/**
		 * Returns the abc accessor name.
		 * @param suffix The suffix for the accessor name (/get or /set)
		 * @return The specified accessor name.
		 *
		 */
		protected function createAccessorName(suffix:String):String {
			var scope:String = "";
			switch (visibility) {
				case MemberVisibility.PROTECTED:
					scope = "protected:"
					break;
				case MemberVisibility.PRIVATE:
					scope = "private:"
					break;
				case MemberVisibility.NAMESPACE:
					scope = scopeName + ":"
					break;
				case MemberVisibility.INTERNAL:
					scope = packageName.split(MultinameUtil.SINGLE_COLON)[0] + ":"
					break;
			}
			return StringUtils.substitute(ACCESSOR_NAME, packageName, scope, name, suffix);
		}


		/**
		 * @inheritDoc
		 */
		public function get property():IPropertyBuilder {
			return _property;
		}

		/**
		 * @private
		 */
		public function set property(value:IPropertyBuilder):void {
			_property = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get createPrivateProperty():Boolean {
			return _createPrivateProperty;
		}

		/**
		 * @private
		 */
		public function set createPrivateProperty(value:Boolean):void {
			_createPrivateProperty = value;
		}

		/**
		 * Creates a default <code>IMethodBuilder</code> to be used for the getter or setter method.
		 * @return The specified <code>IMethodBuilder</code>
		 */
		protected function createMethod(methodInfo:MethodInfo):IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.name = name;
			mb.namespaceURI = namespaceURI;
			mb.scopeName = scopeName;
			mb.isFinal = isFinal;
			mb.isOverride = isOverride;
			mb.isStatic = isStatic;
			mb.packageName = packageName;
			if (methodInfo != null) {
				mb.as3commons_bytecode::setMethodInfo(methodInfo);
			}
			return mb;
		}

		/**
		 * Creates the <code>IMethodBuilder</code> used for the getter method.
		 * @param trait The <code>SlotOrConstantTrait</code> associated with the getter method.
		 * @return The specified <code>IMethodBuilder</code>
		 */
		protected function createGetter(trait:SlotOrConstantTrait):IMethodBuilder {
			var mb:IMethodBuilder = createMethod(_getterMethodInfo);
			mb.returnType = type;
			addGetterOpcodes(mb, trait);
			return mb;
		}

		/**
		 * Creates the method body for the getter method.
		 * @param mb The <code>IMethodBuilder</code> that will generate the getter method.
		 * @param trait The <code>SlotOrConstantTrait</code> associated with the getter method.
		 */
		protected function addGetterOpcodes(mb:IMethodBuilder, trait:SlotOrConstantTrait):void {
			mb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.getproperty, [trait.traitMultiname]) //
				.addOpcode(Opcode.returnvalue);
		}

		/**
		 * Creates the <code>IMethodBuilder</code> used for the setter method.
		 * @param trait The <code>SlotOrConstantTrait</code> associated with the setter method.
		 * @return The specified <code>IMethodBuilder</code>
		 */
		protected function createSetter(trait:SlotOrConstantTrait):IMethodBuilder {
			var mb:IMethodBuilder = createMethod(_setterMethodInfo);
			mb.returnType = BuiltIns.VOID.fullName;
			mb.defineArgument(type);
			addSetterOpcodes(mb, trait);
			return mb;
		}

		/**
		 * Creates the method body for the setter method.
		 * @param mb The <code>IMethodBuilder</code> that will generate the setter method.
		 * @param trait The <code>SlotOrConstantTrait</code> associated with the setter method.
		 */
		protected function addSetterOpcodes(mb:IMethodBuilder, trait:SlotOrConstantTrait):void {
			mb.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.getlocal_1) //
				.addOpcode(Opcode.initproperty, [trait.traitMultiname]) //
				.addOpcode(Opcode.returnvoid);
		}

		/**
		 * Creates the default <code>IPropertyBuilder</code> that will generate a private
		 * property that holds the value for the accessor.
		 * @return The specified <code>IPropertyBuilder</code>
		 */
		protected function createDefaultPropertyBuilder():IPropertyBuilder {
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

		/**
		 * Returns null, no trait need here
		 * @return null
		 */
		override protected function buildTrait():TraitInfo {
			return null;
		}

	}
}