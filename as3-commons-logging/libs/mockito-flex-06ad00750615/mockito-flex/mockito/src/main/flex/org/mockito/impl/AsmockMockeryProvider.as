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
    import org.mockito.api.MockCreator;
    import org.mockito.api.MockInterceptor;
    import org.mockito.api.MockeryProvider;
import org.mockito.api.SequenceNumberGenerator;
import org.mockito.api.SequenceNumberTracker;

/**
     * 
     * Implementation of the mockery provider that creates asmock based implementation
     */
    public class AsmockMockeryProvider implements MockeryProvider
    {
        private var mockInterceptor:MockInterceptor;
        
        private var mockCreator:AsmockMockery;
        
        /**
         * Creates mockery provider
         */
        public function AsmockMockeryProvider(sequenceNumberGenerator:SequenceNumberGenerator,
                                              sequenceNumberTracker:SequenceNumberTracker)
        {
            mockInterceptor = new MockInterceptorImpl(sequenceNumberTracker);
            mockCreator = new AsmockMockery(mockInterceptor, sequenceNumberGenerator);
        }

        /**
         * Returns MockCreator
         * @return implementation of MockCreator
         */
        public function getMockCreator():MockCreator
        {
            return mockCreator;
        }
        
        /**
         * Returns MockInterceptor
         * @return implementation of MockInterceptor
         * 
         */
        public function getMockInterceptor():MockInterceptor
        {
            return mockInterceptor;
        }
    }
}