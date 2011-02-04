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

package org.mockito
{
import org.mockito.api.Answer;
import org.mockito.api.stubbing.ArgumentSpecifier;
import org.mockito.api.Matcher;
import org.mockito.api.MethodSelector;
import org.mockito.api.MockCreator;
import org.mockito.api.MockInterceptor;
import org.mockito.api.MockVerificable;
import org.mockito.api.MockeryProvider;
import org.mockito.api.OrderedVerificable;
import org.mockito.api.Stubber;
import org.mockito.api.Verifier;
import org.mockito.impl.ArgumentRelatedAnswerImpl;
import org.mockito.impl.AsmockMockeryProvider;
import org.mockito.impl.AtLeast;
import org.mockito.impl.Between;
import org.mockito.impl.CallOriginal;
import org.mockito.impl.NotMoreThan;
import org.mockito.impl.InOrderVerificable;
import org.mockito.impl.StubberImpl;
import org.mockito.impl.Times;
import org.mockito.impl.matchers.GenericMatcher;
import org.mockito.impl.matchers.Matchers;

    /**
     * <h3>Main mocking entry point</h3>
     * <p>
     * You should start mocking by calling the prepareClasses(...) and providing all the classes to mock in given test case.
     * Since the bytecode generation is an asynchronous process it is recommended to use one of the integration test cases as they address
     * this issue.
     * </p>
     * <p>
     * After preparing classes you can create mock objects by invoking:
     * </p>
     * <p>
     * <listing>
     * var dependency:Dependency = Dependency(mock(Dependency));
     * </listing>
     * </p>
     * <p>
     * Then setup the System Under Test (SUT)
     * </p>
     * <p>
     * <listing>
     * var sut:Sut = new Sut();
     * sut.dependency = dependency;
     * </listing>
     * </p>
     * <p>
     * And execute tested code.
     * </p>
     * <p>
     * <listing>
     * sut.testedFunction(10);
     * </listing>
     * </p>
     * <p>
     * Given the testedFunction looks like this:
     * </p>
     * <p>
     * <listing>
     * function testedFunction(input:int):void
     * {
     *      dependencyResult = dependency.someOperation(input);
     * }
     * </listing>
     * </p>
     * notice that there is no 'unexpected call' exception.
     * <p>
     * Instead you are free to choose what you want to verify:
     * </p>
     * <p>
     * <listing>
     * verify().that(dependency.someOperation(input));
     * </listing>
     * </p>
     * The full test would look like this:
     * <p>
     * <listing>
     * // given
     * var sut:Sut = new Sut();
     * sut.dependency = dependency;
     * // when
     * sut.testedFunction(10);
     * // then
     * verify().that(dependency.someOperation(10));
     * </listing>
     * </p>
     * As you can see, verification happens where assertions go. Not before the tested code.
     * <br />
     * Important note is that verify() is equivalent to verify(times(1)).
     *
     * <p>
     * If you need to stub dependency, you define it upfront.
     * </p>
     * <p>
     * <listing>
     * given(dependency.someOperation(10)).willReturn(1);
     * </listing>
     * </p>
     * When used in test it would look like this:
     * <p>
     * <listing>
     * // given
     * var sut:Sut = new Sut();
     * sut.dependency = dependency;
     * given(dependency.someOperation(10)).willReturn(1);
     * // when
     * sut.testedFunction(10);
     * // then
     * assertEquals(1, sut.dependencyResult);
     * </listing>
     * </p>
     * It may be useful to verify or define stubbing with various arguments at a time or have ability of matching the specific cases.
     * For that purpose Mockito provides Matchers.
     * <br />
     * Below example verifies any arguments passed to the function:
     * <p>
     * <listing>
     * verify().that(dependency.someOperation(any()));
     * </listing>
     * </p>
     * Similar you can do with stubbing:
     * <p>
     * <listing>
     * given(dependency.someOperation(any())).willReturn(1);
     * </listing>
     * </p>
     * As you can see you can either use explicit values or matchers when defining stubs or verifying. But you cannot mix it within single stub definition or verification.
     * So for instance:
     * <p>
     * <listing>
     * verify().that(progress.update(10, any()))
     * </listing>
     * </p>
     * is invalid. Mockito will not be able to figure out which argument type to match against the any() matcher.
     *
     * You may want to verify multiple executions of a method at time. It's easy. Just tell how to verify:
     * <p>
     * <listing>
     * verify(times(3)).that(dependency.someOperation(any()));
     * </listing>
     * </p>
     * Sometimes you may want to make sure method has not been called. Do it by verifying:
     * <p>
     * <listing>
     * verify(never()).that(dependency.someOperation(any()));
     * </listing>
     * </p>
     * If you miss a verifier you can write it on your own by implementing Verifier interface.
     * <br />
     * <p>
     * If you need to perform a matching that is not provided by the Mockito, you can write your custom Matcher.
     * You start off with implementing the Matcher interface:
     * </p>
     * <p>
     * <listing>
     * public class HashOnlyCapitalLettersMatcher implements Matcher
     * {
     *      public function matches(value:*):Boolean
     *      {
     *          var string:String = value as String;
     *          var hasOnlyCapitalLetters:Boolean = ...;
     *          return hasOnlyCapitalLetters;
     *      }
     * }
     * </listing>
     * </p>
     *
     * Then you need to record a matcher use by calling argThat() function that puts aside a matcher
     * for later use:
     * <p>
     * <listing>
     * verify().that(system.login(argThat(new HashOnlyCapitalLettersMatcher())));
     * </listing>
     * </p>
     * <p>
     * A good practice is to create a matcher recording function somewhere and name it
     * after the matcher. It's important to return a wildcard from the function to let it
     * work with any arugment of the function
     * </p>
     * <p>
     * <listing>
     * function hasOnlyCapitalLetters():*
     * {
     *     argThat(new HashOnlyCapitalLettersMatcher());
     * }
     * </listing>
     * </p>
     */
    public class Mockito implements MethodSelector, MockCreator, MockVerificable
    {
        private var mockCreator:MockCreator;

        private var mockInterceptor:MockInterceptor;

        public static var defaultProviderClass:Class = AsmockMockeryProvider;

        private static var instance:Mockito;

        public function Mockito(mockeryProviderClass:Class=null)
        {
            super();
            instance = this;
            var sequencer:Sequencer = new Sequencer();
            var providerClass:Class = mockeryProviderClass || defaultProviderClass;
            var provider:MockeryProvider = new providerClass(sequencer, sequencer);
            mockCreator = provider.getMockCreator();
            mockInterceptor = provider.getMockInterceptor();
        }

        /**
         * @inheritedDoc
         */
        public function prepareClasses(classes:Array, calledWhenClassesReady:Function, calledWhenPreparingClassesFailed:Function=null):void
        {
            mockCreator.prepareClasses(classes, calledWhenClassesReady, calledWhenPreparingClassesFailed);
        }

        /**
         * @inherited
         */
        public function mock(clazz:Class, name:String=null, args:Array=null):*
        {
            return mockCreator.mock(clazz, name, args);
        }

        /**
         * A starter function for verification of executions
         * If you dont specify the verifier, an equivalent of times(1) is used.
         * @param verifier object responsible for verification of the following execution
         */
        public function verify(verifier:Verifier=null):MethodSelector
        {
            if (verifier == null)
                verifier = defaultVerifier;
            mockInterceptor.verifier = verifier;
            return this;
        }

        public function get defaultVerifier():Verifier
        {
            return Times.once;
        }

        /**
         * A starter function for verification of executions in order
         */
        public function inOrder():OrderedVerificable
        {
            return new InOrderVerificable(this);
        }

        /**
         * A starter function for stubbing
         * @param methodCallToStub call a method to stub as an argument
         * @return an object providing stubbing options
         */
        public function given(methodCallToStub:*):Stubber
        {
            return new StubberImpl(mockInterceptor);
        }

        /**
         * This method it part of the fluent interface
         * It's a placeholder for the actual method call for verification
         */
        public function that(methodCallToVerify:*):void
        {

        }

        /**
         * Matches a NaN Number
         */
        public function isItNaN():*
        {
            return argThat(Matchers.isNaN());
        }

        /**
         * Matches any non-null that is of specified type. Type equality is evaluated with equals operator
         */
        public function anyOf(clazz:Class):*
        {
            return argThat(Matchers.anyOf(clazz));
        }

        /**
         * Verifies if the argument has a property or a property chain of an expected value
         * @param propertyChain a property name or an array of property names of the objects chain in an argument
         * @param expectedPropertyValue expected value, equality is evaluated with '=='
         */
        public function havingPropertyOf(propertyChain:Object, expectedPropertyValue:Object):*
        {
            return argThat(Matchers.havingPropertyOf(propertyChain, expectedPropertyValue));
        }

        /**
         * matches any non-null argument
         */
        public function notNull():*
        {
            return argThat(Matchers.notNull());
        }

        /**
         * Matches any argument including <code>null</code>
         */
        public function any():*
        {
            return argThat(Matchers.any());
        }

        /**
         * Equality matcher<br />
         * Example:<br /><br />
         * <listing>
         * verify(never()).that(system.login(eq("root")));
         * </listing>
         */
        public function eq(expected:Object):*
        {
            return argThat(Matchers.eq(expected));
        }

        /**
         * A fluent interface for custom matcher<br />
         * Example:<br /><br />
         * <listing>
         * verify().that(system.login(argThat(new HashOnlyCapitalLettersMatcher())));
         * </listing>
         * <br /><br />
         * A good practice is to create a matcher recording function somewhere and name it
         * after the matcher. It's important to return a wildcard from the function to let it
         * work with any arugment of the function<br /><br />
         * <listing>
         * function hasOnlyCapitalLetters():*
         * {
         *     argThat(new HashOnlyCapitalLettersMatcher());
         * }
         * </listing>
         */
        public function argThat(matcher:Matcher):void
        {
            mockInterceptor.addMatcher(matcher);
        }

        /**
         * A shortcut for creating a GenericMatcher that accepts a matching function
         * @param expected is an expected value as passed to the GenericMatcher
         * @param func a matching function of a signature function (expected:*, actual:*):Boolean
         *
         * Example:
         * <listing>
         *     argThatMatches(10, compareInts);
         * </listing>
         */
        public function argThatMatches(expected:*, func:Function):*
        {
            return argThat(new GenericMatcher(expected, func));
        }

        /**
         * A fluent interface for counting calls<br />
         * Example:<br /><br />
         * <listing>
         * verify(times(2)).that(operator.execute());
         * </listing>
         */
        public function times(expectedCallsCount:int):Verifier
        {
            return new Times(expectedCallsCount);
        }

        /**
         * A fluent interface for making sure call hasn't happened<br />
         * Example:<br /><br />
         * <listing>
         * verify(never()).that(operator.execute());
         * </listing>
         */
        public function never():Verifier
        {
            return Times.never;
        }

        /**
         * A fluent interface for counting calls
         * Example:
         * <listing>
         * verify(atLeast(2)).that(operator.execute());
         * </listing>
         */
        public function atLeast(expectedCallsCount:int):Verifier
        {
            return new AtLeast(expectedCallsCount);
        }

        /**
         * A fluent interface for counting calls
         * Example:
         * <listing>
         * verify(notMoreThan(2)).that(operator.execute());
         * </listing>
         */
        public function notMoreThan(expectedCallsCount:int):Verifier
        {
            return new NotMoreThan(expectedCallsCount);
        }

        /**
         * A fluent interface for counting calls
         * Example:
         * <listing>
         * verify(between(2, 4)).that(operator.execute());
         * </listing>
         */
        public function between(minimumCallsCount:int, maximumCallsCount:int):Verifier
        {
            return new Between(minimumCallsCount, maximumCallsCount);
        }

        /**
         * A fluent interface for the answer calling original method
         * Example:
         * <listing>
         * given(generator.generate()).will(callOriginal());
         * </listing>
         * @return answer executing original non-mocked function
         */
        public function callOriginal():Answer
        {
            return new CallOriginal();
        }

        public function get expertsMockInterceptor():MockInterceptor
        {
            return mockInterceptor;
        }

        /**
         * This function gives access to the arguments passed on the stubbed function
         * For instance if you need to stub a function call that takes a callback
         * function, and in mock response you want to still call the callback with
         * some arguments, you can use this function to build the stub behavior
         * Example:
         * <listing>
         *
         * class Service
         * {
         *    public function loginService(resultFunction:Function):void
         *    {
         *     ...
         *    }
         * }
         *
         * given(service.loginService(any())).will(useArgument(0).asFunctionAndCall());
         * </listing>
         *
         * Above stub definition will call any function passed to the loginService() without
         * any arguments
         * @param index index of the argument (zero based)
         * @return
         */
        public function useArgument(index:int):ArgumentSpecifier
        {
            return new ArgumentRelatedAnswerImpl().useArgument(index);
        }
    }
}

import org.mockito.api.SequenceNumberGenerator;
import org.mockito.api.SequenceNumberTracker;

class Sequencer implements SequenceNumberGenerator, SequenceNumberTracker
{
    private var sequence:int = 0;

    private var _sequenceNumber:int = -1;

    public function Sequencer()
    {
    }

    public function next():int
    {
        return sequence++;
    }

    public function set sequenceNumber(sequenceNumber:int):void
    {
        _sequenceNumber = sequenceNumber;
    }

    public function get sequenceNumber():int
    {
        return _sequenceNumber;
    }
}
