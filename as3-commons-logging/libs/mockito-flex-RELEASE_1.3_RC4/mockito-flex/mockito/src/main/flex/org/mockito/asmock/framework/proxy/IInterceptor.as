package org.mockito.asmock.framework.proxy
{
	[ExcludeClass]
	public interface IInterceptor
	{
		function intercept(invocation : IInvocation) : void;		
	}
}