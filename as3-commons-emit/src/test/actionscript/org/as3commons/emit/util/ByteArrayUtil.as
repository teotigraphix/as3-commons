package org.as3commons.emit.util
{
	import flash.utils.IDataInput;
	
	public class ByteArrayUtil
	{
		public function ByteArrayUtil()
		{
		}
		
		public static function toString(input : IDataInput) : String
		{
			var vector : Array = new Array(input.bytesAvailable);
			
			while(input.bytesAvailable > 0)
			{
				var byte : int = input.readByte();
				//var ubyte : uint = Math.abs(byte) & 0xFF; 
				var ubyte : uint = (byte < 0)
					? 0x000000FF & byte // (~byte + 1) // 2's compliment back to unsigned
					: byte;
				
				var str : String = ubyte.toString(16);
				
				if (str.length == 1) str = "0" + str;
				
				vector.push(str);
			}
			
			return vector.join('').toUpperCase();
			
		}
	}
}