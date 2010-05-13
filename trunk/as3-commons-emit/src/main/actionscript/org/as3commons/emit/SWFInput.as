/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.emit {

	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class SWFInput implements ISWFInput {
		private var _input:IDataInput;

		private var _currentByte:int = 0;
		private var _bitOffset:int = 0;

		private var _dataBuffer:ByteArray;

		public function SWFInput(input:IDataInput) {
			_input = input;

			_dataBuffer = new ByteArray();
			_dataBuffer.endian = input.endian;
		}

		public function readString():String {
			align();

			var codes:Array = new Array();

			var code:int;

			do {
				if (_input.bytesAvailable == 0) {
					throw new IllegalOperationError("Reached EOF");
				}

				code = _input.readUnsignedByte();

				if (code != 0) {
					codes.push(code);
				}

			} while (code != 0);

			return String.fromCharCode.apply(codes);
		}

		public function readSI8():int {
			align();
			return _input.readByte();
		}

		public function readSI16():int {
			_dataBuffer.position = 0;
			_input.readBytes(_dataBuffer, 0, 2);

			return _input.readShort();
		}

		public function readSI32():int {
			_dataBuffer.position = 0;
			_input.readBytes(_dataBuffer, 0, 2);

			return _input.readInt();
		}

		public function readUI8():uint {
			return _input.readUnsignedByte();
		}

		public function readUI16():uint {
			return _input.readUnsignedShort();
		}

		public function readUI32():uint {
			return _input.readUnsignedInt();
		}

		public function readBit():Boolean {
			throw new IllegalOperationError("Not implemented");
		}

		public function readBytes(bytes:ByteArray, offset:int = 0, length:int = 0):void {
			_input.readBytes(bytes, offset, length);
		}

		/**
		 * Aligns to the next available byte if not currently byte aligned
		 */
		public function align():void {
			throw new IllegalOperationError();
		}

	}
}