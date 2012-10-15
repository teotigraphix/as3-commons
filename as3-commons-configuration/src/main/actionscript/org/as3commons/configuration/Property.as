/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.configuration {

	/**
	 *
	 * @author rolandzwaga
	 */
	public final class Property {
		private var _name:String;
		private var _value:*;

		/**
		 * Creates a new <code>Property</code> instance.
		 */
		public function Property(name:String, value:*) {
			super();
			_name = name;
			_value = value;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get value():* {
			return _value;
		}

		public function set value(value:*):void {
			_value = value;
		}

	}
}
