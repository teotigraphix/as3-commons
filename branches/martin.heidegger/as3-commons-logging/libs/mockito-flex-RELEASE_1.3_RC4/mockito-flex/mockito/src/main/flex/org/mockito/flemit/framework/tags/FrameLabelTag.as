package org.mockito.flemit.framework.tags
{
	import org.mockito.flemit.framework.ISWFOutput;
	import org.mockito.flemit.framework.Tag;
	
	[ExcludeClass]
	public class FrameLabelTag extends Tag
	{
		public static const TAG_ID : int = 0x2B; 
		
		private var _name : String;
		
		public function FrameLabelTag(name : String = null)
		{
			super(TAG_ID);
			
			_name = name;
		}
		
		public override function writeData(output : ISWFOutput) : void
		{
			output.writeString(_name);
			
			output.writeUI8(0x1); // Named Anchor flag - always 1
		}
		
		public function get name() : String { return _name; }
		public function set name(value : String) : void { _name = value; }

	}
}