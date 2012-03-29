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
package org.as3commons.bytecode.util {
	import flash.utils.Dictionary;

	public final class StringLookup {

		private static const UNDERSCORE:String = '_';
		private static const RESERVED_WORDS:Object = {_hasOwnProperty: true, //
				_isPrototypeOf: true, //
				_propertyIsEnumerable: true, //
				_setPropertyIsEnumerable: true, //
				_toLocaleString: true, //
				_toString: true, //
				_valueOf: true, //
				_prototype: true, //
				_constructor: true}
		private var _internalLookup:Dictionary = new Dictionary();

		private static const prefix:String = (9999 + Math.floor(Math.random() * 9999)).toString() + UNDERSCORE;

		public function StringLookup() {
			super();
		}

		protected function makeValidKey(value:String):String {
			if (RESERVED_WORDS[UNDERSCORE + value] == true) {
				return prefix + value;
			}
			return value;
		}

		public function contains(str:String):Boolean {
			var key:String = makeValidKey(str);
			return (_internalLookup[key] != null);
		}

		public function set(str:String, index:int):void {
			var key:String = makeValidKey(str);
			_internalLookup[key] = index;
		}

		public function get(str:String):* {
			var key:String = makeValidKey(str);
			return _internalLookup[key];
		}

		public function remove(str:String):void {
			var key:String = makeValidKey(str);
			delete _internalLookup[key];
		}

	}
}
