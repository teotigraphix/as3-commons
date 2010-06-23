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
package org.as3commons.emit.tags {

	public class RecordHeader {

		private var _id:uint;
		private var _length:uint;
		private var _isLongTag:Boolean;

		public function RecordHeader(tagId:uint, tagLength:uint, longTag:Boolean) {
			_id = tagId;
			_length = tagLength;
			_isLongTag = longTag;
		}

		public function get isLongTag():Boolean {
			return _isLongTag;
		}

		public function get id():uint {
			return _id;
		}

		public function get length():uint {
			return _length;
		}

	}
}