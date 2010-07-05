package org.mockito.flemit.framework.bytecode
{
	import org.mockito.asmock.reflection.*;
	
	[ExcludeClass]
	public interface IByteCodeLayoutBuilder
	{
		function registerType(type : Type) : void;
		function registerMethodBody(method : MethodInfo, methodBody : DynamicMethod) : void;
		
		function createLayout() : IByteCodeLayout;
	}
}