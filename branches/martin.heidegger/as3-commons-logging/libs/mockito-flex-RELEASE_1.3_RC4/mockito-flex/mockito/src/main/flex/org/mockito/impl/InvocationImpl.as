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
import org.mockito.api.Invocation;
import org.mockito.api.Matcher;
import org.mockito.api.OriginalCallSeam;
import org.mockito.api.StubbingContext;
import org.mockito.api.StubbingContextAware;

public class InvocationImpl implements Invocation, StubbingContext
{
    private var _verified:Boolean;

    private var _target:Object;
    private var _methodName:String;
    private var _arguments:Array;
    private var _answer:Answer;
    private var _originalCallSeam:OriginalCallSeam;
    private var _sequenceNumber:int;

    public function InvocationImpl(target:Object, methodName:String, arguments:Array, originalCallSeam:OriginalCallSeam, sequenceNumber:int)
    {
        this._target = target;
        this._methodName = methodName;
        this._arguments = arguments;
        this._originalCallSeam = originalCallSeam;
        this._sequenceNumber = sequenceNumber;
    }

    public function get args():Array
    {
        return _arguments;
    }

    public function get target():Object
    {
        return _target;
    }

    public function get methodName():String
    {
        return _methodName;
    }

    private function describeArguments():String
    {
        var args:String = "";
        if (_arguments)
        {
            for each (var arg:* in _arguments)
            {
                var stringArg:String;
                if (arg is Matcher)
                {
                    stringArg = Matcher(arg).describe();
                }
                else
                    stringArg = "" + arg;
                if (args.length > 0)
                    args += ",";
                args += stringArg;
            }
        }
        return args;
    }

    public function set verified(value:Boolean):void
    {
        _verified = value;
    }

    public function get verified():Boolean
    {
        return _verified;
    }

    public function describe():String
    {
        return methodName + "(" + describeArguments() + ")";
    }

    public function matches(other:Invocation):Boolean
    {
        if (target == other.target && methodName == other.methodName)
        {
            return argumentsMatch(args, other.args);
        }
        return false;
    }

    public function argumentsMatch(expected:Array, actual:Array):Boolean
    {
        if (areEmptyArguments(expected, actual))
        {
            return true;
        }
        else if (haveTheSameLenght(expected, actual))
        {
            for (var i:int; i < expected.length; i++)
            {
                if (!match(expected[i], actual[i]))
                    return false;
            }
            return true;
        }
        return false;
    }

    private function areEmptyArguments(expected:Array, actual:Array):Boolean
    {
        return (!expected || expected.length == 0) && (!actual || actual.length == 0);
    }

    private function haveTheSameLenght(expected:Array, actual:Array):Boolean
    {
        return expected && actual && expected.length == actual.length;
    }

    public function match(expected:*, actual:*):Boolean
    {
        if (expected is Matcher)
        {
            return Matcher(expected).matches(actual);
        }
        else if (actual is Matcher)
        {
            return Matcher(actual).matches(expected);
        }
        return expected == actual;
    }

    public function addAnswer(answer:Answer):void
    {
        this._answer = answer;
    }

    public function answer(context:StubbingContext):*
    {
        if (_answer)
        {
            if (_answer is StubbingContextAware)
                StubbingContextAware(_answer).useContext(context);
            return _answer.give();
        }
        return null;
    }

    public function useMatchers(matchers:Array):void
    {
        if (matchers.length > 0 && !haveTheSameLenght(_arguments, matchers))
        {
            throw new MatcherRequiredForEveryArgument();
        }
        if (matchers.length > 0)
        {
            _arguments = matchers;
        }
    }

    public function isStubbed():Boolean
    {
        return _answer != null;
    }

    public function get invocation():Invocation
    {
        return this;
    }

    public function callOriginal():*
    {
        return _originalCallSeam.callOriginal(args);
    }

    public function get stubbingContext():StubbingContext
    {
        return this;
    }

    public function get sequenceNumber():int
    {
        return _sequenceNumber;
    }
}
}