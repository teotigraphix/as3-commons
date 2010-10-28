/**
 * The MIT License
 *
 * Copyright (c) 2009 Mockito contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
 * AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package org.mockito.integrations.flexunit3
{

import flexunit.framework.TestCase;
import flexunit.framework.TestResult;

import org.mockito.Mockito;
import org.mockito.integrations.currentMockito;

    /**
     * Integration test case for the flexunit.
     */
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

        /**
         * Due to the asynchronous nature of the class generation
         * a test needs to execute from a callback function
         */
        public override function runWithResult(result:TestResult):void
        {
            if (mockito == null && _mockClasses)
            {
                mockito = new Mockito();
                currentMockito = mockito;
                var superRunWithResult:Function = super.runWithResult;
                mockito.prepareClasses(_mockClasses, repositoryPreparedHandler);
                function repositoryPreparedHandler():void
                {
                    superRunWithResult(result);
                }
            }
            else
            {
                super.runWithResult(result);
            }
        }
    }
}