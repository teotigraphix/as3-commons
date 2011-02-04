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
import org.mockito.api.Answer;
import org.mockito.api.StubbingContext;
import org.mockito.api.StubbingContextAware;
import org.mockito.api.stubbing.ArgumentActionDefinition;
import org.mockito.api.stubbing.ArgumentRelatedAnswer;
import org.mockito.api.stubbing.ArgumentSelector;
import org.mockito.api.stubbing.ArgumentSpecifier;

public class ArgumentRelatedAnswerImpl implements ArgumentSelector, ArgumentRelatedAnswer, StubbingContextAware
{
    private var context:StubbingContext;

    private var registeredActions:Array = [];
    private var returningAnswer:ReturningAnswer;

    public function ArgumentRelatedAnswerImpl()
    {
    }

    public function give():*
    {
        if (registeredActions.length == 0)
            throw new ArgumentActionNotSpecified("Did you forget to specify action on the argument?");

        for each (var argAction:ArgumentActionDefinition in registeredActions)
        {
            argAction.take(context);
        }

        if (returningAnswer)
            return returningAnswer.give();
        return null;
    }

    public function useContext(stubbingContext:StubbingContext):void
    {
        this.context = stubbingContext;
    }

    public function and():ArgumentSelector
    {
        return this;
    }

    public function useArgument(index:int):ArgumentSpecifier
    {
        var argumentSpecifierImpl:ArgumentSpecifierImpl = new ArgumentSpecifierImpl(this, index);
        registeredActions.push(argumentSpecifierImpl);
        return argumentSpecifierImpl;
    }

    public function finallyReturnValue(returnedValue:*):Answer
    {
        returningAnswer = new ReturningAnswer(returnedValue);
        return this;
    }
}
}