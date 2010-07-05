package org.mockito.flemit.framework
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class SWFInput implements ISWFInput
	{
		private var _input : IDataInput;
		
		private var _currentByte : int = 0;
		private var _bitOffset : int = 0;
		
		private var _dataBuffer : ByteArray;
		
		public function SWFInput(input : IDataInput)
		{
			_input = input;
			
			_dataBuffer = new ByteArray();
			_dataBuffer.endian = input.endian;
		}
		
		public function readString() : String
		{
			align();
			
			var codes : Array = new Array();
			
			var code : int;
			
			do
			{
				if (_input.bytesAvailable == 0)
				{
					throw new IllegalOperationError("Reached EOF");
				}
				
				code = _input.readUnsignedByte();
				
				if (code != 0)
				{
					codes.push(code);
				}
				
			} while (code != 0);
			
			return String.fromCharCode.apply(codes);
		}
		
		public function readSI8() : int
		{
			align();
			return _input.readByte();
		}
		
		public function readSI16() : int
		{
			_dataBuffer.position = 0;
			_input.readBytes(_dataBuffer, 0, 2);
			
			return _input.readShort();
		}
		
		public function readSI32() : int
		{
			_dataBuffer.position = 0;
			_input.readBytes(_dataBuffer, 0, 2);
			
			return _input.readInt();
		}
		
		public function readUI8() : uint
		{
			return _input.readUnsignedByte();
		}
		
		public function readUI16() : uint
		{
			return _input.readUnsignedShort();
		}
		
		public function readUI32() : uint
		{
			return _input.readUnsignedInt();
		}
		
		public function readBit() : Boolean
		{
			throw new IllegalOperationError("Not implemented");
		}
		
		public function readBytes(bytes : ByteArray, offset : int = 0, length : int = 0) : void
		{
			_input.readBytes(bytes, offset, length);
		}
				
		/**
		 * Aligns to the next available byte if not currently byte aligned
		 */		
		public function align() : void
		{
			throw new IllegalOperationError();
		}

	}
}