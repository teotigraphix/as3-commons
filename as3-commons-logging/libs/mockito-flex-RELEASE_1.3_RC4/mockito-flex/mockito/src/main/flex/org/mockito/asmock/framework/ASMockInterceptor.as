package org.mockito.asmock.framework
{
	import org.mockito.asmock.framework.proxy.IInterceptor;
	import org.mockito.asmock.framework.proxy.IInvocation;
	
	internal class ASMockInterceptor implements IInterceptor
	{
		private var _mockedObject : IMockedObject;
		private var _repository : MockRepository;
		
		public function ASMockInterceptor(repository : MockRepository, mockedObject : IMockedObject)
		{
			_repository = repository;
			_mockedObject = mockedObject;
		}
		
		public function intercept(invocation : IInvocation) : void
		{
			if (_mockedObject.shouldCallOriginal(invocation.method))
			{
				invocation.proceed();
			}
			else if (invocation.property != null && _mockedObject.isRegisteredProperty(invocation.property))
			{
				invocation.returnValue = _mockedObject.handleProperty(invocation.property, invocation.method, invocation.arguments);
				
				// _repository.registerPropertyBehaviorOn				
			}
			else
			{
				invocation.returnValue = _repository.asmock_internal::methodCall(invocation, invocation.proxy, 
					invocation.method, invocation.arguments);
			}
		}

	}
}