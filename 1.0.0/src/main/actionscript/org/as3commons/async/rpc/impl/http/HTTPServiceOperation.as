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
package org.as3commons.async.rpc.impl.http {

import mx.rpc.http.HTTPMultiService;

import org.as3commons.async.rpc.impl.AbstractServiceOperation;

/**
 * An <code>IOperation</code> that invokes a method on a HTTP webservice.
 * @author Roland Zwaga
 */
public class HTTPServiceOperation extends AbstractServiceOperation {

    /**
     * Creates a new <code>HTTPServiceOperation</code> instance.
     * @param httpService
     * @param methodName
     * @param parameters
     */
    public function HTTPServiceOperation(httpService:HTTPMultiService, methodName:String, parameters:Array = null) {
        super(httpService, methodName, parameters);
    }

    protected function get httpService():HTTPMultiService {
        return super.service as HTTPMultiService;
    }


}
}
