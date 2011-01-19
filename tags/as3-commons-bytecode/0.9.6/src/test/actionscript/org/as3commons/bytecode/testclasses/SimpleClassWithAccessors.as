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
package org.as3commons.bytecode.testclasses {

	public class SimpleClassWithAccessors {

		private var _getter:int = 10;
		private var _setter:int = 10;

		public function SimpleClassWithAccessors() {
			super();
		}

		public function get getter():int {
			return _getter;
		}

		public function set setter(value:int):void {
			_setter = value;
		}

		public function checkSetter():int {
			return _setter;
		}

	}
}