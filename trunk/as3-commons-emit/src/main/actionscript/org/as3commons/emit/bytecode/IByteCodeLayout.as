package org.as3commons.emit.bytecode
{
	import flash.utils.IDataOutput;
	
	
	public interface IByteCodeLayout
	{
		function write(output : IDataOutput) : void;		
	}
}