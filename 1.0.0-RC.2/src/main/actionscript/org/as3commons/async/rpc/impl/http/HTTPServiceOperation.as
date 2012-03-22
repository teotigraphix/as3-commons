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

	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.http.HTTPMultiService;
	import mx.rpc.http.HTTPService;
	import mx.rpc.http.Operation;

	/**
	 * An <code>IOperation</code> that invokes a method on a HTTP webservice.
	 * @author Roland Zwaga
	 */
	public class HTTPServiceOperation extends AbstractHTTPServiceOperation {

		/**
		 * Creates a new <code>HTTPServiceOperation</code> instance.
		 * @param httpService
		 * @param methodName
		 * @param parameters
		 *
		 */
		public function HTTPServiceOperation(httpService:HTTPMultiService, methodName:String, parameters:Array=null) {
			super(httpService, methodName, parameters);
			invokeRemoteMethod();
		}

		override protected function invokeRemoteMethod():void {

			var operation:Operation = Operation(httpService.getOperation(methodName));
			operation.arguments = parameters;

			var token:AsyncToken = operation.send();
			var responder:Responder = new Responder(resultHandler, faultHandler);
			token.addResponder(responder);
		}

	}
}
