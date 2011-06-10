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

	/**
	 * An async mock operation. For testing purposes, obviously. :)
	 * @author Christophe Herreman
	 */
	public class MockOperation extends AbstractOperation {

		public static const DEFAULT_MAX_DELAY:int = 1000;

		private var _result:*;

		private var _func:Function;

		private var _delay:int = DEFAULT_MAX_DELAY;

		/**
		 * Creates a new <code>MockOperation</code> instance.
		 * @param resultData
		 * @param delay
		 * @param returnError
		 * @param func
		 * @param useRandomDelay
		 *
		 */
		public function MockOperation(resultData:*, delay:int = DEFAULT_MAX_DELAY, returnError:Boolean = false, func:Function = null, useRandomDelay:Boolean = true) {
			super();
			initMockOperation(resultData, delay, returnError, func, useRandomDelay);
		}

		protected function initMockOperation(resultData:*, delay:int, returnError:Boolean, func:Function, useRandomDelay:Boolean):void {
			_result = resultData;
			_delay = (useRandomDelay) ? Math.random() * delay : delay;
			_func = func;

			//var val:Number = Math.random();
			if (returnError) {
				setTimeout(function():void {
					error = "error occurred";
					if (_func != null) {
						_func();
					}
					dispatchErrorEvent();
				}, _delay);
			} else {
				setTimeout(function(data:*):void {
					result = data;
					if (_func != null) {
						_func();
					}
					dispatchCompleteEvent();
				}, _delay, _result);
			}
		}
	}
}
