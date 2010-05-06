package org.as3commons.emit.tags
{
	import org.as3commons.emit.ISWFOutput;
	
	
	public class ShowFrameTag extends AbstractTag
	{
		public static const TAG_ID : int = 0x1;
		
		private var _name : String;
		
		public function ShowFrameTag()
		{
			super(TAG_ID);
		}
		
		public override function writeData(output : ISWFOutput) : void
		{
		}
	}
}