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
	import org.as3commons.bytecode.as3commons_bytecode;

	public class SimpleClassWithCustomNamespaceMethod {

		private var _customProp:String;
		private var _customSetProp:String;

		public function SimpleClassWithCustomNamespaceMethod() {
			super();
		}

		as3commons_bytecode function custom():String {
			return "customValue";
		}

		as3commons_bytecode function get customProp():String {
			return _customProp;
		}

		as3commons_bytecode function set customSetProp(value:String):void {
			_customSetProp = value;
		}

		public function checkCustomSetter():String {
			return _customSetProp;
		}

	}
}