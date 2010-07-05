package org.mockito.flemit.framework
{
	public class SWF
	{
		private var _header : SWFHeader;
		private var _tags : Array;
		
		public function SWF(header : SWFHeader, tags : Array)
		{
			_header = header;
			_tags = tags;
		}
		
		public function get header() : SWFHeader
		{
			return _header;
		}
		
		public function get tags() : Array
		{
			return _tags;
		}
	}
}