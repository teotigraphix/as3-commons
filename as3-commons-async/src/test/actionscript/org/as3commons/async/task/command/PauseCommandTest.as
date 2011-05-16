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
package org.as3commons.async.task.command {
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	import flexunit.framework.Assert;

	import org.as3commons.async.operation.OperationEvent;

	public class PauseCommandTest {

		public function PauseCommandTest() {
			super();
		}

		[Test(async, timeout = 2000)]
		public function testExecute():void {
			var pc:PauseCommand = new PauseCommand(500);
			var handleError:Function = function():void {
				Assert.assertTrue(false);
			};
			var id:uint = setTimeout(handleError, 1000);
			var handleComplete:Function = function(event:OperationEvent):void {
				Assert.assertStrictlyEquals(pc, event.target);
				clearInterval(id);
			};
			pc.addCompleteListener(handleComplete);
			pc.execute();
		}
	}
}
