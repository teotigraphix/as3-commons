package org.mockito.integrations.flexunit4
{
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import org.flexunit.internals.runners.statements.IAsyncStatement;
import org.flexunit.internals.runners.statements.MethodRuleBase;
import org.flexunit.internals.runners.statements.StatementSequencer;
import org.flexunit.rules.IMethodRule;
import org.flexunit.runners.model.FrameworkMethod;
import org.flexunit.token.AsyncTestToken;
import org.mockito.Mockito;
import org.mockito.integrations.currentMockito;

public class MockitoRule extends MethodRuleBase implements IMethodRule
{
    public function MockitoRule()
    {
        super();
    }

    private function classFor(test:Object):Class
    {
        return Class(getDefinitionByName(getQualifiedClassName(test)));
    }

    override public function apply(base:IAsyncStatement, method:FrameworkMethod, test:Object):IAsyncStatement
    {
        var sequencer:StatementSequencer = new StatementSequencer();
        currentMockito = new Mockito();
        sequencer.addStep(withMocksPreparation(classFor(test)));
        sequencer.addStep(withMocksAssignment(classFor(test), test));
        sequencer.addStep(base);
        return super.apply(sequencer, method, test);
    }

    private function withMocksAssignment(testClass:Class, target:Object):IAsyncStatement
    {
        return new AssignMocks(currentMockito, testClass, target);
    }

    protected function withMocksPreparation(testClass:Class):IAsyncStatement
    {
        return new PrepareMocks(currentMockito, testClass);
    }

    override public function evaluate(parentToken:AsyncTestToken):void
    {
        super.evaluate(parentToken);
        proceedToNextStatement();
    }
}
}