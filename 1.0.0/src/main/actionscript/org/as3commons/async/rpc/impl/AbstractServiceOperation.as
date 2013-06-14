package org.as3commons.async.rpc.impl {
import mx.rpc.AbstractOperation;
import mx.rpc.AbstractService;
import mx.rpc.AsyncToken;
import mx.rpc.Responder;

import org.as3commons.async.operation.ICancelableOperation;
import org.as3commons.async.rpc.AbstractRPC;
import org.as3commons.lang.Assert;

public class AbstractServiceOperation extends AbstractRPC implements ICancelableOperation {

    private var _operation:AbstractOperation;
    private var _token:AsyncToken;

    public function AbstractServiceOperation(service:AbstractService, methodName:String, parameters:Array = null) {
        Assert.notNull(service);

        super(methodName, parameters);

        _service = service;

        invokeRemoteMethod();
    }

    private var _service:AbstractService;
    protected function get service():AbstractService {
        return _service;
    }

    public function cancel():void {
        if (null != _operation) {
            var messageId:String = null;

            if (_token && _token.message) {
                messageId = _token.message.messageId;
            }

            _operation.cancel(messageId);
        }
    }

    override protected function invokeRemoteMethod():void {
        _operation = getOperation();
        _operation.arguments = parameters;

        _token = _operation.send();
        _token.addResponder(new Responder(resultHandler, faultHandler));
    }

    protected function getOperation():AbstractOperation {
        return service.getOperation(methodName);
    }

}
}
