/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.util {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.as3commons.lang.StringUtils;

	/**
	 * A reader/writer for the primitives required by the ABC file specification.
	 *
	 * <p>
	 * This class contains direct ports from the Java equivalents in the asc project for each method. Code was
	 * pulled from the nested <code>Reader</code> and <code>AbcWriter</code> classes in <code>adobe.abc.GlobalOptimizer</code>.
	 * </p>
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Primitive data types" in the AVM Spec (page 18)
	 */
	public final class AbcSpec {
		/**
		 * Pair for reading/writing <code>u30</code>s.
		 */
		public static const U30:ReadWritePair = new ReadWritePair(readU30, writeU30);

		/**
		 * Pair for reading/writing <code>u8</code>s.
		 */
		public static const U8:ReadWritePair = new ReadWritePair(readU8, writeU8);

		/**
		 * Pair for reading/writing <code>s24</code>s.
		 */
		public static const S24:ReadWritePair = new ReadWritePair(readS24, writeS24);

		/**
		 * Pair for reading/writing <code>s32</code>s.
		 */
		public static const S32:ReadWritePair = new ReadWritePair(readS32, writeS32);

		/**
		 * Pair for reading/writing <code>s24</code> arrays, used for the <code>lookupswitch</code> opcode
		 * which handles <code>switch</code> statements.
		 */
		public static const S24_ARRAY:ReadWritePair = new ReadWritePair(readS24, writeS24);

		/**
		 * This is a weird edge case, and I have not bothered to look in to the cause, but when working with
		 * certain opcodes they expect an unsigned byte. These must be read as unsigned bytes using the
		 * <code>readUnsignedByte()</code> method in <code>ByteArray</code>, but if written using
		 * <code>writeUnsignedByte()</code> (which you would expect to be symmetrical with its read
		 * equivalent) we get AVM errors. On the other hand, writing the values with <code>writeU30()</code>
		 * keeps everybody happy.
		 */
		public static const UNSIGNED_BYTE:ReadWritePair = new ReadWritePair(readUnsigned, writeU8);
		private static const __VALUE_OUT_OF_RANGE_ERROR:String = "Value out of range, expected {0}, but got {1}";

		public static const TWOHUNDRED_FIFTYFIVE:uint = 255;
		public static const EIGHT:uint = 8;
		public static const SIXTEEN:uint = 16;
		public static const MAX_U8:uint = 256;
		public static const MAX_U16:uint = 65536;
		public static const MAX_U30:uint = 1073741824;
		public static const SEVEN:Number = 7;
		private static const FOURTEEN:Number = 14;
		private static const TWENTY_ONE:Number = 21;
		private static const TWENTY_EIGHT:Number = 28;
		private static const MAX_S24:Number = 8388607;
		private static var _illegalCount:int = 0;
		private static var _stringByteArray:ByteArray;

		public static function readUnsigned(bytes:ByteArray):uint {
			return bytes.readUnsignedByte();
		}

		/**
		 * Returns a ByteArray set to Endian.LITTLE_ENDIAN.
		 */
		public static function newByteArray():ByteArray {
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			return byteArray;
		}

		public static function readU8(bytes:ByteArray):uint {
			var value:uint = TWOHUNDRED_FIFTYFIVE & bytes[bytes.position++];
			CONFIG::debug {
				assertWithinRange(value < MAX_U8, MAX_U8, value);
			}
			return value;
		}

		public static function skipU8(bytes:ByteArray):void {
			bytes.position++;
		}

		public static function readU16(bytes:ByteArray):uint {
			var value:uint = readU8(bytes) | readU8(bytes) << EIGHT;
			CONFIG::debug {
				assertWithinRange(value < MAX_U16, MAX_U16, value);
			}
			return value;
		}

		public static function skipU16(bytes:ByteArray):void {
			bytes.position += 2;
		}

		public static function readS24(bytes:ByteArray):int {
			var value:int = bytes.readUnsignedByte();
			value |= (bytes.readUnsignedByte() << EIGHT | bytes.readByte() << SIXTEEN);
			return value;
		}

		public static function skipS24(bytes:ByteArray):void {
			bytes.readUnsignedByte();
			bytes.readUnsignedByte();
			bytes.readByte();
		}

		public static function readS32(bytes:ByteArray):int {
			return readU32(bytes);
		}

		public static function skipS32(bytes:ByteArray):void {
			skipU32(bytes);
		}

		public static function readU30(bytes:ByteArray):uint {
			var value:uint = (readU32(bytes) & 0x3fffffff);
			CONFIG::debug {
				assertWithinRange(value < MAX_U30, MAX_U30, value);
			}
			return value;
		}

		public static function skipU30(bytes:ByteArray):void {
			skipU32(bytes);
		}

		public static function readStringInfo(bytes:ByteArray):String {
			var len:uint = readU32(bytes);
			var result:String = bytes.readUTFBytes(len);
			if (len != result.length) {
				result = "UTF8_BAD" + (_illegalCount++).toString();
			}
			return result;
		}

		public static function skipStringInfo(bytes:ByteArray):void {
			bytes.position += readU32(bytes);
		}

		public static function readD64(bytes:ByteArray):Number {
			return bytes.readDouble();
		}

		public static function skipD64(bytes:ByteArray):void {
			bytes.readDouble();
		}

		public static function readU32(byteArray:ByteArray):uint {
			var result:int = byteArray.readUnsignedByte();

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

			var nextByte:int = byteArray.readUnsignedByte() << SEVEN;
			result = result & 0x0000007f | nextByte;
			if (!(result & 0x00004000)) {
				return result;
			}

			nextByte = byteArray.readUnsignedByte() << FOURTEEN;
			result = result & 0x00003fff | nextByte;
			if (!(result & 0x00200000)) {
				return result;
			}

			nextByte = byteArray.readUnsignedByte() << TWENTY_ONE;
			result = result & 0x001fffff | nextByte;
			if (!(result & 0x10000000)) {
				return result;
			}

			nextByte = byteArray.readUnsignedByte() << TWENTY_EIGHT;
			return result & 0x0fffffff | nextByte;
		}

		public static function skipU32(byteArray:ByteArray):void {
			var result:int = byteArray.readUnsignedByte();

			if (!(result & 0x00000080)) {
				return;
			}

			var nextByte:int = byteArray.readUnsignedByte() << SEVEN;
			result = result & 0x0000007f | nextByte;
			if (!(result & 0x00004000)) {
				return;
			}

			nextByte = byteArray.readUnsignedByte() << FOURTEEN;
			result = result & 0x00003fff | nextByte;
			if (!(result & 0x00200000)) {
				return;
			}

			nextByte = byteArray.readUnsignedByte() << TWENTY_ONE;
			result = result & 0x001fffff | nextByte;
			if (!(result & 0x10000000)) {
				return;
			}

			byteArray.readUnsignedByte();
		}

		/**
		 * Writes a variable-length encoded 32-bit unsigned integer value.
		 */
		public static function writeU32(value:uint, byteArray:ByteArray):void {
			if (value < 128 && value > -1) {
				byteArray.writeByte(value);
			} else if (value < 16384 && value > -1) {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte((value >> SEVEN) & 0x7F);
			} else if (value < 2097152 && value > -1) {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte((value >> SEVEN) | 0x80);
				byteArray.writeByte((value >> FOURTEEN) & 0x7F);
			} else if (value < 268435456 && value > -1) {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte(value >> SEVEN | 0x80);
				byteArray.writeByte(value >> FOURTEEN | 0x80);
				byteArray.writeByte((value >> TWENTY_ONE) & 0x7F);
			} else {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte(value >> SEVEN | 0x80);
				byteArray.writeByte(value >> FOURTEEN | 0x80);
				byteArray.writeByte(value >> TWENTY_ONE | 0x80);
				byteArray.writeByte((value >> TWENTY_EIGHT) & 0x0F);
			}
		}

		/**
		 * Writes a one-byte unsigned integer value.
		 */
		public static function writeU8(value:uint, byteArray:ByteArray):void {
			CONFIG::debug {
				assertWithinRange(value < MAX_U8, MAX_U8, value);
			}
			byteArray.writeByte(value);
		}

		/**
		 * Writes a two-byte unsigned integer value.
		 */
		public static function writeU16(value:uint, byteArray:ByteArray):void {
			CONFIG::debug {
				assertWithinRange(value < MAX_U16, MAX_U16, value);
			}
			byteArray.writeByte(value & 0xFF);
			byteArray.writeByte((value >> EIGHT) & 0xFF);
		}

		/**
		 * Writes a three-byte signed integer value.
		 */
		public static function writeS24(value:int, byteArray:ByteArray):void {
			CONFIG::debug {
				assertWithinRange(value > -MAX_S24, -MAX_S24, value);
				assertWithinRange(value < MAX_S24, MAX_S24, value);
			}
			var i:int = value & 0xFF;
			byteArray.writeByte(i);
			i = (value >> EIGHT) & 0xFF;
			byteArray.writeByte(i);
			i = (value >> SIXTEEN) & 0xFF;
			byteArray.writeByte(i);
		}

		/**
		 * Writes a variable-length encoded 30-bit unsigned integer value.
		 */
		public static function writeU30(value:uint, byteArray:ByteArray):void {
			CONFIG::debug {
				assertWithinRange(value < MAX_U30, MAX_U30, value);
			}
			writeU32(value, byteArray);
		}

		/**
		 * Writes a variable-length encoded 32-bit signed integer value.
		 */
		public static function writeS32(value:int, byteArray:ByteArray):void {
			writeU32(uint(value), byteArray);
		}

		/**
		 * Writes an 8-byte IEEE-754 floating point value. The high byte of the double value
		 * contains the sign and upper bits of the exponent, and the low byte contains the
		 * least significant bits of the significand.
		 */
		public static function writeD64(value:Number, byteArray:ByteArray):void {
			byteArray.writeDouble(value);
		}

		/**
		 * Writes a string to UTF8 encoded format.
		 */
		public static function writeUTFBytes(string:String, byteArray:ByteArray):void {
			byteArray.writeUTFBytes(string);
		}

		/**
		 * Writes a string_info object to the ByteArray. This is defined as a u30 for the size of
		 * the string plus UTF-8 encoded characters representing the string's value.
		 */
		public static function writeStringInfo(string:String, byteArray:ByteArray):void {
			if (string.length > 0) {
				_stringByteArray ||= newByteArray();
				_stringByteArray.writeUTFBytes(string);
				_stringByteArray.position = 0;
				writeU30(_stringByteArray.length, byteArray);
				byteArray.writeBytes(_stringByteArray);
				_stringByteArray.length = 0;
			} else {
				writeU30(0, byteArray);
			}
		}

		/**
		 * Asserts a given statementm, throwing an error if the statement is false.
		 */
		public static function assertWithinRange(assertion:Boolean, expected:Number, gotten:Number):void {
			if (!assertion) {
				throw new Error(StringUtils.substitute(__VALUE_OUT_OF_RANGE_ERROR, expected, gotten));
			}
		}
	}
}
