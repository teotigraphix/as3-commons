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

	import mx.rpc.soap.WebService;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.rpc.impl.AbstractRPCService;
	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class WebServiceService extends AbstractRPCService {

		/**
		 * Creates a new <code>WebServiceService</code> instance.
		 *
		 */
		public function WebServiceService() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// remoteObject
		// ----------------------------

		private var _webService:WebService;

		/**
		 * The <code>WebService</code> that is used by the current <code>WebServiceService</code>
		 * to perform its task.
		 */
		public function get webService():WebService {
			return _webService;
		}

		/**
		 * @private
		 */
		public function set webService(value:WebService):void {
			_webService = value;
		}

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function call(methodName:String, ... parameters):IOperation {
			Assert.state(webService != null, "The webService property must not be null");
			return new WebServiceOperation(webService, methodName, parameters);
		}

	}
}
