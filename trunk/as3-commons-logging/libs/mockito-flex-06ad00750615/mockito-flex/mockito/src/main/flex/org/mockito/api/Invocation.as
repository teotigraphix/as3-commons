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
     * An interface for invocation of the mocked method
     */
    public interface Invocation
    {
        /**
         * Specifies if the invocations has been already verified or not
         */
        function get verified():Boolean;
        
        /**
         * @private
         */
        function set verified(b:Boolean):void;
        
        /**
         * An array with the function arguments
         */
        function get args():Array;
        
        /**
         * Execution target or <code>this</code>
         */
        function get target():Object;
        
        /**
         * Executed function name
         */
        function get methodName():String;
        
        /**
         * Provides a function description
         * @return function description
         */
        function describe():String;
        
        /**
         * Verifies if the invocation matches with the specified argument
         * @param other an invocation to test
         * @return true if the two invocations matche
         */
        function matches(other:Invocation):Boolean;
        
        /**
         * Records an answer for given invocation
         * @param answer an answer to record 
         */ 
        function addAnswer(answer:Answer):void;
        
        /**
         * Provides an answer
         * @return return value or <code>null</code>
         */
        function answer(context:StubbingContext):*;
        
        /**
         * Records matchers used in place of the arguments
         * @param matchers an array with matchers
         * @see org.mockito.api.Matcher
         */
        function useMatchers(matchers:Array):void;
        
        /**
         * Informs about mode of the invocation
         * @return <code>true</code> if used to describe a stubbed invocation
         */
        function isStubbed():Boolean;

        /**
         * Returns stubbing context
         * @return 
         */
        function get stubbingContext():StubbingContext;

        function get sequenceNumber():int
    }
}