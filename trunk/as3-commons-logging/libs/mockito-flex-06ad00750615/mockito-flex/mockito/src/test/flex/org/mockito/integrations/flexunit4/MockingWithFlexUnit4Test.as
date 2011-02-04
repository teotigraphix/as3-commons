package org.mockito.integrations.flexunit4
{
import org.flexunit.rules.IMethodRule;
import org.mockito.MockieClass;
import org.mockito.integrations.verify;

public class MockingWithFlexUnit4Test
{
    [Mock(type="org.mockito.MockieClass")]
    public var mockie:MockieClass;

    [Rule]
    public var mockitoRule:IMethodRule = new MockitoRule();
    
    public function MockingWithFlexUnit4Test()
    {
    }

    [Test]
    public function shouldVerifyMockInvocation():void
    {
        // when
        mockie.argumentless();
        // then
        verify().that(mockie.argumentless());
    }
}
}