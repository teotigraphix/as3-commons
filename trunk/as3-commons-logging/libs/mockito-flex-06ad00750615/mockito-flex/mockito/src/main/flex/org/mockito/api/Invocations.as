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
import mx.collections.ArrayCollection;

/**
     * An interface for invocations collection
     */
    public interface Invocations
    {
        /**
         * Records an invocation
         * @param iv an invcation
         */
        function addInvocation(iv:Invocation):void;
        
        /**
         * Returns a collection of the mock invocations encountered during the test execution
         * @return list of non stubbed invocations
         */
        function getEncounteredInvocations():ArrayCollection;

        /**
         * Returns number of encountered invocations
         * @param iv
         * @return number of invocations matching the specified invocation
         */
        function countMatchingInvocations(iv:Invocation):int;

        function getSequenceNumberForFirstMatching(wanted:Invocation, startingWithNumber:int):int;

        /**
         * Calls answer that matches invocation 
         * @param iv invocation
         * @return a return value or <code>null</code>
         */
        function answerFor(iv:Invocation):*;

        function set sequenceNumber(s:int):void;

        function get sequenceNumber():int;
        
    }
}