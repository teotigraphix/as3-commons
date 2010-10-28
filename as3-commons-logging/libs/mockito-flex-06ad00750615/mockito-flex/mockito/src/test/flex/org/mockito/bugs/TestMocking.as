package org.mockito.bugs
{
import org.mockito.MockitoTestCase;

public class TestMocking extends MockitoTestCase
{
    public function TestMocking()
    {
        super([ILogger]);
    }

    public function testWillVerifyProperty():void
    {
        var logTarget: ILogger = ILogger( mockito.mock( ILogger ) );

        mockito.given( logTarget.debugEnabled ).willReturn(true);
        logTarget.debugEnabled;
        mockito.verify().that( logTarget.debugEnabled );

        mockito.given( logTarget.warnEnabled ).willReturn(true);
        logTarget.warnEnabled;
        mockito.verify().that( logTarget.warnEnabled );

    }
}
}