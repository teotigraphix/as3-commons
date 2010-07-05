package org.mockito.flemit.framework
{
	import flash.errors.IllegalOperationError;
	
	[ExcludeClass]
	public class Tag
	{
		private var _tagID : int;
		private var _length : uint = 0;
		
		public function Tag(tagID : int, length : uint = 0)
		{
			_tagID = tagID;
			_length = 0;
		}
		
		public function get tagID() : int
		{
			return _tagID;
		}
		
		public function get length() : int
		{
			return _length;
		}
		
		public function writeData(output : ISWFOutput) : void
		{
			throw new IllegalOperationError("Not implemented");
		}
		
		public function readData(input : ISWFInput) : void
		{
			throw new IllegalOperationError("Not implemented");
			 			
		}

	}
}