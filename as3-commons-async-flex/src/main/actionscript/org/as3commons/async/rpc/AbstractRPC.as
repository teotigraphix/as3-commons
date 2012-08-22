/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.async.rpc {
import flash.errors.IllegalOperationError;

import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import org.as3commons.async.operation.impl.AbstractOperation;

/**
 * Abstract base class for RPC operations.
 *
 * @author Roland Zwaga
 */
public class AbstractRPC extends AbstractOperation {

    // --------------------------------------------------------------------
    //
    // Constructor
    //
    // --------------------------------------------------------------------

    public function AbstractRPC(methodName:String, parameters:Array = null) {
        super();
        initAbstractRPC(methodName, parameters);
    }

    private var _methodName:String;
    private var _parameters:Array;

    // --------------------------------------------------------------------
    //
    // Public Properties
    //
    // --------------------------------------------------------------------

    public function get methodName():String {
        return _methodName;
    }

    public function get parameters():Array {
        return _parameters;
    }

    /**
     * Assigns the <code>FaultEvent</code> value to the <code>error</code> property
     * and dispatches the <code>OperationEvent.ERROR</code> event.
     * @param event The specified <code>FaultEvent</code>
     * @see org.as3commons.async.operation.OperationEvent#ERROR OperationEvent.ERROR
     */
    protected function faultHandler(event:FaultEvent):void {
        error = event;
        dispatchErrorEvent();
    }

    // --------------------------------------------------------------------
    //
    // Protected Methods
    //
    // --------------------------------------------------------------------

    protected function invokeRemoteMethod():void {
        throw new IllegalOperationError("invokeRemoteMethod not implemented in base class");
    }

    /**
     * Assigns the <code>ResultEvent.result</code> value to the <code>result</code> property
     * and dispatches the <code>OperationEvent.COMPLETE</code> event.
     * @param event The specified <code>ResultEvent</code>.
     * @see org.as3commons.async.operation.OperationEvent#COMPLETE OperationEvent.COMPLETE
     */
    protected function resultHandler(event:ResultEvent):void {
        result = event.result;
        dispatchCompleteEvent();
    }

    private function initAbstractRPC(methodName:String, parameters:Array):void {
        _methodName = methodName;
        _parameters = parameters;
    }
}
}
