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
package org.mockito.impl.matchers
{
import org.mockito.api.Matcher;
import org.mockito.api.MatcherDescriber;

public class GenericMatcher implements Matcher
{
    private var expected:Object;

    private var matching:Function;

    private var description:Object;

    /**
     * Creates generic matcher
     * @param expected expected value
     * @param matching a matcher function of a signature (expected:*, actual:*):Boolean
     * @param description can be a <code>String</code>, a function of a signature (matcher:Matcher, expected:*):String,
     * or a MatcherDescription implementation 
     */
    public function GenericMatcher(expected:Object, matching:Function, description:Object = null)
    {
        this.expected = expected;
        this.matching = matching;
        this.description = description;
    }

    public function matches(value:*):Boolean
    {
        return matching(expected, value);
    }

    public function describe():String
    {
        if (description is MatcherDescriber)
            return MatcherDescriber(description).describe(expected);
        else if (description is Function)
        {
            var func:Function = description as Function;
            return func(this, expected);
        } else if (description)
            return "" + description;
        return "";
    }
}
}