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
import asmock.framework.MockRepository;

import asmock.framework.asmock_internal;

import flash.events.ErrorEvent;

    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

import org.flemit.reflection.MethodInfo;
import org.flemit.reflection.Type;
import org.floxy.IInvocation;
import org.mockito.api.Invocation;
    import org.mockito.api.MockCreator;
    import org.mockito.api.MockInterceptor;

import org.mockito.api.SequenceNumberGenerator;

use namespace asmock_internal;
    /**
     * Asmock bridge. Utilizes asmock facilities to create mock objects.
     * @private  
     */
    public class AsmockMockery extends MockRepository implements MockCreator 
    {
        public var interceptor:MockInterceptor;
        
        protected var _names:Dictionary = new Dictionary();

        private var sequenceNumberGenerator:SequenceNumberGenerator;

        public function AsmockMockery(interceptor:MockInterceptor, sequenceNumberGenerator:SequenceNumberGenerator)
        {
            this.interceptor = interceptor;
            this.sequenceNumberGenerator = sequenceNumberGenerator;
        }

        /**
         * A factory method that creates Invocation out of asmock invocation
         * @param invocation asmock invocation object
         * @return mockito invocation
         * 
         */
        public function createFrom(invocation:IInvocation):Invocation
        {
            var niceMethodName:String = new AsmockMethodNameFormatter().extractFunctionName(invocation.method.fullName);
            return new InvocationImpl(invocation.invocationTarget,
                                      invocation.method.fullName,
                                      invocation.arguments,
                                      new AsmockOriginalCallSeam(invocation),
                                      sequenceNumberGenerator.next());
        }

        public function prepareClasses(classes:Array, calledWhenClassesReady:Function, calledWhenPreparingClassesFailed:Function=null):void
        {
            var dispatcher:IEventDispatcher = super.prepare(classes);
            var repositoryPreparedHandler:Function = function (e:Event):void
            {
                calledWhenClassesReady();
            };
            var repositoryPreparationFailed:Function = function (e:Event):void
            {
                if (calledWhenPreparingClassesFailed != null)
                    calledWhenPreparingClassesFailed();
            };
            dispatcher.addEventListener(Event.COMPLETE, repositoryPreparedHandler);
            dispatcher.addEventListener(ErrorEvent.ERROR, repositoryPreparationFailed);
        }

        public function mock(clazz:Class, name:String=null, constructorArgs:Array=null):*
        {
            if (name == null)
                name = Type.getType(clazz).name;
            var mock:Object = createStrict(clazz, constructorArgs);
            registerAlias(mock, name);
            return mock;
        }

        override asmock_internal function methodCall(invocation:IInvocation, target:Object, method:MethodInfo, arguments:Array):*
        {
            return interceptor.methodCalled(createFrom(invocation));
        }

        /**
         * 
         * @param mock
         * @param name
         */
        public function registerAlias(mock:Object, name:String):void
        {
            _names[mock] = name;
        }
    }
}