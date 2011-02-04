package org.mockito.integrations.flexunit4
{
import org.flexunit.runner.IRunner;
import org.flexunit.runners.model.RunnerBuilderBase;

public class MockitoBuilder extends RunnerBuilderBase
{
    public function MockitoBuilder()
    {
    }

    override public function runnerForClass(testClass:Class):IRunner
    {
        if (MockitoMetadataTools.hasMockClasses(testClass))
        {
            return new MockitoClassRunner(testClass);
        }

        return null;
    }
}
}