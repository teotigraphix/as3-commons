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
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class TestProxiedClass extends EventDispatcher {

		private var _getter:String = "testGetterValue";
		private var _getterSetter:uint = 100;

		public var ordinaryProperty:String = "ordinaryValue";

		public function TestProxiedClass(target:IEventDispatcher = null) {
			super(target);
		}

		public function returnString():String {
			return "string";
		}

		public function returnInt():int {
			return 10;
		}

		public function get getter():String {
			return _getter;
		}

		public function get getterSetter():uint {
			return _getterSetter;
		}

		public function set getterSetter(value:uint):void {
			_getterSetter = value;
		}
	}
}