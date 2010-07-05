package org.mockito.integrations.flexunit4
{
import org.mockito.TestClass;
import org.mockito.integrations.verify;

[RunWith("org.mockito.integrations.flexunit4.MockitoClassRunner")]

public class MockingWithFlexUnit4
{
    [Mock(type="org.mockito.TestClass")]
    public var mockie:TestClass;

    public function MockingWithFlexUnit4()
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