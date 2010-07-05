package org.mockito.asmock.framework.proxy
{
	[ExcludeClass]
	public class InterceptorImpl implements IInterceptor
	{
		public function InterceptorImpl()
		{
		}
		
		public function intercept(invocation : IInvocation) : void
		{
			trace(invocation.method.name);
			
			invocation.returnValue = null;
		}
	}
}