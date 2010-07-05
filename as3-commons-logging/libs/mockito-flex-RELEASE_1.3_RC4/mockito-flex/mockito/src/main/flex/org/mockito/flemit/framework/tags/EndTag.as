package org.mockito.flemit.framework.tags
{
	import org.mockito.flemit.framework.ISWFOutput;
	import org.mockito.flemit.framework.Tag;
	
	[ExcludeClass]
	public class EndTag extends Tag
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