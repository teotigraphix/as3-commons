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
package org.as3commons.bytecode.tags {
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public class AbstractTag implements ISWFTag {

		public function AbstractTag(id:uint, name:String) {
			super();
			initAbstractTag(id, name);
		}

		private function initAbstractTag(id:uint, name:String):void {
			Assert.hasText(name, "name argument must not be empty or null");
			_id = id;
			_name = name;
		}

		private var _id:uint;

		public function get id():uint {
			return _id;
		}

		private var _name:String;

		public function get name():String {
			return _name;
		}

	}
}