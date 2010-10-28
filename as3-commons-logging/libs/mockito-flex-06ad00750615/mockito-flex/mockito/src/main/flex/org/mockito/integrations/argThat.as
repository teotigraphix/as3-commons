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
package org.mockito.integrations
{
import org.mockito.api.Matcher;

/**
 * A fluent interface for custom matcher
 * Example:
 * <listing>
 * verify().that(system.login(argThat(new HashOnlyCapitalLettersMatcher())));
 * </listing>
 *
 * A good practice is to create a matcher recording function somewhere and name it
 * after the matcher. It's important to return a wildcard from the function to let it
 * work with any arugment of the function
 * <listing>
 * function hasOnlyCapitalLetters():*
 * {
 *     argThat(new HashOnlyCapitalLettersMatcher());
 * }
 * </listing>
 */
public function argThat(matcher:Matcher):*
{
    return currentMockito.argThat(matcher);
}
}