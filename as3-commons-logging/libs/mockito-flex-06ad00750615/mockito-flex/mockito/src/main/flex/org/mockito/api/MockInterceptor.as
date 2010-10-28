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
package org.mockito.api
{
    /**
     * Interface for intercepting of the mock invocations
     */
    public interface MockInterceptor
    {
        /**
         * Called when a function is invoked on a mock object
         * @param invocation an invocation related to a call
         * @return a return value of the function or <code>null</code>
         * @see org.mockito.api.Invocation
         */
        function methodCalled(invocation:Invocation):*;
        
        /**
         * Sets a verifier for the next method call
         * @param verifier for the next method call
         * @see org.mockito.api.Verifier
         */
        function set verifier(verifier:Verifier):void;
        
        /**
         * Informs interceptor to stub the latest invocation
         * @param answer an answer associated with the latest call
         * @see org.mockito.api.Answer
         */
        function stubLatestInvocation(answer:Answer):void;
        
        /**
         * Called when a matcher is being used in function arguments
         * @param matcher a matcher that should be used for matching the argument
         * @see org.mockito.api.Matcher
         */
        function addMatcher(matcher:Matcher):void

        /**
         * Returns Invocations collection for the given mock object
         * @param mock mock object in question
         * @return an Invocations collection
         */
        function getInvocationsFor(mock:Object):Invocations
    }
}