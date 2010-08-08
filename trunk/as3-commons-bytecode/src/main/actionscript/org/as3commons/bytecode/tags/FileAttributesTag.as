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

	public class FileAttributesTag extends AbstractTag {

		public static const TAG_ID:uint = 69;
		private static const TAG_NAME:String = "FileAttributes";

		private var _useDirectBlit:Boolean;
		private var _useGPU:Boolean;
		private var _hasMetadata:Boolean;
		private var _actionScript3:Boolean;
		private var _useNetwork:Boolean;

		public function FileAttributesTag() {
			super(TAG_ID, TAG_NAME);
		}

		public function get useDirectBlit():Boolean {
			return _useDirectBlit;
		}

		public function set useDirectBlit(value:Boolean):void {
			_useDirectBlit = value;
		}

		public function get useGPU():Boolean {
			return _useGPU;
		}

		public function set useGPU(value:Boolean):void {
			_useGPU = value;
		}

		public function get hasMetadata():Boolean {
			return _hasMetadata;
		}

		public function set hasMetadata(value:Boolean):void {
			_hasMetadata = value;
		}

		public function get actionScript3():Boolean {
			return _actionScript3;
		}

		public function set actionScript3(value:Boolean):void {
			_actionScript3 = value;
		}

		public function get useNetwork():Boolean {
			return _useNetwork;
		}

		public function set useNetwork(value:Boolean):void {
			_useNetwork = value;
		}

	}
}