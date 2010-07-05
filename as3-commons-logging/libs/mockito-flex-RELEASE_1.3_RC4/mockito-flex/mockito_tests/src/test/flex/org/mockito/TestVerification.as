package org.mockito
{
    import org.mockito.impl.ActualNumberOfInvocationsIsDifferent;
    import org.mockito.impl.InvocationsNotInOrder;
    import org.mockito.impl.NeverWantedButInvoked;
    import org.mockito.impl.WantedButNotInvoked;

    public class TestVerification extends MockitoTestCase
    {

        public function TestVerification()
        {
            super([TestClass]);
        }

        public function testWillVerifyAndDetectArgumentsMismatch():void
        {
            // given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo(10);

            // when
            try
            {
                verify().that(testClass.foo(20));
                fail();
            }
            //then
            catch (e:WantedButNotInvoked)
            {
            }
        }

        public function testWillVerifyAndDetectDifferentMethodCalled():void
        {
            // given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();

            // when
            try
            {
                verify().that(testClass.bar());
                fail();
            }
            //then
            catch (e:WantedButNotInvoked)
            {
            }
        }

        public function testWillVerifyAndDetectMethodNotCalled():void
        {
            // given
            var testClass:TestClass = TestClass(mock(TestClass));

            // when
            try
            {
                verify().that(testClass.bar());
                fail();
            }
            //then
            catch (e:WantedButNotInvoked)
            {
            }
        }

        public function testWillVerifySuccessfully():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));

            // when
            testClass.foo(10);

            //then            
            verify().that(testClass.foo(10));
        }

        public function testWillVerifyMultipleTimesSuccessfully():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));

            // when
            testClass.foo(10);
            testClass.foo();
            testClass.bar(300);

            //then            
            verify().that(testClass.foo(10));
            verify().that(testClass.foo());
            verify().that(testClass.bar(300));
        }

        public function testWillAllowTheSameVerificationMultipleTimes():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));

            // when
            testClass.foo();

            //then            
            verify().that(testClass.foo());
            verify().that(testClass.foo());
        }

        public function testWillVerifyUsingAnyMatcher():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));

            // when
            testClass.foo(20);

            //then            
            verify().that(testClass.foo(any()));
        }

        public function testWillVerifyThatMethodWasNeverCalled():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));

            try
            {
                // when
                verify(never()).that(testClass.foo());
                //then
            }
            catch (e:NeverWantedButInvoked)
            {
                fail();
            }
        }

        public function testWillVerifyThatMethodWasNeverCalledWithSpecifiedArgs():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo(100);
            try
            {
                // when
                verify(never()).that(testClass.foo());
                //then
            }
            catch (e:NeverWantedButInvoked)
            {
                fail();
            }
        }
        
        public function testWillVerifySuccessfullyThatMethodWasCalledXTimes():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                verify(times(2)).that(testClass.foo());
                //then
            }
            catch (e:NeverWantedButInvoked)
            {
                fail();
            }
        }

        public function testWillVerifySuccessfullyThatMethodWasCalledExactlyXTimesWithAtLeastVerifier():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            // when
            try
            {
                verify(atLeast(1)).that(testClass.foo());
                //then
            }
            catch (e:Error)
            {
                fail();
            }
        }

        public function testWillVerifySuccessfullyThatMethodWasCalledMoreThenXWithAtLeastVerifier():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                verify(atLeast(1)).that(testClass.foo());
                //then
            }
            catch (e:Error)
            {
                fail();
            }
        }

        public function testCannotVerifySuccessfullyIfMethodNotCalledEnoughTimesWithAtLeastVerifier():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                verify(atLeast(3)).that(testClass.foo());
                fail();
            }
            catch (e:WantedButNotInvoked)
            {
                //then
            }
        }


        public function testWillVerifySuccessfullyThatMethodWasCalledExactlyXTimesWithNotMoreThanVerifier():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            // when
            try
            {
                verify(notMoreThan(1)).that(testClass.foo());
                //then
            }
            catch (e:Error)
            {
                fail();
            }
        }

        public function testWillVerifySuccessfullyThatMethodWasCalledLessThanXTimesWithNotMoreThanVerifier():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            // when
            try
            {
                verify(notMoreThan(2)).that(testClass.foo());
                //then
            }
            catch (e:Error)
            {
                fail();
            }
        }

        public function testCannotVerifySuccessfullyIfMethodWasCalledMoreThanXTimesWithMoreThanVerifier():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                verify(notMoreThan(1)).that(testClass.foo());
                fail();
            }
            catch (e:ActualNumberOfInvocationsIsDifferent)
            {
                //then
            }
        }

        public function testWillVerifySuccessfullyIfMethodCallsAreInRange():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                // when
                verify(between(1, 3)).that(testClass.foo());
            }
            catch (e:Error)
            {
                // then
                fail();
            }
        }

        public function testCannotVerifySuccessfullyIfMethodCallsAreOutsideRange():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                // when
                verify(between(1, 2)).that(testClass.foo());
                fail();
            }
            catch (e:ActualNumberOfInvocationsIsDifferent)
            {
                // then
            }
        }

        public function testWillVerifyWhenActualCallsCountIsLess():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                verify(times(3)).that(testClass.foo());
                fail();
            }
            catch (e:ActualNumberOfInvocationsIsDifferent)
            {
            }
        }
        
        public function testWillVerifyWhenActualCallsCountIsMore():void
        {
            //given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.foo();
            // when
            try
            {
                verify(times(1)).that(testClass.foo());
                fail();
            }
            catch (e:ActualNumberOfInvocationsIsDifferent)
            {
            }
        }


        public function testWillVerifyMethodsInOrder():void
        {
            // given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.bar();
            // when
            inOrder().verify().that(testClass.foo());
            inOrder().verify().that(testClass.bar());
            // then
        }

        public function testWillAllowUsingSelectiveMethodOrder():void
        {
            // given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.argumentless();
            testClass.bar();
            // when
            verify().that(testClass.argumentless());
            inOrder().verify().that(testClass.foo());
            inOrder().verify().that(testClass.bar());
            // then
        }

        public function testWillVerifyMethodsNotInOrder():void
        {
            // given
            var testClass:TestClass = TestClass(mock(TestClass));
            testClass.foo();
            testClass.bar();
            // when
            try
            {
                inOrder().verify().that(testClass.bar());
                inOrder().verify().that(testClass.foo());
                fail();
            }
            catch (e:InvocationsNotInOrder)
            {
                // then
            }
        }


        //TODO later:        
    //TODO atLeast(4)
    //TODO atLeastOnce()
    //TODO once()
    }
}