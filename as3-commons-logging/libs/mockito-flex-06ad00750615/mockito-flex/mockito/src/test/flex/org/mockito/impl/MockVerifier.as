package org.mockito.impl
{
    import org.mockito.api.Invocation;
    import org.mockito.api.Invocations;
    import org.mockito.api.Verifier;
    
    public class MockVerifier implements Verifier
    {
        public var verifyCallCount:int;
        
        public function MockVerifier()
        {
        }

        public function verify(wanted:Invocation, invocations:Invocations):void
        {
            verifyCallCount++;
        }
    }
}