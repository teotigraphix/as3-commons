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
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.emit.IEmitObject;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.StringUtils;

	/**
	 * Base class for all emit builder classes, provides stubs for all the shared properties.
	 * @author Roland Zwaga
	 */
	public class BaseBuilder implements IEmitObject {

		private static const NOT_IMPLEMENTED_ERROR:String = "buildTrait is not implemented in BaseBuilder base class.";

		private static const PUBLIC_NAMESPACE_NAME:String = "";
		private static const PROTECTED_NAMESPACE_NAME:String = "";
		private static const PRIVATE_NAMESPACE_NAME:String = "private"
		private static const INTERNAL_NAMESPACE_NAME:String = "";
		protected static const TRAIT_MULTINAME_DIVIDER:String = ":";
		protected static const VISIBILITY_LOOKUP:Dictionary = new Dictionary();
		{
			VISIBILITY_LOOKUP[MemberVisibility.PUBLIC] = PUBLIC_NAMESPACE_NAME;
			VISIBILITY_LOOKUP[MemberVisibility.PRIVATE] = PRIVATE_NAMESPACE_NAME;
			VISIBILITY_LOOKUP[MemberVisibility.INTERNAL] = INTERNAL_NAMESPACE_NAME;
			VISIBILITY_LOOKUP[MemberVisibility.PROTECTED] = PROTECTED_NAMESPACE_NAME;
		}

		private var _packageName:String;
		private var _name:String;
		private var _namespace:String;
		private var _visibility:MemberVisibility;
		private var _trait:TraitInfo;

		/**
		 * Creates a new <code>BaseBuilder</code> instance.
		 * @param name The specified name for the generated object.
		 * @param visibility The visibility that will be assigned to the generated object.
		 * @param nameSpace The namespace that will be assigned to the generated object.
		 */
		public function BaseBuilder(name:String = null, visibility:MemberVisibility = null, nameSpace:String = null) {
			super();
			init(name, nameSpace, visibility);
		}

		/**
		 * Initializes the current <code>BaseBuilder</code> instance.
		 * @param name The specified name for the generated object.
		 * @param visibility The visibility that will be assigned to the generated object.
		 * @param nameSpace The namespace that will be assigned to the generated object.
		 */
		protected function init(name:String, nameSpace:String, visibility:MemberVisibility):void {
			_name = name;
			_namespace = nameSpace;
			if (visibility != null) {
				_visibility = visibility;
			} else {
				_visibility = MemberVisibility.PUBLIC;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get packageName():String {
			return _packageName;
		}

		/**
		 * @private
		 */
		public function set packageName(value:String):void {
			_packageName = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get namespace():String {
			return _namespace;
		}

		/**
		 * @private
		 */
		public function set namespace(value:String):void {
			_namespace = value;
			if (StringUtils.hasText(_namespace)) {
				visibility = MemberVisibility.NAMESPACE;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get visibility():MemberVisibility {
			return _visibility;
		}

		/**
		 * @private
		 */
		public function set visibility(value:MemberVisibility):void {
			_visibility = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get trait():TraitInfo {
			return _trait;
		}

		/**
		 * @private
		 */
		public function set trait(value:TraitInfo):void {
			_trait = value;
		}

		/**
		 * @inheritDoc
		 */
		protected function buildTrait():TraitInfo {
			throw new IllegalOperationError(NOT_IMPLEMENTED_ERROR);
		}

		protected function createTraitNamespace():LNamespace {
			switch (visibility) {
				case MemberVisibility.PUBLIC:
					return new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "");
					break;
				case MemberVisibility.PRIVATE:
					return MultinameUtil.toLNamespace(packageName, NamespaceKind.PRIVATE_NAMESPACE);
					break;
				case MemberVisibility.INTERNAL:
					return MultinameUtil.toLNamespace(packageName, NamespaceKind.PACKAGE_INTERNAL_NAMESPACE);
					break;
				case MemberVisibility.NAMESPACE:
					return new LNamespace(NamespaceKind.NAMESPACE, namespace);
					break;
				case MemberVisibility.PROTECTED:
					return MultinameUtil.toLNamespace(packageName, NamespaceKind.PROTECTED_NAMESPACE);
					break;
			}
			return null
		}

	}
}