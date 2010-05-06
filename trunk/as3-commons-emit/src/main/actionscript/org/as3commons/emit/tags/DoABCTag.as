package org.as3commons.emit.tags
{
	import flash.utils.ByteArray;
	
	import org.as3commons.emit.*;
	import org.as3commons.emit.bytecode.IByteCodeLayout;
	
	/**
	 * Represents an AVM2 bytecode tag
	 */	
	public class DoABCTag extends AbstractTag
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
			var flags : uint = getFlags();
			
			// flags
			output.writeUI32(flags);
			
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
		
		private function getFlags() : uint
		{
			return (_lazy)
				? FLAGS_LAZY
				: FLAGS_NONE; 
		}
		
		private static const FLAGS_NONE : uint = 0x0;
		private static const FLAGS_LAZY : uint = 0x1; 
	}
}