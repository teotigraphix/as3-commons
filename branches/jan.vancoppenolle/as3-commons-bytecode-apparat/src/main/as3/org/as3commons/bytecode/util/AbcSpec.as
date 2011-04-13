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
	import apparat.inline.Macro;
	import apparat.memory.Memory;
	
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
	public final class AbcSpec extends Macro {

		/*public static const MAX_U8:uint = 256;
		public static const MAX_U16:uint = 65536;
		public static const MAX_U30:uint = 1073741824;
		private static const MAX_S24:Number = 8388607;*/
		
		////////////////////////////////////////////////////////////////////////
		// Skip
		
		public static function skipU8(address:int):void {
			++address;
		}
		
		public static function skipU16(address:int):void {
			address += 2;
		}
		
		public static function skipS24(address:int):void {
			address += 3;
		}
		
		public static function skipU30(address:int):void {
			address += 4;
		}
		
		public static function skipU32(address:int):void {
			var value:int = Memory.readUnsignedByte(address++);
			
			if (!(value & 0x00000080))
				return;
			
			var nextByte:int = Memory.readUnsignedByte(address++) << 7;
			value = value & 0x0000007f | nextByte;
			
			if (!(value & 0x00004000))
				return;
			
			nextByte = Memory.readUnsignedByte(address++) << 14;
			value = value & 0x00003fff | nextByte;
			if (!(value & 0x00200000))
				return;
			
			nextByte = Memory.readUnsignedByte(address++) << 21;
			value = value & 0x001fffff | nextByte;
			
			if (!(value & 0x10000000))
				return;
			
			++address;
		}
		
		public static function skipS32(address:int):void {
			address += 4;
		}
		
		public static function skipD64(address:int):void {
			address += 8;
		}
		
		public static function skipStringInfo(address:int, length:uint):void {
			AbcSpec.readU32(address, length);
			address += length;
		}
		
		////////////////////////////////////////////////////////////////////////
		// Read
		
		/**
		 * Unsigned Byte (0x00 - 0xFF)
		 */
		public static function readUnsignedByte(address:int, value:int):void {
			value = Memory.readUnsignedByte(address++);
		}
		
		/**
		 * Signed Byte (-128 - 127)
		 */
		public static function readByte(address:int, value:int):void {
			value = Memory.readUnsignedByte(address++) - 128;
		}
		
		/**
		 * Heu... an unsigned byte?
		 */
		public static function readU8(address:int, value:int):void {
			value = 255 & Memory.readUnsignedByte(address++);
		}
		
		/**
		 * 16-bit Unsigned Integer
		 */
		public static function readU16(address:int, value:uint):void {
			value = 255 & Memory.readUnsignedByte(address++);
			value = value | value << 8;
		}
		
		/**
		 * 24-bit Signed Integer
		 */
		public static function readS24(address:int, value:int):void {
			value  =  Memory.readUnsignedByte(address++);
			value |=  Memory.readUnsignedByte(address++)        << 8;
			value |= (Memory.readUnsignedByte(address++) - 128) << 16;
		}
		
		/**
		 * Variable Length Encoded Unsigned Big Integer (1...5 bytes, 8...40-bits)
		 */
		public static function readU30(address:int, value:uint):void {
			AbcSpec.readU32(address, value);
		}
		
		/**
		 * Float (32-bit single precision floating point)
		 */
		public static function readS32(address:int, value:Number):void {
			AbcSpec.readU32(address, value);
		}

		/**
		 * Variable Length Encoded Unsigned Big Integer (1...5 bytes, 8...40-bits)
		 */
		public static function readU32(address:int, value:int):void {
			value = Memory.readUnsignedByte(address++);
			
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
			if (!(value & 0x00000080))
				return;
			
			var nextByte:int = Memory.readUnsignedByte(address++) << 7;
			value = value & 0x0000007f | nextByte;
			
			if (!(value & 0x00004000))
				return;
			
			nextByte = Memory.readUnsignedByte(address++) << 14;
			value = value & 0x00003fff | nextByte;
			
			if (!(value & 0x00200000))
				return;
			
			nextByte = Memory.readUnsignedByte(address++) << 21;
			value = value & 0x001fffff | nextByte;
			
			if (!(value & 0x10000000))
				return;
			
			nextByte = Memory.readUnsignedByte(address++) << 28;
			value = value & 0x0fffffff | nextByte;
		}
		
		/**
		 * Double (64-bit double precision floating point)
		 */
		public static function readD64(address:int, value:Number):void {
			value = Memory.readDouble(address);
			address += 8;
		}
		
		/**
		 * = ByteArray/readUTF() ???
		 */
		public static function readStringInfo(address:int, value:String, bytes:ByteArray):void {
			var length:uint;
			AbcSpec.readU32(address, length);
			bytes.position = address;
			value = bytes.readUTFBytes(length);
			address = bytes.position;
		}
		
		////////////////////////////////////////////////////////////////////////
		// Write
		
		/**
		 * Writes a variable-length encoded 32-bit unsigned integer value.
		 */
		public static function writeU32(value:uint, address:int):void {
			if (value < 128 && value > -1) {
				Memory.writeByte(value, address++);
			} else if (value < 16384 && value > -1) {
				Memory.writeByte((value & 0x7F) | 0x80, address++);
				Memory.writeByte((value >> 7) & 0x7F, address++);
			} else if (value < 2097152 && value > -1) {
				Memory.writeByte((value & 0x7F) | 0x80, address++);
				Memory.writeByte((value >> 7) | 0x80, address++);
				Memory.writeByte((value >> 14) & 0x7F, address++);
			} else if (value < 268435456 && value > -1) {
				Memory.writeByte((value & 0x7F) | 0x80, address++);
				Memory.writeByte(value >> 7 | 0x80, address++);
				Memory.writeByte(value >> 14 | 0x80, address++);
				Memory.writeByte((value >> 21) & 0x7F, address++);
			} else {
				Memory.writeByte((value & 0x7F) | 0x80, address++);
				Memory.writeByte(value >> 7 | 0x80, address++);
				Memory.writeByte(value >> 14 | 0x80, address++);
				Memory.writeByte(value >> 21 | 0x80, address++);
				Memory.writeByte((value >> 28) & 0x0F, address++);
			}
		}
		
		/**
		 * Writes a one-byte unsigned integer value.
		 */
		public static function writeU8(value:uint, address:int):void {
			Memory.writeByte(value, address++);
		}
		
		/**
		 * Writes a two-byte unsigned integer value.
		 */
		public static function writeU16(value:uint, address:int):void {
			Memory.writeByte(value & 0xFF, address++);
			Memory.writeByte((value >> 8) & 0xFF, address++);
		}
		
		/**
		 * Writes a three-byte signed integer value.
		 */
		public static function writeS24(value:int, address:int):void {
			Memory.writeByte(value & 0xFF, address++);
			Memory.writeByte((value >> 8) & 0xFF, address++);
			Memory.writeByte((value >> 16) & 0xFF, address++);
		}
		
		/**
		 * Writes a variable-length encoded 30-bit unsigned integer value.
		 */
		public static function writeU30(value:uint, address:int):void {
			AbcSpec.writeU32(value, address);
		}
		
		/**
		 * Writes a variable-length encoded 32-bit signed integer value.
		 */
		public static function writeS32(value:int, address:int):void {
			AbcSpec.writeU32(value, address);
		}
		
		/**
		 * Writes an 8-byte IEEE-754 floating point value. The high byte of the double value
		 * contains the sign and upper bits of the exponent, and the low byte contains the
		 * least significant bits of the significand.
		 */
		public static function writeD64(value:Number, address:int):void {
			Memory.writeDouble(value, address);
			address += 8;
		}
		
		/**
		 * Writes a string to UTF8 encoded format.
		 */
		public static function writeUTFBytes(value:String, address:int, byteArray:ByteArray):void {
			byteArray.position = address;
			byteArray.writeUTFBytes(value);
			address = byteArray.position;
		}
		
		/**
		 * Writes a string_info object to the ByteArray. This is defined as a u30 for the size of
		 * the string plus UTF-8 encoded characters representing the string's value.
		 */
		/*public static function writeStringInfo(value:String, address:int, byteArray:ByteArray):void {
			AbcSpec.writeU30(value.length, address);
			AbcSpec.writeUTFBytes(value, address, byteArray);
		}*/
	}
}