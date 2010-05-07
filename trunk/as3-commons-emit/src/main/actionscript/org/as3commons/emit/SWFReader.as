package org.as3commons.emit
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.as3commons.emit.util.BitReader;
	
	public class SWFReader
	{
		private static const PRE_HEADER_SIZE : int = 8; // FWS[VERSION][FILESIZE]
		
		public function SWFReader()
		{
		}
		
		public function read(input : IDataInput) : SWF
		{
			var swfIdentifier : String = input.readUTFBytes(3);
			var compressed : Boolean = (swfIdentifier.charAt(0) == 'C');
			var version : int = input.readUnsignedByte();
			var filesize : int = input.readUnsignedInt();
			
			var data : ByteArray = new ByteArray();
			data.endian = input.endian;
			
			input.readBytes(data, 0, filesize - PRE_HEADER_SIZE);
			
			if (compressed)
			{
				data.uncompress();
			}
			
			var header : SWFHeader = readHeader(data, compressed, version, filesize);
			
			var swfInput : SWFInput = new SWFInput(input);
			
			return new SWF(header, []);
		}
		
		private function readHeader(input : IDataInput, compressed : Boolean, version : int, filesize : int) : SWFHeader
		{
			var frameSize : Rectangle = readRectangle(input);
			
			var width : Number = (frameSize.width - frameSize.x) / 15;
			var height : Number = (frameSize.height - frameSize.y) / 15;
			
			var frameRateA : Number = input.readUnsignedByte(); 
			var frameRateB : Number = input.readUnsignedByte(); 
			
			var frameRate : Number = parseFloat(
				frameRateB.toString() + "." +
				frameRateA.toString()
				);
				
			var frameCount : uint = input.readUnsignedShort(); 
				
			return new SWFHeader(version, compressed, filesize, width, height, frameRate, frameCount);
		}
		
		private function readRectangle(input : IDataInput) : Rectangle
		{
			var bitReader : BitReader = new BitReader(input);
			
			var numBits : uint = bitReader.readUnsignedInteger(5);
			
			var xMin : int = bitReader.readInteger(numBits); 
			var xMax : int = bitReader.readInteger(numBits); 
			var yMin : int = bitReader.readInteger(numBits); 
			var yMax : int = bitReader.readInteger(numBits);
			
			return new Rectangle(xMin, xMax, yMin, yMax); 
		}
		
		private function readAsciiChars(input : IDataInput, count : uint) : String
		{
			var charCodes : Array = new Array(count);
			
			for (var i:int=0; i<count; i++)
			{
				charCodes[i] = input.readByte();
			}
			
			return String.fromCharCode.apply(charCodes);
		}
	}
}