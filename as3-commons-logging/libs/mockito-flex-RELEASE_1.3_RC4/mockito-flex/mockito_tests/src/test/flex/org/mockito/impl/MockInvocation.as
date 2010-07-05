package org.mockito.impl
{
    import org.mockito.api.Invocation;

    public class MockInvocation implements Invocation
    {
        private var _target:Object;
        private var _methodName:String;
        private var _arguments:Array;
        
        public function MockInvocation(target:Object, methodName:String, arguments:Array)
        {
            this._target = target;
            this._methodName = methodName;
            this._arguments = arguments;
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
        
    }
}