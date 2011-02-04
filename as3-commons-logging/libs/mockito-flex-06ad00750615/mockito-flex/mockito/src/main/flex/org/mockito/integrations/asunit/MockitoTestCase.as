package org.mockito.integrations.asunit
{
import asunit.framework.TestCase;

import org.mockito.*;
import org.mockito.api.*;

public class MockitoTestCase extends TestCase
{
    private var _mockClasses:Array;

    protected var mockito:Mockito;
    /**
     * Pass classes to mock to the constructor
     * @param mockClasses array of classes to mock
     */
    public function MockitoTestCase(mockClasses:Array)
    {
        _mockClasses = mockClasses;
    }

    public override function run():void
    {
        if (mockito == null && _mockClasses)
        {
            mockito = new Mockito();
            var superRun:Function = super.run;
            mockito.prepareClasses(_mockClasses, repositoryPreparedHandler);
            function repositoryPreparedHandler():void
            {
                superRun();
            }
        }
        else
        {
            super.run();
        }
    }

    include "../../Integration.include"
}
}