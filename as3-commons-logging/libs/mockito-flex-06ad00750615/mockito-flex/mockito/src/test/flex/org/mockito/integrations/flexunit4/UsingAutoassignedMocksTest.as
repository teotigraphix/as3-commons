package org.mockito.integrations.flexunit4
{
import org.flexunit.rules.IMethodRule;
import org.mockito.MockieClass;
import org.mockito.integrations.verify;

public class UsingAutoassignedMocksTest
{
    [Mock(type="org.mockito.MockieClass")]
    public var mockie:MockieClass;

    [Mock(type="org.mockito.MockieClass")]
    public var mockie2:MockieClass;

    [Rule]
    public var mockitoRule:IMethodRule = new MockitoRule();
    
    public function UsingAutoassignedMocksTest()
    {
    }

    [Test]
    public function shouldAllowVerificationOnMockie():void
    {
        // when
        mockie.argumentless();
        // then
        verify().that(mockie.argumentless());
    }

    [Test]
    public function shouldAllowVerificationOnMockieTwo():void
    {
        // when
        mockie2.argumentless()
        // then
        verify().that(mockie2.argumentless());
    }
}
}