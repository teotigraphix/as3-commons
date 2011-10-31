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

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.rpc.IService;
	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class HTTPServiceService implements IService {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function HTTPServiceService() {
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// httpService
		// ----------------------------

		private var _httpService:HTTPMultiService;

		/**
		 * The <code>HTTPMultiService</code> that is used by the current <code>WebServiceService</code>
		 * to perform its task.
		 */
		public function get httpService():HTTPMultiService {
			return _httpService;
		}

		/**
		 * @private
		 */
		public function set httpService(value:HTTPMultiService):void {
			_httpService = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function call(methodName:String, ...parameters):IOperation {
			Assert.state(httpService != null, "The httpService property must not be null");
			return new HTTPServiceOperation(httpService, methodName, parameters);
		}

	}
}
