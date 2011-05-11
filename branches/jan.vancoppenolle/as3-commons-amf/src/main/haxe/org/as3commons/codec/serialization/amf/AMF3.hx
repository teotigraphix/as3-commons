package org.as3commons.codec.serialization.amf;

import flash.utils.ByteArray;
import flash.system.ApplicationDomain;
	
class AMF3 {

	/**
	 * Reads a Byte.
	 */
	private inline function readByte():UInt {
		return untyped __vmem_get__(0, address++);
	}
	
	/**
	 * Reads an Unsigned Byte.
	 */
	private inline function readUnsignedByte():UInt {
		return untyped __vmem_get__(0, address++);
	}

	/**
	 * Reads a 29-bit Unsigned Integer.
	 */
	private inline function readUInt29():Int {
		var value:Int = 0;
		var n:Int = 0;
		var byte:UInt = readUnsignedByte();
		
		while ((byte & 0x80) != 0 && n < 3) {
			value <<= 7;
			value |= (byte & 0x7F);
			byte = readUnsignedByte();
			++n;
		}
		
		if (n < 3) {
			value <<= 7;
			value |= byte;
		}
		else {
			value <<= 8;
			value |= byte;
			if ((value & 0x10000000) != 0)
				value |= 0xE0000000;
		}
		
		return value;
	}

	/**
	 * Reads an IEEE 754 double-precision (64-bit) floating-point Number.
	 */
	private inline function readDouble():Float {
		data.position = address;
		address += 8;
		return data.readDouble();
	}
	
	/**
	 * Extracts a ByteArray.
	 */
	private inline function readBytes(length:UInt):ByteArray {
		var bytes:ByteArray = new ByteArray();
		data.readBytes(bytes, address, length);
		address += length;
		return bytes;
	}
}