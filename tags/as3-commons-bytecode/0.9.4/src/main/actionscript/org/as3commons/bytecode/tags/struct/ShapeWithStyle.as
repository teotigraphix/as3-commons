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
package org.as3commons.bytecode.tags.struct {

	public class ShapeWithStyle {

		private var _fillStyles:Array;
		private var _lineStyles:Array;
		private var _numFillBits:uint;
		private var _numLineBits:uint;
		private var _shapeRecords:Array;

		public function ShapeWithStyle() {
			super();
			initShapeWithStyle();
		}

		protected function initShapeWithStyle():void {
			_fillStyles = [];
			_lineStyles = [];
			_shapeRecords = [];
		}

		public function get fillStyles():Array {
			return _fillStyles;
		}

		public function set fillStyles(value:Array):void {
			_fillStyles = value;
		}

		public function get lineStyles():Array {
			return _lineStyles;
		}

		public function set lineStyles(value:Array):void {
			_lineStyles = value;
		}

		public function get numFillBits():uint {
			return _numFillBits;
		}

		public function set numFillBits(value:uint):void {
			_numFillBits = value;
		}

		public function get numLineBits():uint {
			return _numLineBits;
		}

		public function set numLineBits(value:uint):void {
			_numLineBits = value;
		}

		public function get shapeRecords():Array {
			return _shapeRecords;
		}

		public function set shapeRecords(value:Array):void {
			_shapeRecords = value;
		}

	}
}