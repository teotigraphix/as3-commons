package org.mockito.flemit.framework.bytecode
{
	import flash.utils.IDataOutput;
	
	[ExcludeClass]
	public interface IByteCodeLayout
	{
		function write(output : IDataOutput) : void;		
	}
}