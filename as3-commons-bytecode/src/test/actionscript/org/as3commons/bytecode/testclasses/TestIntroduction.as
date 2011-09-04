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
package org.as3commons.bytecode.testclasses {

	public class TestIntroduction implements ITestIntroduction {

		private var _test:String = "test";
		private var _testString:String = "testString";

		private var _testObject:SimpleClassWithAccessors;

		public function TestIntroduction() {
			super();
			_testObject = new SimpleClassWithAccessors();
		}

		private function internalGetTest():String {
			return _test;
		}

		public function getTest():String {
			try {
				return internalGetTest();
			} catch (e:Error) {
				trace("");
			}
			return "";
		}

		public function testSwitch(idx:int):String {
			switch (idx) {
				case 1:
					return "1";
					break;
				case 2:
					return "2";
					break;
				default:
					break;
			}
			if (1 == 2) {
				return "0";
			}
			switch (idx) {
				case 3:
					return "3";
					break;
				case 4:
					return "4";
					break;
				default:
					return "0";
			}
		}

		public function get testString():String {
			return _testString;
		}

		public function set testString(value:String):void {
			_testString = value;
		}

		public function get testObject():SimpleClassWithAccessors {
			return _testObject;
		}

		public function testBoolean(str:String):Boolean {
			if (str == null) {
				return true;
			} else {
				return false;
			}
		}

	}
}
