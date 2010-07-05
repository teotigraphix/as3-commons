package org.mockito.asmock.reflection
{
	import flash.system.ApplicationDomain;
	
	[ExcludeClass]
	public interface ITypeProvider
	{
		function getType(cls : Class, applicationDomain : ApplicationDomain = null) : Type;
	}
}