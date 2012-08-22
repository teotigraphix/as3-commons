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
package org.as3commons.async.rpc.impl.remoting {

import mx.rpc.remoting.RemoteObject;

import org.as3commons.async.rpc.impl.AbstractServiceOperation;
import org.as3commons.lang.Assert;

/**
 * An <code>IOperation</code> that invokes a method on a remote object.
 * @author Christophe Herreman
 */
public class RemoteObjectOperation extends AbstractServiceOperation {

    /**
     * Creates a new <code>RemoteObjectOperation</code> instance.
     * @param remoteObject
     * @param methodName
     * @param parameters
     */
    public function RemoteObjectOperation(remoteObject:RemoteObject, methodName:String, parameters:Array = null) {
        Assert.notNull(remoteObject, "The remote object is required");
        Assert.hasText(methodName, "The method name must not be null or an empty string");

        super(remoteObject, methodName, parameters);
    }

    protected function get remoteObject():RemoteObject {
        return super.service as RemoteObject;
    }

}
}
