/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.abc.enum {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of possible values for the kinds of optional arguments to methods in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Optional parameters" in the AVM Spec (page 25)
	 */
	public final class ConstantKind {
		private static var _enumCreated:Boolean = false;
		private static const _TYPES:Dictionary = new Dictionary();

		public static const UNKNOWN:ConstantKind = new ConstantKind(0x0, "UNKNOWN");
		public static const INT:ConstantKind = new ConstantKind(0x03, "int");
		public static const UINT:ConstantKind = new ConstantKind(0x04, "uint");
		public static const DOUBLE:ConstantKind = new ConstantKind(0x06, "double");
		public static const UTF8:ConstantKind = new ConstantKind(0x01, "utf8");
		public static const TRUE:ConstantKind = new ConstantKind(0x0B, "true"); // note that this is B (b, the letter), not 8
		public static const FALSE:ConstantKind = new ConstantKind(0x0A, "false");
		public static const NULL:ConstantKind = new ConstantKind(0x0C, "null");
		public static const UNDEFINED:ConstantKind = new ConstantKind(0x00, "undefined");
		public static const NAMESPACE:ConstantKind = new ConstantKind(0x08, "namespace"); // note that this is 8 (the number), not B
		public static const PACKAGE_NAMESPACE:ConstantKind = new ConstantKind(0x16, "package namespace");
		public static const PACKAGE_INTERNAL_NAMESPACE:ConstantKind = new ConstantKind(0x17, "package internal namespace");
		public static const PROTECTED_NAMESPACE:ConstantKind = new ConstantKind(0x18, "protected namespace");
		public static const EXPLICIT_NAMESPACE:ConstantKind = new ConstantKind(0x19, "explicit namespace");
		public static const STATIC_PROTECTED_NAMESPACE:ConstantKind = new ConstantKind(0x1A, "static protected namespace");
		public static const PRIVATE_NAMESPACE:ConstantKind = new ConstantKind(0x05, "private namespace");

		private var _kind:uint;
		private var _description:String;

		{
			_enumCreated = true;
		}

		public function ConstantKind(optionKind:uint, optionDescription:String) {
			CONFIG::debug {
				Assert.state((!_enumCreated), "ConstantKind enum has already been created");
			}
			_kind = optionKind;
			_description = optionDescription;
			_TYPES[_kind] = this;
		}

		public static function determineKind(kindValue:int):ConstantKind {
			var matchingKind:ConstantKind = _TYPES[kindValue];
			if (matchingKind == null) {
				throw new Error("Unable to match ConstantKind to " + kindValue);
			}
			return matchingKind;
		}

		public static function determineKindFromInstance(instance:*):ConstantKind {
			if (instance is String) {
				return ConstantKind.UTF8;
			} else if (instance is uint) {
				return ConstantKind.UINT;
			} else if (instance is int) {
				return ConstantKind.INT;
			} else if (instance is Number) {
				return ConstantKind.DOUBLE;
			} else if (instance is Boolean) {
				var b:Boolean = (instance as Boolean);
				return (b) ? ConstantKind.TRUE : ConstantKind.FALSE;
			} else if (instance == null) {
				return ConstantKind.NULL;
			}
			return ConstantKind.UNKNOWN;
		}

		public function get value():uint {
			return _kind;
		}

		public function get description():String {
			return _description;
		}

		public function toString():String {
			return StringUtils.substitute("ConstantKind[description={0}]", _description);
		}
	}
}