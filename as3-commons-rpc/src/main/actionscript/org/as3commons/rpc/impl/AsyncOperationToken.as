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
	import flash.events.EventDispatcher;

	import org.as3commons.rpc.IAsyncOperationResponder;
	import org.as3commons.rpc.events.AsyncOperationFaultEvent;
	import org.as3commons.rpc.events.AsyncOperationResultEvent;

	[Event(name="result", type="org.as3commons.rpc.exec.event.AsyncOperationResultEvent")]
	[Event(name="fault", type="org.as3commons.rpc.exec.event.AsyncOperationFaultEvent")]

	/**
	 * Token for an asynchronous operation.
	 * Triggers result or fault handlers on reponders.
	 *
	 * @author Jan Van Coppenolle
	 */
	public dynamic class AsyncOperationToken extends EventDispatcher implements IAsyncOperationResponder {

		/**
		 * @private
		 */
		public function AsyncOperationToken(operation:String=null) {
			super();
			this.operation = operation;
			responders = [];
		}
		
		////////////////////////////////////////////////////////////////////////

		public var operation:String;
		
		protected var responders:Array;

		////////////////////////////////////////////////////////////////////////
		
		public function addResponder(responder:IAsyncOperationResponder):void {
			responders.push(responder);
		}

		////////////////////////////////////////////////////////////////////////
		// IAsyncOperationResponder

		/**
		 * @inherit
		 */
		public function resultHandler(event:AsyncOperationResultEvent):void {
			var responder:IAsyncOperationResponder;

			for each (responder in responders) {
				responder.resultHandler(event);
			}

			if (hasEventListener(AsyncOperationResultEvent.RESULT)) {
				dispatchEvent(event);
			}

			responders = null;
		}
		
		/**
		 * @inherit
		 */
		public function faultHandler(event:AsyncOperationFaultEvent):void {
			var responder:IAsyncOperationResponder;

			for each (responder in responders) {
				responder.faultHandler(event);
			}

			if (hasEventListener(AsyncOperationFaultEvent.FAULT)) {
				dispatchEvent(event);
			}

			responders = null;
		}
	}
}
