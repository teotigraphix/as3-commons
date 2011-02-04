package org.mockito.impl
{
    import flexunit.framework.TestCase;

    public class TestMockInterceptorImpl extends TestCase
    {
        private var interceptor:MockInterceptorImpl = new MockInterceptorImpl(null);
        private var target:Object = new Object();
        public function TestMockInterceptorImpl(methodName:String=null)
        {
            super(methodName);
        }
        
        public function testWillStoreInvocationWhenNotVerifying():void
        {
            // given
            assertNull(interceptor.verifier);
            assertEquals(0, interceptor.getInvocations(target).length);
            // when
            interceptor.methodCalled(new InvocationImpl(target, null, null, null, 1));
            // then
            assertEquals(1, interceptor.getInvocations(target).length);
        }
        
        public function testWillMethodCallVerifyInvocation():void
        {
            var mockVerifier:MockVerifier = new MockVerifier(); 
            // given
            interceptor.verifier = mockVerifier; 
            interceptor.rememberInvocation(new InvocationImpl(target, "foo", [], null, 1));
            // when 
            interceptor.methodCalled(new InvocationImpl(target, "foo", [], null, 1));
            // then no exception thrown
            assertNotNull(interceptor);
            assertEquals(1, mockVerifier.verifyCallCount);
        }
    }
}