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
package org.as3commons.rpc.impl {
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.getTimer;
	
	import org.as3commons.rpc.AbstractService;

	[Event(name="result", type="org.as3commons.rpc.exec.event.AsyncOperationResultEvent")]
	[Event(name="fault", type="org.as3commons.rpc.exec.event.AsyncOperationFaultEvent")]
	
	/**
	 * Remoting Service implementation.
	 *
	 * @author Jan Van Coppenolle
	 */
	public class RemotingService extends AbstractService {
		private static const INFO_FIELD_NAME:String = "info";
		private static const FORWARD_SLASH_CHAR:String = "/";
		private static const APPEND_TO_GATEWAY_URL_CALLBACK:String = "AppendToGatewayUrl";

		/**
		 * @private
		 */
		public function RemotingService(endpoint:String=null, destination:String=null) {
			super(CONNECTION);
			/*
			CONNECTION.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			CONNECTION.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			*/
			this.endpoint = endpoint;
			this.destination = destination;
			CONNECTION.client = {APPEND_TO_GATEWAY_URL_CALLBACK:appendToGatewayUrlCallback};
			CONNECTION.addEventListener(NetStatusEvent.NET_STATUS, handler);
			CONNECTION.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handler);
		}

		////////////////////////////////////////////////////////////////////////
		
		protected const CONNECTION:NetConnection = new NetConnection();
		protected const TOKENS:Array = [];
		
		public var endpoint:String;
		public var destination:String;
		public var isConnected:Boolean;
		
		////////////////////////////////////////////////////////////////////////

		public function call(operation:String=null, ... parameters):AsyncOperationToken {
			var token:AsyncOperationToken = new AsyncOperationToken(operation);

			if (!isConnected) {
				CONNECTION.connect(endpoint);
				isConnected = true;
			}

			CONNECTION.call(destination + "." + operation, new RemotingResponder(token));

			token.addResponder(this);
			return token;
		}

		protected function handler(event:Object):void {
			trace(event.type + FORWARD_SLASH_CHAR + getTimer());
			if (event.hasOwnProperty(INFO_FIELD_NAME)) {
				trace(event.info);
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		// NetConnection Callbacks
		
		public function appendToGatewayUrlCallback(value:String):void {
		}
	}
}

import flash.net.Responder;

import org.as3commons.rpc.events.AsyncOperationFaultEvent;
import org.as3commons.rpc.events.AsyncOperationResultEvent;
import org.as3commons.rpc.impl.AsyncOperationToken;

internal class RemotingResponder extends Responder {
	private static const SOURCE_FIELD_NAME:String = "source";
	
	////////////////////////////////////////////////////////////////////////

	/**
	 * @private
	 */
	public function RemotingResponder(token:AsyncOperationToken) {
		super(result, status);
		this.token = token;
	}
	
	////////////////////////////////////////////////////////////////////////

	public var token:AsyncOperationToken;

	////////////////////////////////////////////////////////////////////////
	
	/**
	 * @private
	 */
	protected function result(data:Object):void {
		var result:Object = data.hasOwnProperty(SOURCE_FIELD_NAME) ? data[SOURCE_FIELD_NAME] : data;
		var resultEvent:AsyncOperationResultEvent = new AsyncOperationResultEvent(result, token.operation, token);
		token.resultHandler(resultEvent);
	}

	/**
	 * @private
	 */
	protected function status(data:Object):void {
		var faultEvent:AsyncOperationFaultEvent = new AsyncOperationFaultEvent(data.message, token.operation, token);
		token.faultHandler(faultEvent);
	}
}
