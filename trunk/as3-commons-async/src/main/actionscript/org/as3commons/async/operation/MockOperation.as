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
package org.as3commons.async.operation {

	import flash.utils.setTimeout;

	import mx.managers.CursorManager;

	/**
	 * A async mock operation.
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#operations
	 */
	public class MockOperation extends AbstractOperation {

		public static const DEFAULT_MAX_DELAY:int = 1000;

		private var _result:*;

		private var _func:Function;

		private var _delay:int = DEFAULT_MAX_DELAY;

		/**
		 *
		 */
		public function MockOperation(resultData:*, delay:int = DEFAULT_MAX_DELAY, returnError:Boolean = false, func:Function = null) {
			super();
			mockOperationInit(resultData, delay, returnError, func);
		}

		protected function mockOperationInit(resultData:*, delay:int, returnError:Boolean, func:Function):void {
			_result = resultData;
			_delay = delay;
			_func = func;

			CursorManager.setBusyCursor();

			//var val:Number = Math.random();
			if (returnError) {
				setTimeout(function():void {
					error = "error occurred";
					if (_func != null) {
						_func();
					}
					dispatchErrorEvent();
					CursorManager.removeBusyCursor();
				}, Math.random() * _delay);
			} else {
				setTimeout(function(data:*):void {
					result = data;
					if (_func != null) {
						_func();
					}
					dispatchCompleteEvent();
					CursorManager.removeBusyCursor();
				}, Math.random() * _delay, _result);
			}
		}
	}
}