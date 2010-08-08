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

	import org.as3commons.bytecode.abc.AbcFile;

	public class DoABCTag extends AbstractTag {

		public static const TAG_ID:uint = 82;
		private static const TAG_NAME:String = "DoABC";

		private var _flags:uint;
		private var _byteCodeName:String;
		private var _abcFile:AbcFile;

		public function DoABCTag() {
			super(TAG_ID, TAG_NAME);
		}

		public function get flags():uint {
			return _flags;
		}

		public function set flags(value:uint):void {
			_flags = value;
		}

		public function get byteCodeName():String {
			return _byteCodeName;
		}

		public function set byteCodeName(value:String):void {
			_byteCodeName = value;
		}

		public function get abcFile():AbcFile {
			return _abcFile;
		}

		public function set abcFile(value:AbcFile):void {
			_abcFile = value;
		}

	}
}