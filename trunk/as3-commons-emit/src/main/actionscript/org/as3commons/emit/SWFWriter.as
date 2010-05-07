package org.as3commons.emit
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataOutput;
	
	import org.as3commons.emit.tags.AbstractTag;
	
	
	public class SWFWriter
	{
		// Right now I can't be bothered implementing framesize, framework or framecount
		private var _hardCodedHeader : Array = [0x78, 0x00, 0x04, 0xE2, 0x00, 0x00, 0x0E, 
												0xA6, 0x00, 0x00, 0x18, 0x01, 0x00];
		
		private var _compress : Boolean = false;
		private var _tagDataBuffer : ByteArray;
		private var _tagDataWriter : SWFOutput;
		
		public function SWFWriter()
		{
			_tagDataBuffer = new ByteArray();
			_tagDataWriter = new SWFOutput(_tagDataBuffer);
		}
		
		public function get compress() : Boolean
		{
			return _compress;
		}
		
		public function set compress(value : Boolean) : void
		{
			_compress = value;
		}
		
		public function write(output : IDataOutput, header : SWFHeader, tags : Array) : void
		{
			output.endian = Endian.BIG_ENDIAN;
			
			var buffer : ByteArray = new ByteArray();
			
			var swfOutput : SWFOutput = new SWFOutput(buffer);
			writeInternal(swfOutput, header, tags);
			buffer.position = 0;
			
			var PRE_HEADER_SIZE : int = 8; // FWS[VERSION][FILESIZE]
			
			// FileSize is uncompressed
			var fileSize : int =buffer.bytesAvailable + PRE_HEADER_SIZE;
			 
			swfOutput = new SWFOutput(output);
			
			if (_compress)
			{
				buffer.compress();
				
				swfOutput.writeUI8("C".charCodeAt(0));
			}
			else
			{
				swfOutput.writeUI8("F".charCodeAt(0));
			}
			
			swfOutput.writeUI8("W".charCodeAt(0));
			swfOutput.writeUI8("S".charCodeAt(0));
			swfOutput.writeUI8(header.version);
			
			swfOutput.writeUI32(fileSize);

			buffer.position = 0;
			output.writeBytes(buffer, 0, buffer.bytesAvailable);
		}
		
		private function writeInternal(swfOutput : SWFOutput, header : SWFHeader, tags : Array) : void
		{
			// TODO: Write the actual header here
			for each(var byte : int in _hardCodedHeader)
				swfOutput.writeUI8(byte);
				
			for each(var tag : AbstractTag in tags)
				writeTag(swfOutput, tag);
		}
		
		private function writeTag(output : ISWFOutput, tag : AbstractTag) : void
		{
			_tagDataBuffer.position = 0;
			
			tag.writeData(_tagDataWriter);
			
			var tagLength : uint = _tagDataBuffer.position;
			
			if (tagLength >= 63)
			{
				output.writeUI16( (tag.tagId << 6) | 0x3F );
				output.writeUI32( tagLength ); 
			}
			else
			{
				output.writeUI16( (tag.tagId << 6) | tagLength );
			}
			
			_tagDataBuffer.position = 0;
			
			if (tagLength > 0)
			{
				output.writeBytes(_tagDataBuffer, 0, tagLength);
			}
		}
	}
}