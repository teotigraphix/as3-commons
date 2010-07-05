package org.mockito
{
import org.mockito.impl.MatcherRequiredForEveryArgument;
import org.mockito.impl.matchers.GenericMatcher;

public class TestMatchers extends MockitoTestCase
{
    public function TestMatchers()
    {
        super([TestClass]);
    }

    public function testWillRemindUserThatHeNeedsCorrectNumberOfMatchers():void
    {
        // given
        var mockie:TestClass = TestClass(mock(TestClass));

        try
        {
            // when
            mockie.baz("one", any());
            fail();
        }
            //then
        catch (e:MatcherRequiredForEveryArgument) {
        }
    }

    public function testWillMultipleArgsMatchers():void
    {
        // given
        var mockie:TestClass = TestClass(mock(TestClass));

        //when
        mockie.baz("one", 145);

        // then
        verify().that(mockie.baz(eq("one"), any()));
    }

    public function testWillUseCustomArgumentMatcher():void
    {
        // given
        var mockie:TestClass = TestClass(mock(TestClass));

        //when
        mockie.baz("one two three", 10);

        // then
        verify().that(mockie.baz(argThat(new GenericMatcher("two", contains, "contains")), eq(10)));
    }

    public function testWillMatchAnyOfType():void
    {
        // given
        var mockie:TestClass = mock(TestClass);

        //when
        mockie.qux("one two three");

        // then
        verify().that(mockie.qux(anyOf(String)));
    }

    public function testWillMatchPropertyChain():void
    {
        // given
        var mockie:TestClass = mock(TestClass);

        var complex:Object = {child:{property:"abc"}};
        //when
        mockie.qux(complex);

        // then
        verify().that(mockie.qux(havingPropertyOf(["child", "property"], "abc")));
        
    }

    public function testWillMatchProperty():void
    {
        // given
        var mockie:TestClass = mock(TestClass);

        var complex:Object = {property:"abc"};
        //when
        mockie.qux(complex);

        // then
        verify().that(mockie.qux(havingPropertyOf("property", "abc")));
    }
    
    public function testWillMatchNaN():void
    {
        // given
        var mockie:TestClass = mock(TestClass);

        //when
        mockie.foo(NaN);

        // then
        verify().that(mockie.foo(isItNaN()));
    }

    public function testWillMatchWithFunctionMatcher():void
    {
        // given
        var mockie:TestClass = mock(TestClass);
        //when
        mockie.foo(1234);
        // then
        verify().that(mockie.foo(argThatMatches(1234, function (expected:int, actual:int):Boolean
        {
            return expected == actual;
        })));
    }

    private function contains(expected:String, actual:String):Boolean {
        return actual.indexOf(expected) != -1;
    }
}
}