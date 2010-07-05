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
package org.mockito.impl {
	import org.mockito.api.Answer;
	import org.mockito.api.Invocation;
	import org.mockito.api.Invocations;
	import org.mockito.api.Matcher;
	import org.mockito.api.MockInterceptor;
	import org.mockito.api.SequenceNumberTracker;
	import org.mockito.api.Verifier;

	import mx.collections.ArrayCollection;

	import flash.utils.Dictionary;

	public class MockInterceptorImpl implements MockInterceptor
    {
        public var invocationsMap:Dictionary = new Dictionary();

        private var matchers:Array = new Array();

        private var _verifier:Verifier;

        private var latestInvocation:Invocation;

        private var sequenceNumberTracker:SequenceNumberTracker;

        public function MockInterceptorImpl(sequenceNumberTracker:SequenceNumberTracker)
        {
            this.sequenceNumberTracker = sequenceNumberTracker;
        }

        public function methodCalled(invocation:Invocation):*
        {
            invocation.useMatchers(matchers);
            matchers = [];
            if (verifier)
            {
                try
                {
                    var invocations:Invocations = getInvocationsFor(invocation.target);
                    verifier.verify(invocation, invocations);
                    return null;
                }
                finally
                {
                    verifier = null;
                }
            }
            else
            {
                // store invocations for later verification or execute stub
                // consider using asmock facitilities for the stubbing
                rememberInvocation(invocation);
            }

            return getInvocationsFor(invocation.target).answerFor(invocation);
        }

        public function rememberInvocation(invocation:Invocation):void
        {
            var invocations:Invocations = getInvocationsFor(invocation.target);
            invocations.addInvocation(invocation);
            latestInvocation = invocation;
        }

        public function stubLatestInvocation(answer:Answer):void
        {
            if (!latestInvocation)
                throw new MissingMethodCallToStub("Please make sure you specified a call to stub in given(...)");
            latestInvocation.addAnswer(answer);
        }

        public function getInvocationsFor(target:*):Invocations
        {
            var invocations:Invocations = invocationsMap[target];
            if (!invocations)
            {
                invocations = new InvocationsImpl(sequenceNumberTracker);
                invocationsMap[target] = invocations;
            }
            return invocations;
        }

        public function getInvocations(mock:Object):ArrayCollection
        {
            return getInvocationsFor(mock).getEncounteredInvocations();
        }

        public function set verifier(value:Verifier):void
        {
            _verifier = value;
        }

        public function get verifier():Verifier
        {
            return _verifier;
        }

        public function addMatcher(matcher:Matcher):void
        {
            this.matchers.push(matcher);
        }
    }
}