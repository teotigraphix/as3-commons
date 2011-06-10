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

	import asmock.framework.SetupResult;
	import asmock.integration.flexunit.IncludeMocksRule;

	import flash.events.Event;

	import flexunit.framework.Assert;

	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.OperationEvent;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class TaskCommandTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			ICommand //
			]);

		public function TaskCommandTest() {
			super();
		}

		[Test]
		public function testReset():void {
			var c1:ICommand = ICommand(mockRepository.createStrict(ICommand));
			var c2:ICommand = ICommand(mockRepository.createStrict(ICommand));

			SetupResult.forCall(c1.execute()).returnValue(null);
			SetupResult.forCall(c2.execute()).returnValue(null);

			mockRepository.replayAll();

			var tc:TaskCommand = new TaskCommand();
			tc.addCommand(c1);
			tc.addCommand(c2);
			Assert.assertEquals(2, tc.numCommands);
			var completeHandler:Function = function(event:Event):void {
				Assert.assertEquals(0, tc.numCommands);
				tc.reset();
				Assert.assertEquals(2, tc.numCommands);
			};
			tc.addCompleteListener(completeHandler);
			tc.execute();
		}
	}
}
