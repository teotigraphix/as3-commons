package org.as3commons.emit.tags
{
	import org.as3commons.emit.ISWFOutput;
	
	
	public class SetBackgroundColorTag extends AbstractTag
	{
		public static const TAG_ID : int = 0x9;
		
		private var _red : uint;
		private var _green : uint;
		private var _blue : uint;
		
		public function SetBackgroundColorTag(red : uint = 0, green : uint = 0, blue : uint = 0)
		{
			super(TAG_ID);
			
			_red = red;
			_green = green;
			_blue = blue;
		}

		public override function writeData(output:ISWFOutput):void		
		{
			output.writeUI8(_red);
			output.writeUI8(_green);
			output.writeUI8(_blue);
		}
		
		public function get red() : uint { return _red; }
		public function set red(value : uint) : void { _red = value; }
		
		public function get green() : uint { return _green; }
		public function set green(value : uint) : void { _green = value; }
		
		public function get blue() : uint { return _blue; }
		public function set blue(value : uint) : void { _blue = value; }
	}
}