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

	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import org.as3commons.async.operation.impl.AbstractOperation;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AsyncTokenOperation extends AbstractOperation {
		private var _token:AsyncToken;

		/**
		 * Creates a new <code>AsyncTokenOperation</code> instance.
		 */
		public function AsyncTokenOperation(token:AsyncToken) {
			super();
			_token = token;
			_token.addResponder(new Responder(resultHandler, faultHandler));
		}

		public function get asyncToken():AsyncToken {
			return _token;
		}

		public function set asyncToken(value:AsyncToken):void {
			_token = value;
		}

		protected function faultHandler(event:FaultEvent):void {
			error = event;
			dispatchErrorEvent();
		}

		protected function resultHandler(event:ResultEvent):void {
			result = event.result;
			dispatchCompleteEvent();
		}

	}
}
