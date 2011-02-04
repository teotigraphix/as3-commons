package org.mockito.integrations.flexunit4
{
import org.flexunit.internals.runners.statements.AsyncStatementBase;
import org.flexunit.internals.runners.statements.IAsyncStatement;
import org.flexunit.token.AsyncTestToken;
import org.mockito.api.MockCreator;

public class AssignMocks  extends AsyncStatementBase implements IAsyncStatement
{
    private static const TIMEOUT_PER_CLASS:int = 5000;

    private var _mockCreator:MockCreator;
    private var _testClass:Class;
    private var _target:Object;

    public function AssignMocks(mockCreator:MockCreator, testClass:Class, target:Object)
    {
        _target = target;
        _testClass = testClass;
        _mockCreator = mockCreator;
    }

    public function evaluate(parentToken:AsyncTestToken):void
    {
        assignMocks(parentToken);
    }

    private function assignMocks(parentToken:AsyncTestToken):void
    {
        var mockInitializers:Array = null;

        try
        {
            mockInitializers = MockitoMetadataTools.getMockInitializers(_testClass);
        }
        catch(error:Error)
        {
            parentToken.sendResult(error);
            return;
        }

        try
        {
            assignMocksToFields(mockInitializers);
            parentToken.sendResult(null);
        }
        catch (e:Error)
        {
            parentToken.sendResult(e);
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

    protected function assignMocksToFields(initializers:Array):void
    {
        for each (var initializer:Object in initializers)
        {
            var args:Array = initializer.argsProperty ? _target[initializer.argsProperty] : null;
            _target[initializer.fieldName] = _mockCreator.mock(initializer.type, initializer.mockName, args);
        }
    }
}
}
