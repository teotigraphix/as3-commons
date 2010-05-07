package org.as3commons.emit.util
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class BitReader
	{
		private var _input : IDataInput;
		
		private var _currentByte : uint;
		private var _bitIndex : uint = 8;
		
		private var _dataBuffer : ByteArray;
		
		public function BitReader(input : IDataInput)
		{
			if (input == null)
			{
				throw new ArgumentError("input must be specified");
			}
			
			this._input = input;
			this._dataBuffer = new ByteArray();
			this._dataBuffer.endian = input.endian;
		}
		
		private function ensureBits(numBits : uint) : void
		{
			if (bitsAvailable < numBits)
			{
				throw new IllegalOperationError("Unexpected EOF");
			}
			
			if (_bitIndex == 8)
			{
				_currentByte = _input.readUnsignedByte();
				_bitIndex = 0;
			}
		}
		
		public function readUnsignedInteger(bits : uint) : uint
		{
			var bitsRemaining : uint = bits;
			var outputValue : int = 0;
			
			while (bitsRemaining > 0)
			{
				ensureBits(bitsRemaining);
				
				var bitsToRead : uint = (bitsRemaining > (8 - _bitIndex)) ? 8 - _bitIndex : bitsRemaining;
				
				outputValue = (outputValue << bitsToRead) |
							(((_currentByte << _bitIndex) & 0xFF) >> (8-bitsToRead));
							
				_bitIndex += bitsToRead;
				
				bitsRemaining -= bitsToRead;
			}
			
			return uint(outputValue);
		}
		
		public function readInteger(bits : uint) : int
		{
			var bitsRemaining : uint = bits;
			var outputValue : int = 0;
			
			while (bitsRemaining > 0)
			{
				ensureBits(bitsRemaining);
				
				var bitsToRead : uint = (bitsRemaining > (8 - _bitIndex)) ? 8 - _bitIndex : bitsRemaining;
				
				outputValue = (outputValue << bitsToRead) |
							(((_currentByte << _bitIndex) & 0xFF) >> (8-bitsToRead));
							
				_bitIndex += bitsToRead;
				
				bitsRemaining -= bitsToRead;
			}
			
			return outputValue;
		}
		
		public function get bitsAvailable() : uint
		{
			return (_input.bytesAvailable * 8) +
					(8 - _bitIndex);
		}
		
		public function get endian() : String
		{
			return _input.endian;
		}
		
		public function set endian(value : String) : void
		{
			_input.endian = value;
			_dataBuffer.endian = value;
		}
	}
}