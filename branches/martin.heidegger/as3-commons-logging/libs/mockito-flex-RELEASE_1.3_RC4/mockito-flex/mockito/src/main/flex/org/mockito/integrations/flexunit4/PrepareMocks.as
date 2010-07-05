package org.mockito.integrations.flexunit4
{
import org.flexunit.internals.runners.statements.AsyncStatementBase;
import org.flexunit.internals.runners.statements.IAsyncStatement;
import org.flexunit.token.AsyncTestToken;
import org.mockito.api.MockCreator;

public class PrepareMocks extends AsyncStatementBase implements IAsyncStatement
{
    private static const TIMEOUT_PER_CLASS:int = 5000;

    private var _mockCreator:MockCreator;
    private var _testClass:Class;

    public function PrepareMocks(mockCreator:MockCreator, testClass:Class)
    {
        _testClass = testClass;
        _mockCreator = mockCreator;
    }

    public function evaluate(parentToken:AsyncTestToken):void
    {
        prepareMocks(parentToken);
    }

    private function prepareMocks(parentToken:AsyncTestToken):void
    {
        var mockInitializers:Array = null;

        try
        {
            mockInitializers = MockitoMetadataTools.getMockInitializers(_testClass, true);
        }
        catch(error:Error)
        {
            parentToken.sendResult(error);
            return;
        }

        _mockCreator.prepareClasses(extractClasses(mockInitializers), repositoryPreparedHandler, repositoryErrorHandler);

        function repositoryPreparedHandler():void
        {
            parentToken.sendResult(null);
        }

        function repositoryErrorHandler():void
        {
            parentToken.sendResult(new Error("Failed Preparing Classes"));
        }
    }

    private function extractClasses(mockInitializers:Array):Array
    {
        var res:Array = [];
        for each (var initializer:Object in mockInitializers)
        {
            res.push(initializer.type);
        }
        return res;
    }
}
}