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
package org.mockito.impl
{
import mx.collections.ArrayCollection;

import org.mockito.api.Invocation;
import org.mockito.api.Invocations;
import org.mockito.api.SequenceNumberTracker;

/**
     * Default implementation of the Invocations.
     */
    public class InvocationsImpl implements Invocations
    {
        private var invocations:ArrayCollection;

        private var sequenceNumberTracker:SequenceNumberTracker;

        public function InvocationsImpl(sequenceNumberTracker:SequenceNumberTracker)
        {
            invocations = new ArrayCollection();
            this.sequenceNumberTracker = sequenceNumberTracker;
        }

        /**
         * @inherited
         */
        public function addInvocation(iv:Invocation):void
        {
            invocations.addItem(iv);
        }
        
        /**
         * @inherited
         */
        public function getEncounteredInvocations():ArrayCollection
        {
            var noStubbed:ArrayCollection = new ArrayCollection(invocations.source);
            noStubbed.filterFunction = filterOutStubbed;
            noStubbed.refresh();
            return noStubbed;
        }
        
        /**
         * @inherited
         */
        public function answerFor(actualInvocation:Invocation):*
        {
            for each (var invocation:Invocation in invocations.source)
            {
                if (invocation.isStubbed() && invocation.matches(actualInvocation))
                {
                    return invocation.answer(actualInvocation.stubbingContext);
                }
            }
            return null;
        }

        private function filterOutStubbed(item:Invocation):Boolean 
        {
            return !item.isStubbed();
        }

        /**
         * @inherited
         */
        public function countMatchingInvocations(wanted:Invocation):int
        {
            var counter:int;
            for each (var iv:Invocation in getEncounteredInvocations())
            {
                if (wanted.matches(iv))
                {
                    counter ++;
                }
            }
            return counter;
        }

        public function getSequenceNumberForFirstMatching(wanted:Invocation, startingWithNumber:int):int
        {
            for each (var iv:Invocation in getEncounteredInvocations())
            {
                if (iv.sequenceNumber >= startingWithNumber && wanted.matches(iv))
                {
                    return iv.sequenceNumber;
                }
            }
            return -1;
        }

        public function set sequenceNumber(s:int):void
        {
            sequenceNumberTracker.sequenceNumber = s;
        }

        public function get sequenceNumber():int
        {
            return sequenceNumberTracker.sequenceNumber;
        }
    }
}