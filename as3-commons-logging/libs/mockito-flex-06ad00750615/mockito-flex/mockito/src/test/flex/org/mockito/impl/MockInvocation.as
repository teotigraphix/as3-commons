package org.mockito.impl
{
import org.mockito.api.Answer;
import org.mockito.api.Invocation;
import org.mockito.api.StubbingContext;

public class MockInvocation implements Invocation
{
    private var _target:Object;
    private var _methodName:String;
    private var _arguments:Array;

    public function MockInvocation(target:Object, methodName:String, args:Array)
    {
        this._target = target;
        this._methodName = methodName;
        this._arguments = args;
    }

    public function get verified():Boolean
    {
        return false;
    }

    public function set verified(b:Boolean):void
    {
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

    public function describe():String
    {
        return null;
    }

    public function matches(other:Invocation):Boolean
    {
        return false;
    }

    public function addAnswer(answer:Answer):void
    {
    }

    public function answer(context:StubbingContext):*
    {
        return null;
    }

    public function useMatchers(matchers:Array):void
    {
    }

    public function isStubbed():Boolean
    {
        return false;
    }

    public function get stubbingContext():StubbingContext
    {
        return null;
    }

    public function get sequenceNumber():int
    {
        return 0;
    }
}
}