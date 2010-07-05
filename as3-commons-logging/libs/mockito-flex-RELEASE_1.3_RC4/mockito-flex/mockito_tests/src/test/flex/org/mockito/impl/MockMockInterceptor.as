package org.mockito.impl
{
    import org.mockito.api.Invocation;
    import org.mockito.api.Verifier;

    public class MockMockInterceptor extends MockInterceptorImpl
    {
        public var methodCalledCount:int;
        
        public function MockMockInterceptor()
        {
        }

        override public function methodCalled(invocation:Invocation):*
        {
            methodCalledCount++;
            return null;
        }
    }
}