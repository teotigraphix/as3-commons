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

	import asmock.integration.flexunit.IncludeMocksRule;

	import flash.events.Event;
	import flash.utils.setTimeout;

	import flexunit.framework.Assert;

	import org.as3commons.async.command.IAsyncCommand;
	import org.as3commons.async.operation.OperationEvent;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class TaskCommandTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			IAsyncCommand //
			]);

		public function TaskCommandTest() {
			super();
		}

		[Test(async, timeout = 2000)]
		public function testReset():void {
			var c1:IAsyncCommand = IAsyncCommand(mockRepository.createStub(IAsyncCommand));
			var c2:IAsyncCommand = IAsyncCommand(mockRepository.createStub(IAsyncCommand));

			mockRepository.stubEvents(c1);
			mockRepository.stubEvents(c2);

			mockRepository.replayAll();

			var tc:TaskCommand = new TaskCommand();
			tc.addCommand(c1);
			tc.addCommand(c2);
			Assert.assertEquals(2, tc.numCommands);
			tc.execute();
			var completeHandler:Function = function(event:Event):void {
				Assert.assertEquals(0, tc.numCommands);
				tc.reset();
				Assert.assertEquals(2, tc.numCommands);
			};
			tc.addCompleteListener(completeHandler);
			c1.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, c1));
			c2.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, c2));
		}
	}
}
