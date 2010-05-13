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
package org.as3commons.emit.bytecode {
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataOutput;


	public class ByteCodeWriter implements IByteCodeWriter {
		private var _buffer:ByteArray;
		private var _output:IDataOutput;

		public function ByteCodeWriter(output:IDataOutput) {
			_output = output;
			_output.endian = Endian.LITTLE_ENDIAN;

			_buffer = new ByteArray();
			_buffer.endian = Endian.LITTLE_ENDIAN;
		}

		public function writeString(value:String):void {
			this.writeU30(value.length);

			_output.writeUTFBytes(value);
		}

		public function writeU8(value:uint):void {
			_buffer.position = 0;
			_buffer.writeUnsignedInt(value);

			_buffer.position = 0;
			_output.writeBytes(_buffer, 0, 1);
		}

		public function writeU16(value:uint):void {
			_buffer.position = 0;
			_buffer.writeUnsignedInt(value);

			_buffer.position = 0;
			_output.writeBytes(_buffer, 0, 2);
		}

		public function writeS24(value:int):void {
			//_buffer.clear();

			_buffer.writeInt(value);
			writeBuffer(3);
		}

		private function writeBuffer(byteCount:uint = 0):void {
			var bytesAvailable:uint = _buffer.position;

			_buffer.position = 0;

			var bytesToRead:uint = (byteCount == 0) ? bytesAvailable : byteCount;

			_output.writeBytes(_buffer, 0, bytesToRead);
		}

		public function writeU30(value:uint):void {
			writeU32(value);
		}

		public function writeU32(value:uint):void {
			var intVal:int = value as int;

			if (value > 0x7FFFFFFF) {
				throw new ArgumentError("Values greater than 7FFFFFFF currently not supported due to problems with bitshifting in AS3");
			}

			//_buffer.clear();

			var numBytes:uint = 0;

			while (numBytes == 0 || (value > 0 && numBytes < 5)) {
				var moreBytesFlag:int = (value > 0x7F) ? 0x80 : 0;

				_buffer.writeByte(value & 0x7F | moreBytesFlag);

				value >>= 7;

				numBytes++;
			}

			writeBuffer();
		}

		public function writeS32(value:int):void {
			var lastByteWritten:Boolean = false;
			var negativeFlag:int = (value < 0) ? 0x40 : 0;

			var uvalue:uint = Math.abs(value) as uint;

			while (!lastByteWritten) {
				if (uvalue <= 0x3F) {
					_buffer.writeByte(uvalue & 0x3F | negativeFlag);

					lastByteWritten = true;
				} else {
					// 0x80 is the 'more bytes' flag
					_buffer.writeByte(uvalue & 0x7F | 0x80);

					uvalue >>= 7;
				}
			}

			writeBuffer();
		}

		public function writeD64(value:Number):void {
			// IEE-754
			_output.writeDouble(value);
		}

		public function writeBytes(byteArray:ByteArray, offset:uint = 0, length:uint = 0):void {
			_output.writeBytes(byteArray, offset, length);
		}
	}
}