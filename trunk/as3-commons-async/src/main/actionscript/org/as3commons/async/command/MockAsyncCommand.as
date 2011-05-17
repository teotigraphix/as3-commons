/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.async.command {

	import flash.utils.setTimeout;

	import org.as3commons.async.operation.AbstractOperation;

	public class MockAsyncCommand extends AbstractOperation implements ICommand {

		private var _fail:Boolean;
		private var _timeout:Number = 1;
		private var _func:Function = null;

		public function MockAsyncCommand(fail:Boolean = false, timeout:Number = 1, func:Function = null) {
			super();
			initMockAsyncCommand(fail, timeout, func);
		}

		private function initMockAsyncCommand(fail:Boolean, timeout:Number, func:Function):void {
			_fail = fail;
			_timeout = timeout;
			_func = func;
		}


		public function execute():* {
			if (_func != null) {
				_func();
			}
			if (_fail) {
				setTimeout(dispatchErrorEvent, _timeout);
			} else {
				setTimeout(dispatchCompleteEvent, _timeout);
			}
		}

	}
}
