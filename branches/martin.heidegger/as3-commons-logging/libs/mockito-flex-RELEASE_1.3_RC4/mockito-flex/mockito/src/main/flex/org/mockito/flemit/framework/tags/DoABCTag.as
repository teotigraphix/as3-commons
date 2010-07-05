package org.mockito.flemit.framework.tags
{
	import org.mockito.flemit.framework.*;
	import org.mockito.flemit.framework.bytecode.IByteCodeLayout;
	
	import flash.utils.ByteArray;
	
	[ExcludeClass]
	public class DoABCTag extends Tag
	{
		public static const TAG_ID : int = 0x52;
		
		private var _layout : IByteCodeLayout;
		private var _name : String;
		private var _lazy : Boolean;
		
		public function DoABCTag(lazy : Boolean, name : String, layout : IByteCodeLayout)
		{
			super(TAG_ID);
			
			_layout = layout;
			_name = name;
			_lazy = lazy;
		}
		
		public override function writeData(output:ISWFOutput):void
		{
			// flags
			output.writeUI32(_lazy ? 0x01 : 0x00);
			
			// name
			output.writeString(_name);
			
			var byteArray : ByteArray = new ByteArray();
			
			_layout.write(byteArray);
			
			byteArray.position = 0;			
			output.writeBytes(byteArray, 0, byteArray.bytesAvailable);
		}
		
		public override function readData(input : ISWFInput) : void
		{
			_lazy = (input.readUI8() == 0x01);
			_name = input.readString();
			 			
		}
	}
}