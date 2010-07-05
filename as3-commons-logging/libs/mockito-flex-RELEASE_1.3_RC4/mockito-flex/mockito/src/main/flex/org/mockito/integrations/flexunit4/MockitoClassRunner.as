package org.mockito.integrations.flexunit4
{
import org.flexunit.internals.runners.statements.IAsyncStatement;
import org.flexunit.internals.runners.statements.StatementSequencer;
import org.flexunit.runners.BlockFlexUnit4ClassRunner;
import org.flexunit.runners.model.FrameworkMethod;
import org.mockito.Mockito;
import org.mockito.api.MockCreator;
import org.mockito.integrations.currentMockito;

public class MockitoClassRunner extends BlockFlexUnit4ClassRunner
{
    private var _testClass:Class;

    public function MockitoClassRunner(testClass:Class)
    {
        super(testClass);
        _testClass = testClass;
    }

    protected override function withBefores(method:FrameworkMethod, target:Object):IAsyncStatement
    {
        var sequencer:StatementSequencer = new StatementSequencer();
        currentMockito = new Mockito();
        sequencer.addStep(withMocksAssignment(_testClass, target));
        sequencer.addStep(super.withBefores(method, target));

        return sequencer;
    }

    private function withMocksAssignment(testClass:Class, target:Object):IAsyncStatement
    {
        return new AssignMocks(currentMockito, testClass, target);
    }

    protected override function withBeforeClasses():IAsyncStatement
    {
        var sequencer:StatementSequencer = new StatementSequencer();

        sequencer.addStep(withMocksPreparation(_testClass));
        sequencer.addStep(super.withBeforeClasses());

        return sequencer;
    }

    protected function withMocksPreparation(testClass:Class):IAsyncStatement
    {
        return new PrepareMocks(new Mockito(), testClass);
    }
}
}