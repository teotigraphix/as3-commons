package org.mockito.asmock.util
{
	import flash.utils.IDataInput;
	
	[ExcludeClass]
	public class ByteArrayUtil
	{
		public function ByteArrayUtil()
		{
		}
		
		public static function toString(input : IDataInput, bytesToRead : int = 0) : String
		{
			bytesToRead = (bytesToRead != 0)
				? Math.min(bytesToRead, input.bytesAvailable)
				: input.bytesAvailable;
			
			var vector : Array = new Array(bytesToRead);
			
			var bytesRead : int = 0;
			
			while(input.bytesAvailable > 0 && bytesRead < bytesToRead)
			{
				var byte : int = input.readByte();
				//var ubyte : uint = Math.abs(byte) & 0xFF; 
				var ubyte : uint = (byte < 0)
					? 0x000000FF & byte // (~byte + 1) // 2's compliment back to unsigned
					: byte;
				
				var str : String = ubyte.toString(16);
				
				if (str.length == 1) str = "0" + str;
				
				vector.push(str);
				bytesRead++;
			}
			
			return vector.join('').toUpperCase();
			
		}
	}
}