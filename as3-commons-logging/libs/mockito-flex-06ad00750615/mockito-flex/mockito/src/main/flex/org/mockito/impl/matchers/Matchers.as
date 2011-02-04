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

public class Matchers
    {
        public function Matchers()
        {
        }

        public static function isNaN():Matcher
        {
            return new GenericMatcher(null, MatcherFunctions.isNotANumber, "NaN");
        } 

        public static function anyOf(clazz:Class):Matcher
        {
            return new GenericMatcher(clazz, MatcherFunctions.matchClassesFunction, MatcherDescriptions.matchClasses);
        }

        public static function havingPropertyOf(propertyChain:Object, expectedPropertyValue:Object):Matcher
        {
            return new PropertyMatcher(propertyChain, expectedPropertyValue);
        }

        public static function notNull():Matcher
        {
            return new GenericMatcher(null, MatcherFunctions.actualNotNull, "not null");
        }

        public static function eq(expected:Object):Matcher
        {
            return new GenericMatcher(expected, MatcherFunctions.eqFunction, MatcherDescriptions.eq);
        }

        public static function any():Matcher
        {
            return new GenericMatcher(null, MatcherFunctions.anyFunction, "any");
        }

    }
}