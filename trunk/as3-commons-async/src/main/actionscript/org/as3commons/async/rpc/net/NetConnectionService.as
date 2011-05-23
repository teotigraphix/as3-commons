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
package org.springextensions.actionscript.rpc.net {

	import flash.net.NetConnection;

	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.rpc.IService;

	/**
	 * Service that invokes methods on a NetConnection and returns an IOperation for each of these calls.
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#services
	 */
	public class NetConnectionService implements IService {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new NetConnectionService
		 *
		 * @param netConnection the netconnection used by this service
		 */
		public function NetConnectionService(netConnection:NetConnection = null) {
			this.netConnection = netConnection;
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// netConnection
		// ----------------------------

		private var _netConnection:NetConnection;

		/**
		 * Returns the NetConnection used by this service
		 * @return
		 */
		public function get netConnection():NetConnection {
			return _netConnection;
		}

		public function set netConnection(value:NetConnection):void {
			if (value !== _netConnection) {
				_netConnection = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IService
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function call(methodName:String, ... parameters):IOperation {
			return new NetConnectionOperation(netConnection, methodName, parameters);
		}
	}
}