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
package org.as3commons.async.rpc.impl.soap {

import mx.rpc.AbstractOperation;
import mx.rpc.soap.ISOAPDecoder;
import mx.rpc.soap.ISOAPEncoder;
import mx.rpc.soap.Operation;
import mx.rpc.soap.WebService;

import org.as3commons.async.rpc.impl.AbstractServiceOperation;

/**
 * An <code>IOperation</code> that invokes a method on a SOAP based webservice.
 * @author Roland Zwaga
 */
public class WebServiceOperation extends AbstractServiceOperation {

    /**
     * Creates a new <code>WebServiceOperation</code> instance.
     * @param webService
     * @param methodName
     * @param parameters
     */
    public function WebServiceOperation(webService:WebService, methodName:String, parameters:Array = null, encoder:ISOAPEncoder = null, decoder:ISOAPDecoder = null) {
        super(webService, methodName, parameters);
        _encoder = encoder;
        _decoder = decoder;
    }

    private var _encoder:ISOAPEncoder;
    protected function get encoder():ISOAPEncoder {
        return _encoder;
    }

    private var _decoder:ISOAPDecoder;
    protected function get decoder():ISOAPDecoder {
        return _decoder;
    }

    protected function get webService():WebService {
        return super.service as WebService;
    }

    override protected function getOperation():AbstractOperation {
        var result:AbstractOperation = super.getOperation();

        if (result is Operation) {
            Operation(result).encoder = encoder;
            Operation(result).decoder = decoder;
        }

        return result;
    }
}
}
