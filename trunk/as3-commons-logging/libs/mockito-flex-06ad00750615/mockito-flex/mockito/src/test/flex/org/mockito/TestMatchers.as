package org.mockito
{
import org.flexunit.asserts.*;
import org.flexunit.rules.IMethodRule;
import org.mockito.impl.MatcherRequiredForEveryArgument;
import org.mockito.impl.matchers.GenericMatcher;
import org.mockito.integrations.flexunit4.MockitoRule;
import org.mockito.integrations.*;

[Mock(type="org.mockito.MockieClass")]
public class TestMatchers
{
    [Rule]
    public var mockitoRule:IMethodRule = new MockitoRule();

    public function TestMatchers()
    {
    }

    [Test]
    public function testWillRemindUserThatHeNeedsCorrectNumberOfMatchers():void
    {
        // given
        var mockie:MockieClass = MockieClass(mock(MockieClass));

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

    [Test]
    public function testWillMultipleArgsMatchers():void
    {
        // given
        var mockie:MockieClass = MockieClass(mock(MockieClass));

        //when
        mockie.baz("one", 145);

        // then
        verify().that(mockie.baz(eq("one"), any()));
    }

    [Test]
    public function testWillUseCustomArgumentMatcher():void
    {
        // given
        var mockie:MockieClass = MockieClass(mock(MockieClass));

        //when
        mockie.baz("one two three", 10);

        // then
        verify().that(mockie.baz(argThat(new GenericMatcher("two", contains, "contains")), eq(10)));
    }

    [Test]
    public function testWillMatchAnyOfType():void
    {
        // given
        var mockie:MockieClass = mock(MockieClass);

        //when
        mockie.qux("one two three");

        // then
        verify().that(mockie.qux(anyOf(String)));
    }

    [Test]
    public function testWillMatchPropertyChain():void
    {
        // given
        var mockie:MockieClass = mock(MockieClass);

        var complex:Object = {child:{property:"abc"}};
        //when
        mockie.qux(complex);

        // then
        verify().that(mockie.qux(havingPropertyOf(["child", "property"], "abc")));
        
    }

    [Test]
    public function testWillMatchProperty():void
    {
        // given
        var mockie:MockieClass = mock(MockieClass);

        var complex:Object = {property:"abc"};
        //when
        mockie.qux(complex);

        // then
        verify().that(mockie.qux(havingPropertyOf("property", "abc")));
    }

    [Test]
    public function testWillMatchNaN():void
    {
        // given
        var mockie:MockieClass = mock(MockieClass);

        //when
        mockie.foo(NaN);

        // then
        verify().that(mockie.foo(isItNaN()));
    }

    [Test]
    public function testWillMatchWithFunctionMatcher():void
    {
        // given
        var mockie:MockieClass = mock(MockieClass);
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