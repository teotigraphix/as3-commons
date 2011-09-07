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
package org.as3commons.rpc {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import org.as3commons.rpc.exec.event.AsyncOperationFaultEvent;
	import org.as3commons.rpc.exec.event.AsyncOperationResultEvent;
	import org.as3commons.rpc.exec.impl.AsyncOperationToken;
	import org.as3commons.rpc.net.queueURLLoader;

	[Event(name="result", type="org.as3commons.rpc.exec.event.AsyncOperationResultEvent")]
	[Event(name="fault", type="org.as3commons.rpc.exec.event.AsyncOperationFaultEvent")]
	/**
	 * Rest Service implementation.
	 *
	 * @author Jan Van Coppenolle
	 */
	public class RestService extends AbstractService {

		/**
		 * @private
		 */
		public function RestService(baseURI:String=null) {
			super(LOADER);
			initRestService(baseURI);
		}

		public var baseURI:String;
		protected const LOADER:URLLoader = new URLLoader();
		protected const TOKENS:Array = [];

		public function close():AsyncOperationToken {
			LOADER.dispatchEvent(new Event(Event.CLOSE));
			LOADER.close();
			return TOKENS.shift(); // FIFO
		}

		////////////////////////////////////////////////////////////////////////

		public function doGet(uri:String, operation:String=null):AsyncOperationToken {
			return load(new URLRequest(baseURI + uri), operation);
		}

		public function load(request:URLRequest, operation:String=null):AsyncOperationToken {
			var token:AsyncOperationToken = new AsyncOperationToken(operation);
			queueURLLoader(LOADER, request); // FIFO
			TOKENS.push(token); // FIFO
			token.addResponder(this);
			return token;
		}

		////////////////////////////////////////////////////////////////////////

		protected function completeHandler(event:Event):void {
			var token:AsyncOperationToken = TOKENS.shift(); // FIFO
			var resultEvent:AsyncOperationResultEvent = new AsyncOperationResultEvent(LOADER.data, token.operation, token);
			token.resultHandler(resultEvent);
		}

		protected function errorHandler(event:IOErrorEvent):void {
			var token:AsyncOperationToken = TOKENS.shift(); // FIFO
			var faultEvent:AsyncOperationFaultEvent = new AsyncOperationFaultEvent(event.text, token.operation, token);
			token.faultHandler(faultEvent);
		}

		/**
		 *
		 * @param baseURI
		 */
		protected function initRestService(baseURI:String):void {
			this.baseURI = baseURI;
			LOADER.addEventListener(Event.COMPLETE, completeHandler);
			LOADER.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
	}
}
