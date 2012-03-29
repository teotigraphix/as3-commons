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
package org.as3commons.bytecode.io {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;

	/**
	 * Determines the way that an <code>AbcDeserializer</code> handles method bodies.
	 * @author Roland Zwaga
	 */
	public final class MethodBodyExtractionKind {

		private static var _enumCreated:Boolean = false;
		private static const _items:Dictionary = new Dictionary();

		/**
		 * Fully parses and verifies the methodbody.
		 */
		public static const PARSE:MethodBodyExtractionKind = new MethodBodyExtractionKind(PARSE_VALUE);
		/**
		 * Skips the extraction of method bodies altogether.
		 */
		public static const SKIP:MethodBodyExtractionKind = new MethodBodyExtractionKind(SKIP_VALUE);
		/**
		 * Copies the method body into a separate <code>ByteArray</code>.
		 */
		public static const BYTEARRAY:MethodBodyExtractionKind = new MethodBodyExtractionKind(BYTEARRAY_VALUE);

		private static const PARSE_VALUE:String = "parseMethodBody";
		private static const SKIP_VALUE:String = "skipMethodBody";
		private static const BYTEARRAY_VALUE:String = "byteArrayMethodBody";

		{
			_enumCreated = true;
		}

		private var _value:String;

		public function MethodBodyExtractionKind(val:String) {
			CONFIG::debug {
				Assert.state(!_enumCreated, "The MethodBodyExtractionMethod enumeration has already been created");
				Assert.hasText(val, "val argument must have text");
			}
			_value = val;
			_items[_value] = this;
		}

		public function get value():String {
			return _value;
		}

		public static function fromValue(val:String):MethodBodyExtractionKind {
			return _items[val] as MethodBodyExtractionKind;
		}

		public function toString():String {
			return "MethodBodyExtractionMethod[_value:\"" + _value + "\"]";
		}

	}
}