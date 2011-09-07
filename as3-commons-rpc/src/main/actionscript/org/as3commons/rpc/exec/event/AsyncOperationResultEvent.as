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
package org.as3commons.rpc.exec.event {
	import flash.events.Event;

	import org.as3commons.rpc.exec.impl.AsyncOperationToken;

	/**
	 * Result of an asynchronous operation.
	 *
	 * @author Jan Van Coppenolle
	 */
	public class AsyncOperationResultEvent extends Event {
		public static const RESULT:String = "result";

		public var result:*;
		public var operation:String;
		public var token:AsyncOperationToken;

		public function AsyncOperationResultEvent(result:*=null, operation:String=null, token:AsyncOperationToken=null) {
			super(RESULT);
			this.result = result;
			this.operation = operation;
			this.token = token;
		}

		override public function clone():Event {
			return new AsyncOperationResultEvent(result, operation, token);
		}
	}
}
