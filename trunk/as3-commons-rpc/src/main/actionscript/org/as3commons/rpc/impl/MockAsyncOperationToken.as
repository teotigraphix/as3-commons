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
	import org.as3commons.rpc.events.AsyncOperationFaultEvent;
	import org.as3commons.rpc.events.AsyncOperationResultEvent;
	import org.as3commons.rpc.utils.deferExec;

	[Event(name="result", type="org.as3commons.rpc.exec.event.AsyncOperationResultEvent")]
	[Event(name="fault", type="org.as3commons.rpc.exec.event.AsyncOperationFaultEvent")]

	/**
	 * Mock token for an asynchronous operation.
	 * Triggers result or fault handlers on reponders.
	 *
	 * @author Jan Van Coppenolle
	 */
	public class MockAsyncOperationToken extends AsyncOperationToken {
		
		/**
		 * @private
		 */
		public function MockAsyncOperationToken(operation:String=null) {
			super(operation);
		}
		
		////////////////////////////////////////////////////////////////////////

		public function asyncResult(result:Object):void {
			var event:AsyncOperationResultEvent = new AsyncOperationResultEvent(result, operation, this);
			deferExec(resultHandler, event);
		}

		public function asyncFault(fault:Object):void {
			var event:AsyncOperationFaultEvent = new AsyncOperationFaultEvent(fault, operation, this);
			deferExec(faultHandler, event);
		}
	}
}
