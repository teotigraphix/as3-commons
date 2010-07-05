package org.mockito
{
import org.mockito.impl.GenericAnswer;
import org.mockito.impl.MissingMethodCallToStub;
import org.mockito.impl.WantedButNotInvoked;

public class TestStubbing extends MockitoTestCase
{
    private var mockie:TestClass;

    override public function setUp():void
    {
        super.setUp();
        mockie = TestClass(mock(TestClass));
    }

    public function TestStubbing()
    {
        super([TestClass]);
    }

    public function testWillStubAMethodCall():void
    {
        // when
        given(mockie.foo(10)).willReturn("10");
        // then
        assertEquals("10", mockie.foo(10));
    }

    public function testWillStubWithThrowable():void
    {
        // given
        given(mockie.foo(10)).willThrow(new Error("oups"));
        try {
            // when
            mockie.foo(10);
            fail();
            //then
        } catch (e:Error) {
            assertEquals("oups", e.message);
        }
    }

    private var counter:int;

    public function testWillStubWithGenericAnswer():void
{
        // given
        assertEquals(0, counter);
        given(mockie.foo()).will(new GenericAnswer(incrementCounter));

        // when
        mockie.foo();

        // then
        assertEquals(1, counter);
    }

    private function incrementCounter():void {
                          counter++;
    }

    public function testWillReturnDefaultEmptyValueWhenNotStubbed():void
    {
        assertEquals(null, mockie.foo(10));
    }

    public function testWillRemindUserThatHeNeedsAMethodCallToStub():void
    {
        try {
            //when
            given("").willReturn("10");
            fail();
            //then
        } catch(e:MissingMethodCallToStub) {
        }
    }

    public function testWillNotVerifyAStubbedCall():void
    {
        //given
        given(mockie.foo(10)).willReturn("10");
        try {
            // when
            verify().that(mockie.foo(10));
            fail();
            // then
        } catch(e:WantedButNotInvoked) {
        }
    }

    public function testWillStubAMethodCallWithAnyMatcher():void
    {
        // when
        given(mockie.foo(any())).willReturn("10");
        // then
        assertEquals("10", mockie.foo(10));
        assertEquals("10", mockie.foo(30));
        //TODO some day
        //            assertEquals("10", mock.foo());
    }

    public function testWillCallOriginalFunction():void
    {
        // given
        assertNull(mockie.storedParameter);
        given(mockie.callingOriginal(any())).will(callOriginal());
        // when
        mockie.callingOriginal("a parameter to be stored in a field");
        // then
        assertEquals("a parameter to be stored in a field", mockie.storedParameter);
    }

    public function testWillAllowSettingPublicVariablesMarkedAsBindable():void
    {
        given(mockie.bindableProperty = any()).will(callOriginal());
        given(mockie.bindableProperty).will(callOriginal());

        mockie.bindableProperty = "some new value";

        assertEquals("some new value", mockie.bindableProperty);
    }
}
}