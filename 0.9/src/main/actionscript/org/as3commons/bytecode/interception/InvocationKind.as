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
package org.as3commons.bytecode.interception {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public final class InvocationKind {

		private static const ITEMS:Dictionary = new Dictionary();
		private static var _enumCreated:Boolean = false;

		/**
		 * Determines interception of a constructor method.
		 */
		public static const CONSTRUCTOR:InvocationKind = new InvocationKind(CONSTRUCTOR_NAME);
		/**
		 * Determines interception of a method.
		 */
		public static const METHOD:InvocationKind = new InvocationKind(METHOD_NAME);
		/**
		 * Determines interception of a getter method.
		 */
		public static const GETTER:InvocationKind = new InvocationKind(GETTER_NAME);
		/**
		 * Determines interception of a setter method.
		 */
		public static const SETTER:InvocationKind = new InvocationKind(SETTER_NAME);

		private static const CONSTRUCTOR_NAME:String = "constructorInterception";
		private static const METHOD_NAME:String = "methodInterception";
		private static const GETTER_NAME:String = "getterInterception";
		private static const SETTER_NAME:String = "setterInterception";

		private var _name:String;

		{
			_enumCreated = true;
		}

		public function InvocationKind(name:String) {
			Assert.state(!_enumCreated, "InvocationKind enum has already been created");
			super();
			_name = name;
			ITEMS[_name] = this;
		}

		public static function determineKind(name:String):InvocationKind {
			return ITEMS[name] as InvocationKind;
		}

		public function get name():String {
			return _name;
		}

		public function toString():String {
			return "InvocationKind{_name:\"" + _name + "\"}";
		}


	}
}