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
package org.as3commons.emit.bytecode {
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;

	import org.as3commons.lang.Assert;

	public class ByteCodeReader implements IByteCodeReader {

		private var _bytes:ByteArray;
		private var _input:ByteArray;

		public function ByteCodeReader(input:ByteArray) {
			super();
			initByteCodeReader(input);
		}

		protected function initByteCodeReader(input:ByteArray):void {
			Assert.notNull(input, "input argument must not be null");
			_bytes = new ByteArray();
			_input = input;
			_input.endian = Endian.LITTLE_ENDIAN;
		}

		public function readString():String {
			var len:uint = this.readU30();
			return _input.readUTFBytes(len);
		}

		public function readU8():uint {
			return 255 & _input[_input.position++];
		}

		public function readU16():uint {
			return readU8() | readU8() << 8;
		}

		public function readS24():int {
			return readU16() | readU8() << 16;
		}

		public function readU30():uint {
			return readU32();
		}

		public function readU32():uint {
			var result:int = _input.readUnsignedByte();

			// These values go up in powers of 128 as each 8-bit segment is encountered. Values
			// are represented in hex
			//                       8... * 16 = 128
			//               0x00000080
			//			var _128 : int = 0x00000080;
			//			var _127 : int = 0x0000007f;
			//			var _16384 : int = 0x00004000;
			//			var _16383 : int = 0x00003fff;
			//			var _2097152 : int = 0x00200000;
			//			var _2097151 : int = 0x001fffff;
			//			var _268435456 : int = 0x10000000;
			//			var _268435455 : int = 0x0fffffff;

			// In a bitwise &, any non-zero value &'ed to 0 should be 0. Since 0x00000080 represents 128 (10000000 in binary), this basically
			// just checks to see if there is a bit in 8th position. If not, then this is all there is and the byte is returned. This
			// process continues through the remaining calls. 
			if (!(result & 0x00000080)) {
				return result;
			}

			var nextByte:int = _input.readUnsignedByte() << 7;
			result = result & 0x0000007f | nextByte;
			if (!(result & 0x00004000)) {
				return result;
			}

			nextByte = _input.readUnsignedByte() << 14;
			result = result & 0x00003fff | nextByte;
			if (!(result & 0x00200000)) {
				return result;
			}

			nextByte = _input.readUnsignedByte() << 21;
			result = result & 0x001fffff | nextByte;
			if (!(result & 0x10000000)) {
				return result;
			}

			nextByte = _input.readUnsignedByte() << 28;
			return result & 0x0fffffff | nextByte;
		}

		public function readS32():int {
			return readU32();
		}

		public function readD64():Number {
			return _input.readDouble();
		}

	}
}