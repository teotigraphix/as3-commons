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
package org.as3commons.bytecode.emit.enum {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.BaseEnum;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.lang.Assert;

	/**
	 * Determines the visibility of a member in an <code>AbcFile</code>.
	 * @author Roland Zwaga
	 */
	public final class MemberVisibility extends BaseEnum {

		private static const _items:Dictionary = new Dictionary();

		private static var _enumCreated:Boolean = false;

		/**
		 * Determines the public visibility.
		 */
		public static const PUBLIC:MemberVisibility = new MemberVisibility(PUBLIC_VALUE);
		/**
		 * Determines the protected visibility.
		 */
		public static const PROTECTED:MemberVisibility = new MemberVisibility(PROTECTED_VALUE);
		/**
		 * Determines the private visibility.
		 */
		public static const PRIVATE:MemberVisibility = new MemberVisibility(PRIVATE_VALUE);
		/**
		 * Determines the custom namespace visibility.
		 */
		public static const NAMESPACE:MemberVisibility = new MemberVisibility(NAMESPACE_VALUE);
		/**
		 * Determines the internal visibility.
		 */
		public static const INTERNAL:MemberVisibility = new MemberVisibility(INTERNAL_VALUE);

		private static const PUBLIC_VALUE:String = "public";
		private static const PROTECTED_VALUE:String = "protected";
		private static const PRIVATE_VALUE:String = "private";
		private static const NAMESPACE_VALUE:String = "namespace";
		private static const INTERNAL_VALUE:String = "internal";

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>MemberVisibility</code> instance.
		 * @param val The enum value.
		 */
		public function MemberVisibility(val:*) {
			Assert.state(!_enumCreated, "MemberVisibility enum has already been created");
			super(val);
			_items[val] = this;
		}

		/**
		 * Determines the <code>MemberVisibility</code> by the specified <code>String</code>.
		 * @param value The specified <code>String</code>.
		 * @return The <code>MemberVisibility</code> specified by the <code>String</code>, or null if no associated <code>MemberVisibility</code> was found.
		 */
		public static function fromValue(value:String):MemberVisibility {
			return _items[value] as MemberVisibility;
		}
	}
}