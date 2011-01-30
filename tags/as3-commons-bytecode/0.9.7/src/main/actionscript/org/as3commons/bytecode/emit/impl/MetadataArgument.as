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

	public class MetadataArgument {
		private var _key:String;
		private var _value:String;

		public function MetadataArgument(key:String = null, value:String = null) {
			super();
			_key = key;
			_value = value;
		}

		public function get key():String {
			return _key;
		}

		public function set key(value:String):void {
			_key = value;
		}

		public function get value():String {
			return _value;
		}

		public function set value(v:String):void {
			_value = v;
		}
	}
}