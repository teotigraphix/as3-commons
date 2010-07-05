package org.mockito.flemit.framework
{
	import flash.utils.ByteArray;
	
	[ExcludeClass]
	public interface ISWFInput
	{
		function readString() : String;
		
		function readSI8() : int;
		function readSI16() : int;
		function readSI32() : int;
		
		function readUI8() : uint;
		function readUI16() : uint;
		function readUI32() : uint;
		
		function readBit() : Boolean;
		
		function readBytes(bytes : ByteArray, offset : int = 0, length : int = 0) : void;
		
		/**
		 * Aligns to the next available byte if not currently byte aligned
		 */		
		function align() : void;
	}
}