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
import org.mockito.api.stubbing.ArgumentAction;
import org.mockito.api.stubbing.ArgumentMethodSelector;
import org.mockito.api.stubbing.ArgumentRelatedAnswer;

public class MethodRelatedAction implements ArgumentAction, ArgumentMethodSelector
{
    private var answer:ArgumentRelatedAnswer;
    private var methodName:String;
    private var args:Array;
    public function MethodRelatedAction(methodName:String, answer:ArgumentRelatedAnswer)
    {
        this.answer = answer;
        this.methodName = methodName;
    }

    public function take(arg:*):void
    {
        var func:Function;
        if (methodName)
        {
            validateArgAsFunction(arg[methodName]);
            func = arg[methodName] as Function;
        }
        else
        {
            validateArgAsFunction(arg);
            func = arg as Function;
        }
        func.apply(null, args);
    }

    private function validateArgAsFunction(arg:*):void
    {
        if (!(arg is Function))
            throw new ArgumentNotAFunction("Specified argument is not a function");
    }

    public function andCall():ArgumentRelatedAnswer
    {
        return answer;
    }

    public function andCallWithArgs(...args):ArgumentRelatedAnswer
    {
        this.args = args;
        return answer;
    }

    public function describe():String
    {
        return methodName ? "call function " + methodName + describeArgs()
                          : "call it as function " + describeArgs();
    }

    private function describeArgs():String
    {
        return "(" + (args ? args.join(","): "") + ")";
    }
}
}