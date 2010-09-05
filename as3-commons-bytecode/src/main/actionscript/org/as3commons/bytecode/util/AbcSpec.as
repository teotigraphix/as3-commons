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

		public static function readUnsigned(bytes:ByteArray):int {
			return bytes.readUnsignedByte();
		}

		/**
		 * Returns a ByteArray set to Endian.LITTLE_ENDIAN.
		 */
		public static function byteArray():ByteArray {
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;

			return byteArray;
		}

		public static function readU8(bytes:ByteArray):uint {
			return 255 & bytes[bytes.position++];
		}

		public static function readU16(bytes:ByteArray):uint {
			return readU8(bytes) | readU8(bytes) << 8;
		}

		public static function readS24(bytes:ByteArray):int {
			return readU16(bytes) | readU8(bytes) << 16;
		}

		public static function readS32(bytes:ByteArray):int {
			return readU32(bytes);
		}

		public static function readU30(bytes:ByteArray):uint {
			return readU32(bytes);
		}

		public static function readStringInfo(bytes:ByteArray):String {
			return bytes.readUTFBytes(readU32(bytes));
		}

//        int sizeOfU30(int v)
//        {
//            if (v < 128 && v >= 0)
//            {
//                return 1;
//            }
//            else if (v < 16384 && v >= 0)
//            {
//                return 2;
//            }
//            else if (v < 2097152 && v >= 0)
//            {
//                return 3;
//            }
//            else if (v < 268435456 && v >= 0)
//            {
//                return 4;
//            }
//            else
//            {
//                return 5;
//            }
//        }

		public static function readD64(bytes:ByteArray):Number {
			return bytes.readDouble();
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

			var nextByte:int = byteArray.readUnsignedByte() << 7;
			result = result & 0x0000007f | nextByte;
			if (!(result & 0x00004000)) {
				return result;
			}

			nextByte = byteArray.readUnsignedByte() << 14;
			result = result & 0x00003fff | nextByte;
			if (!(result & 0x00200000)) {
				return result;
			}

			nextByte = byteArray.readUnsignedByte() << 21;
			result = result & 0x001fffff | nextByte;
			if (!(result & 0x10000000)) {
				return result;
			}

			nextByte = byteArray.readUnsignedByte() << 28;
			return result & 0x0fffffff | nextByte;
		}

		/**
		 * Writes a variable-length encoded 32-bit unsigned integer value.
		 */
		public static function writeU32(value:uint, byteArray:ByteArray):void {
			if (value < 128 && value > -1) {
				byteArray.writeByte(value);
			} else if (value < 16384 && value > -1) {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte((value >> 7) & 0x7F);
			} else if (value < 2097152 && value > -1) {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte((value >> 7) | 0x80);
				byteArray.writeByte((value >> 14) & 0x7F);
			} else if (value < 268435456 && value > -1) {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte(value >> 7 | 0x80);
				byteArray.writeByte(value >> 14 | 0x80);
				byteArray.writeByte((value >> 21) & 0x7F);
			} else {
				byteArray.writeByte((value & 0x7F) | 0x80);
				byteArray.writeByte(value >> 7 | 0x80);
				byteArray.writeByte(value >> 14 | 0x80);
				byteArray.writeByte(value >> 21 | 0x80);
				byteArray.writeByte((value >> 28) & 0x0F);
			}
		}

		/**
		 * Writes a one-byte unsigned integer value.
		 */
		public static function writeU8(value:uint, byteArray:ByteArray):void {
			assertWithinRange(value < 256);
			byteArray.writeByte(value);
		}

		/**
		 * Writes a two-byte unsigned integer value.
		 */
		public static function writeU16(value:uint, byteArray:ByteArray):void {
			assertWithinRange(value < 65536);
			byteArray.writeByte(value & 0xFF);
			byteArray.writeByte((value >> 8) & 0xFF);
		}

		/**
		 * Writes a three-byte signed integer value.
		 */
		public static function writeS24(value:int, byteArray:ByteArray):void {
			assertWithinRange(-16777216 <= value && value < 16777216);
			byteArray.writeByte(value & 0xFF);
			byteArray.writeByte((value >> 8) & 0xFF);
			byteArray.writeByte((value >> 16) & 0xFF);
		}

		/**
		 * Writes a variable-length encoded 30-bit unsigned integer value.
		 */
		public static function writeU30(value:uint, byteArray:ByteArray):void {
			assertWithinRange(value < 1073741824);
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
			writeU30(string.length, byteArray);
			byteArray.writeUTFBytes(string);
		}

		/**
		 * Asserts a given statementm, throwing an error if the statement is false.
		 */
		public static function assertWithinRange(assertion:Boolean):void {
			if (!assertion) {
				throw new Error("Value out of range");
			}
		}
	}
}