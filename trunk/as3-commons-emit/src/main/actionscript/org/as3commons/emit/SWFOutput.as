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

	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataOutput;

	public class SWFOutput implements ISWFOutput {
		private var _output:IDataOutput;

		private var _currentByte:int = 0;
		private var _bitOffset:int = 0;

		private var _dataBuffer:ByteArray;

		public function SWFOutput(output:IDataOutput) {
			_output = output;
			_output.endian = Endian.LITTLE_ENDIAN;

			_dataBuffer = new ByteArray();
			_dataBuffer.endian = Endian.LITTLE_ENDIAN;

			_currentByte = 0;
		}

		public function writeString(value:String):void {
			align();

			for (var i:int = 0; i < value.length; i++) {
				_output.writeByte(value.charCodeAt(i));
			}

			_output.writeByte(0x0);
		}

		public function writeSI8(value:int):void {
			align();
			_output.writeByte(value);
		}

		public function writeSI16(value:int):void {
			writeSignedBytes(value, 2);
		}

		public function writeSI32(value:int):void {
			writeSignedBytes(value, 4);
		}

		public function writeUI8(value:uint):void {
			align();
			_output.writeByte(value);
		}

		public function writeUI16(value:uint):void {
			writeUnsignedBytes(value, 2);
		}

		public function writeUI32(value:uint):void {
			writeUnsignedBytes(value, 4);
		}

		private function writeSignedBytes(value:int, bytes:uint):void {
			align();

			_dataBuffer.position = 0;
			_dataBuffer.writeInt(value);

			_output.writeBytes(_dataBuffer, 0, bytes);
		}

		private function writeUnsignedBytes(value:uint, bytes:uint):void {
			align();

			_dataBuffer.position = 0;
			_dataBuffer.writeUnsignedInt(value);

			_dataBuffer.position = 0;
			_output.writeBytes(_dataBuffer, 0, bytes);
		}

		public function writeBytes(bytes:ByteArray, offset:int = 0, length:int = 0):void {
			align();

			this._output.writeBytes(bytes, offset, length);
		}

		public function writeBit(bit:Boolean):void {
			if (bit)
				_currentByte |= (1 << (7 - _bitOffset));
			else
				_currentByte &= ~(1 << (7 - _bitOffset));

			_bitOffset++;

			if (_bitOffset == 8) {
				align();
			}
		}

		/**
		 * Aligns to the next available byte if not currently byte aligned
		 */
		public function align():void {
			if (_bitOffset > 0) {
				_output.writeByte(_currentByte);

				_currentByte = 0;
				_bitOffset = 0;
			}
		}
	}
}