package org.mockito.flemit.framework.bytecode
{
	import flash.utils.ByteArray;
	
	[ExcludeClass]
	public interface IByteCodeWriter
	{
		function writeString(value : String) : void;
		function writeU8(value : uint) : void;
		function writeU16(value : uint) : void;
		function writeS24(value : int) : void;
		function writeU30(value : uint) : void;
		function writeU32(value : uint) : void;
		function writeS32(value : int) : void;
		function writeD64(value : Number) : void;
		
		function writeBytes(byteArray : ByteArray, offset : uint = 0, length : uint = 0) : void;
	}
}