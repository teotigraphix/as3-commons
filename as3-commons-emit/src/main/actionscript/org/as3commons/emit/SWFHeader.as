package org.as3commons.emit
{
	
	public class SWFHeader
	{
		private var _version : uint;
		private var _compressed : Boolean;
		private var _filesize : int;
		private var _width : Number;
		private var _height : Number;
		private var _frameRate : Number;
		private var _frameCount : uint;
		
		public function SWFHeader(version : uint = 9, compressed : Boolean = false, filesize : Number = -1,
									width : Number = 100, height : Number = 100, frameRate : Number = 25, frameCount : int = 1)
		{
			_version = version;
			_compressed = compressed;
			_filesize = filesize;
			_width = width;
			_height = height;
			_frameRate = frameRate;
			_frameCount = frameCount; 
		}
		
		public function get version() : uint
		{
			return _version;
		}
		
		public function get compressed() : Boolean
		{
			return _compressed;
		}
		
		public function get filesize() : Number
		{
			return _filesize;
		}
		
		public function get width() : Number
		{
			return _width;
		}
		
		public function get height() : Number
		{
			return _height;
		}
		
		public function get frameRate() : Number
		{
			return _frameRate;
		}
		
		public function get frameCount() : int
		{
			return _frameCount;
		}
	}
}