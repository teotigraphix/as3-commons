package org.as3commons.emit
{
	import flash.utils.ByteArray;
	
	/**
	 * Enables the writing of SWF data types to 
	 * a stream
	 */	
	public interface ISWFOutput
	{
		function writeString(value : String) : void;
		
		function writeSI8(value : int) : void;
		function writeSI16(value : int) : void;
		function writeSI32(value : int) : void;
		
		function writeUI8(value : uint) : void;
		function writeUI16(value : uint) : void;
		function writeUI32(value : uint) : void;
		
		function writeBit(bit : Boolean) : void;
		
		function writeBytes(bytes : ByteArray, offset : int = 0, length : int = 0) : void;
		
		/**
		 * Aligns to the next available byte if not currently byte aligned
		 */		
		function align() : void;
	}
}