package org.mockito.asmock.util
{
	[ExcludeClass]
	public class StringBuilder
	{
		private var _array : Array;
		private var _length : uint;
		
		public function StringBuilder()
		{
			_array = new Array();
		}
		
		public function appendLine(text : String = null) : StringBuilder
		{
			if (text != null)
			{
				append(text);
			}
			
			return append("\n");
		}
		
		public function append(text : String) : StringBuilder
		{
			if (text != null)
			{
				_length += text.length;
				_array.push(text);
			}
			
			return this;
		}
		
		public function appendFormat(text : String, ... args) : StringBuilder
		{
			for (var i:uint=0; i<args.length; i++)
			{
				var pattern : String = "\\{" + i.toString() + "\\}";
				
				text = text.replace(new RegExp(pattern, "g"), args[i]);
			}
			
			return append(text);
		}
		
		public function toString() : String
		{
			return _array.join("");
		}
		
		public function get length() : uint { return _length; }
	}
}