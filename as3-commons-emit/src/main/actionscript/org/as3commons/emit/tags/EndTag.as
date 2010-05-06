package org.as3commons.emit.tags
{
	import org.as3commons.emit.ISWFOutput;
	
	
	public class EndTag extends AbstractTag
	{
		public static const TAG_ID : int = 0x0; 
		
		public function EndTag()
		{
			super(TAG_ID);
		}
		
		public override function writeData(output:ISWFOutput):void		
		{
		}

	}
}