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
package org.as3commons.bytecode.util {
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public final class SWFSpec {

		private static var _bitbuff:uint;
		private static var _bitleft:uint;

		public static const FLOAT16_EXPONENT_BASE:Number = 15;
		private static const FIXED_DIVISION:Number = 65536;
		private static const FIXED8_DIVISION:Number = 256;

		public static function flushBits():void {
			_bitbuff = _bitleft = 0;
		}

		public static function readBitRect(input:ByteArray):Rectangle {
			var bits:uint = readUB(input, 5);
			var r:Rectangle = new Rectangle();
			r.x = int(readSB(input, bits));
			r.width = int(readSB(input, bits));
			r.y = int(readSB(input, bits));
			r.height = int(readSB(input, bits));
			flushBits();
			return r;
		}

		public static function readSI8(input:ByteArray):int {
			flushBits();
			return input.readByte();
		}

		public static function writeSI8(input:ByteArray, value:int):void {
			flushBits();
			input.writeByte(value);
		}

		public static function readSI16(input:ByteArray):int {
			flushBits();
			return input.readShort();
		}

		public static function writeSI16(input:ByteArray, value:int):void {
			flushBits();
			input.writeShort(value);
		}

		public static function readSI32(input:ByteArray):int {
			flushBits();
			return input.readInt();
		}

		public static function writeSI32(input:ByteArray, value:int):void {
			flushBits();
			input.writeInt(value);
		}

		public static function readUI8(input:ByteArray):uint {
			flushBits();
			return input.readUnsignedByte();
		}

		public static function writeUI8(input:ByteArray, value:uint):void {
			flushBits();
			input.writeByte(value);
		}

		public static function readUI16(input:ByteArray):uint {
			flushBits();
			return input.readUnsignedShort();
		}

		public static function writeUI16(input:ByteArray, value:uint):void {
			flushBits();
			input.writeShort(value);
		}

		public static function readUI24(input:ByteArray):uint {
			flushBits();
			var loWord:uint = input.readUnsignedShort();
			var hiByte:uint = input.readUnsignedByte();
			return (hiByte << 16) | loWord;
		}

		public static function writeUI24(input:ByteArray, value:uint):void {
			flushBits();
			input.writeShort(value & 0xffff);
			input.writeByte(value >> 16);
		}

		public static function readUI32(input:ByteArray):uint {
			flushBits();
			return input.readUnsignedInt();
		}

		public static function writeUI32(input:ByteArray, value:uint):void {
			flushBits();
			input.writeUnsignedInt(value);
		}

		public static function readFIXED(input:ByteArray):Number {
			flushBits();
			return input.readInt() / FIXED_DIVISION;
		}

		public static function writeFIXED(input:ByteArray, value:Number):void {
			flushBits();
			input.writeInt(int(value * FIXED_DIVISION));
		}

		public static function readFIXED8(input:ByteArray):Number {
			flushBits();
			return input.readShort() / FIXED8_DIVISION;
		}

		public static function writeFIXED8(input:ByteArray, value:Number):void {
			flushBits();
			input.writeShort(int(value * FIXED8_DIVISION));
		}

		public static function readFLOAT(input:ByteArray):Number {
			flushBits();
			return input.readFloat();
		}

		public static function writeFLOAT(input:ByteArray, value:Number):void {
			flushBits();
			input.writeFloat(value);
		}

		public static function readDOUBLE(input:ByteArray):Number {
			flushBits();
			return input.readDouble();
		}

		public static function writeDOUBLE(input:ByteArray, value:Number):void {
			flushBits();
			input.writeDouble(value);
		}

		public static function readBoolean(input:ByteArray):Boolean {
			return (readUB(input) == 1);
		}

		public static function readUB(input:ByteArray, bits:uint = 1):uint {
			if (bits > 64 || bits == 0)
				return 0;

			var r:uint = (_bitbuff >> (8 - _bitleft));
			if (_bitleft >= bits) {
				_bitleft -= bits;
				_bitbuff <<= bits;
				return (r >> (8 - bits));
			}

			bits -= _bitleft;
			while (bits > 7) {
				_bitbuff = input.readUnsignedByte();

				r = (r << 8) | _bitbuff;
				bits -= 8;
				_bitleft = 0;
			}

			_bitbuff = 0;
			if (bits) {
				_bitbuff = input.readUnsignedByte();
				_bitleft = 8 - bits;
				r = (r << bits) | (_bitbuff >> _bitleft);
				_bitbuff <<= bits;
			}

			_bitbuff &= 0xff;
			return r;
		}

		public static function writeUB(input:ByteArray, bits:uint, value:uint):void {
			throw new Error("Not implemented yet");
		}

		public static function readSB(input:ByteArray, bits:uint):int {
			var shift:uint = 32 - bits;
			return int(readUB(input, bits) << shift) >> shift;
		}

		public static function writeSB(input:ByteArray, bits:uint, value:int):void {
			throw new Error("Not implemented yet");
		}

		public static function readFB(input:ByteArray, bits:uint):Number {
			return Number(readSB(input, bits)) / FIXED_DIVISION;
		}

		public static function writeFB(input:ByteArray, bits:uint, value:Number):void {
			writeSB(input, bits, value * FIXED_DIVISION);
		}

		public static function readString(input:ByteArray):String {
			var str:Array = [];
			var chr:uint = input.readUnsignedByte();
			while (chr > 0) {
				str[str.length] = String.fromCharCode(chr);
				chr = input.readUnsignedByte();
			}
			flushBits();
			return str.join('');
		}

		public static function writeString(input:ByteArray, value:String):void {
			if (value && value.length > 0) {
				input.writeUTFBytes(value);
			}
			input.writeByte(0);
		}

	}
}