package org.mockito.impl
{
    import flexunit.framework.TestCase;
    
    import org.mockito.api.Invocation;
    import org.mockito.api.Invocations;
    import org.mockito.api.MockitoVerificationError;
    

    public class TestTimes extends TestCase
    {

        private var times:Times = new Times(1);
        
        public function TestTimes()
        {
        }

        public function testWillVerifySucessfully():void
        {
            // given
            var wanted:Invocation = new InvocationImpl(new Object(), "someMethod", [], null, 1);
            var invocations:Invocations = new InvocationsImpl(null);
            invocations.addInvocation(wanted);
            
            // when
            try {
                times.verify(wanted, invocations);
            // then
            }  catch(e:MockitoVerificationError) {
                fail();
            }
        }
    }
}