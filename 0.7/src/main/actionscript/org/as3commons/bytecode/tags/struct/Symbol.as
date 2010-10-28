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
package org.as3commons.bytecode.tags.struct {

	public class Symbol {

		private var _tagId:uint;
		private var _symbolClassName:String;

		public function Symbol() {
			super();
		}

		public function get tagId():uint {
			return _tagId;
		}

		public function set tagId(value:uint):void {
			_tagId = value;
		}

		public function get symbolClassName():String {
			return _symbolClassName;
		}

		public function set symbolClassName(value:String):void {
			_symbolClassName = value;
		}

	}
}