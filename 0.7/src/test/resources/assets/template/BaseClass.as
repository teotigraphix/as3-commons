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
// compile with asc -md BaseClass.as
package org.as3commons.bytecode.template {

	public class BaseClass {
		public function BaseClass(constructorArg1:String, constructorArg2:String) {
			trace("BaseClass::constructor()");
		}

		public function methodCallOne(arg1:String, arg2:Number):int {
			trace("BaseClass::methodCallOne()");
			return 100;
		}

		public function methodCallTwo(arg1:String, arg2:Number, arg3:Object):void {
			trace("BaseClass::methodCallTwo()");
		}

		public function methodCallThree(arg1:String, arg2:Number):String {
			trace("BaseClass::methodCallThree()");
			return "stringValue";
		}
	}
}