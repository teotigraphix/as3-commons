package org.as3commons.emit
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataOutput;
	
	
	public class SWFOutput implements ISWFOutput
	{
		private var _output : IDataOutput;
		
		private var _currentByte : int = 0;
		private var _bitOffset : int = 0;
		
		private var _dataBuffer : ByteArray;
		
		public function SWFOutput(output : IDataOutput)
		{
			_output = output;
			_output.endian = Endian.LITTLE_ENDIAN;
			
			_dataBuffer = new ByteArray();
			_dataBuffer.endian = Endian.LITTLE_ENDIAN;
			
			_currentByte = 0;
		}
		
		public function writeString(value : String) : void
		{
			align();
			
			for (var i:int=0; i<value.length; i++)
			{
				_output.writeByte(value.charCodeAt(i));
			}
			
			_output.writeByte(0x0);
		}
		
		public function writeSI8(value : int) : void
		{
			align();
			_output.writeByte(value);
		}
		
		public function writeSI16(value : int) : void
		{
			writeSignedBytes(value, 2);
		}
		
		public function writeSI32(value : int) : void
		{
			writeSignedBytes(value, 4);
		}
		
		public function writeUI8(value : uint) : void
		{
			align();
			_output.writeByte(value);
		}
		
		public function writeUI16(value : uint) : void
		{
			writeUnsignedBytes(value, 2);
		}
		
		public function writeUI32(value : uint) : void
		{
			writeUnsignedBytes(value, 4);
		}
		
		private function writeSignedBytes(value : int, bytes : uint) : void 
		{
			align();
			
			_dataBuffer.position = 0;
			_dataBuffer.writeInt(value);
			
			_output.writeBytes(_dataBuffer, 0, bytes);
		}
		
		private function writeUnsignedBytes(value : uint, bytes : uint) : void 
		{
			align();
			
			_dataBuffer.position = 0;
			_dataBuffer.writeUnsignedInt(value);
			
			_dataBuffer.position = 0;
			_output.writeBytes(_dataBuffer, 0, bytes);
		}
		
		public function writeBytes(bytes : ByteArray, offset : int = 0, length : int = 0) : void
		{
			align();
			
			this._output.writeBytes(bytes, offset, length);
		}
		
		public function writeBit(bit : Boolean) : void
		{
			if (bit)
				_currentByte |= (1 << (7-_bitOffset));
			else
				_currentByte &= ~(1 << (7-_bitOffset));
				
			_bitOffset++;
			
			if (_bitOffset == 8)
			{
				align();
			}
		}
		
		/**
		 * Aligns to the next available byte if not currently byte aligned
		 */		
		public function align() : void
		{
			if (_bitOffset > 0)
			{
				_output.writeByte(_currentByte);
				
				_currentByte = 0;
				_bitOffset = 0;
			}
		}
	}
}