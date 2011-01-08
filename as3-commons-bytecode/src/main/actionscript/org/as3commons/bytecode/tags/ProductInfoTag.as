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
package org.as3commons.bytecode.tags {

	public class ProductInfoTag extends AbstractTag {

		public static const TAG_ID:uint = 41;
		private static const TAG_NAME:String = "ProductInfo";

		private var _productId:uint;
		private var _edition:uint;
		private var _majorVersion:uint;
		private var _minorVersion:uint;
		private var _majorBuild:uint;
		private var _minorBuild:uint;
		private var _compileDatePart1:uint;
		private var _compileDatePart2:uint;

		public function ProductInfoTag() {
			super(TAG_ID, TAG_NAME);
		}

		public function get productId():uint {
			return _productId;
		}

		public function set productId(value:uint):void {
			_productId = value;
		}

		public function get edition():uint {
			return _edition;
		}

		public function set edition(value:uint):void {
			_edition = value;
		}

		public function get majorVersion():uint {
			return _majorVersion;
		}

		public function set majorVersion(value:uint):void {
			_majorVersion = value;
		}

		public function get minorVersion():uint {
			return _minorVersion;
		}

		public function set minorVersion(value:uint):void {
			_minorVersion = value;
		}

		public function get majorBuild():uint {
			return _majorBuild;
		}

		public function set majorBuild(value:uint):void {
			_majorBuild = value;
		}

		public function get minorBuild():uint {
			return _minorBuild;
		}

		public function set minorBuild(value:uint):void {
			_minorBuild = value;
		}

		public function get compileDatePart1():uint {
			return _compileDatePart1;
		}

		public function set compileDatePart1(value:uint):void {
			_compileDatePart1 = value;
		}

		public function get compileDatePart2():uint {
			return _compileDatePart2;
		}

		public function set compileDatePart2(value:uint):void {
			_compileDatePart2 = value;
		}

	}
}