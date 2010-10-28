package org.mockito
{
import mx.events.ResizeEvent;
import mx.rpc.IResponder;

public class MockieClass
{
    public function MockieClass()
    {
    }

    public function foo(arg:Number = 0):String
    {
        return "foo";
    }

    public function bar(arg:int = 0):void
    {

    }

    public function argumentless():void
    {
    }

    public function baz(name:String, arg:int):void
    {
    }

    public function qux(anything:Object):void
    {

    }

    public function asyncWithCallback(callback:Function):void
    {

    }

    public function asyncWithComplexCallback(responder:*):*
    {
        return null;
    }

    public var storedParameter:String;

    [Bindable]
    public var bindableProperty:String;

    public function callingOriginal(param:String):void
    {
        storedParameter = param;
    }
}
}