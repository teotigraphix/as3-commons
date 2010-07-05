package org.mockito.asmock.framework
{
	import org.mockito.asmock.framework.constraints.Property;
	import org.mockito.asmock.reflection.*;
	
	[ExcludeClass]
	public interface IMockedObject
	{
		function shouldCallOriginal(method : MethodInfo) : Boolean;
		
		function handleProperty(property : PropertyInfo, method : MethodInfo, args : Array) : Object;
		function isRegisteredProperty(property : PropertyInfo) : Boolean;		
	}
}