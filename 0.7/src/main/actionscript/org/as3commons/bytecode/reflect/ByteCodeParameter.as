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
package org.as3commons.bytecode.reflect {
	import flash.system.ApplicationDomain;

	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.as3commons_reflect;

	public class ByteCodeParameter extends Parameter {

		public function ByteCodeParameter(index:int, type:String, applicationDomain:ApplicationDomain, isOptional:Boolean = false, defaultValue:* = null) {
			super(index, type, applicationDomain, isOptional);
			_defaultValue = defaultValue;
		}

		// ----------------------------
		// defaultValue
		// ----------------------------

		private var _defaultValue:*;

		public function get defaultValue():* {
			return _defaultValue;
		}

		// ----------------------------
		// name
		// ----------------------------

		private var _name:String = "";

		public function get name():String {
			return _name;
		}

		as3commons_reflect function setDefaultValue(value:*):void {
			_defaultValue = value;
		}

		as3commons_reflect function setName(value:String):void {
			_name = value;
		}

		as3commons_reflect function get typeName():String {
			return typeName;
		}

	}
}