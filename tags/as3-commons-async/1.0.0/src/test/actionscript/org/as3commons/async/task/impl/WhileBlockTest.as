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
package org.as3commons.async.task.impl {
	import asmock.framework.Expect;
	import asmock.integration.flexunit.IncludeMocksRule;

	import flexunit.framework.Assert;

	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.impl.MockOperation;
	import org.as3commons.async.task.event.TaskEvent;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class WhileBlockTest extends AbstractTestWithMockRepository {

		private var _counter:uint = 0;

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			ICommand //
			]);

		public function WhileBlockTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_counter = 0;
		}

		[Test]
		public function testExecute():void {
			var command:ICommand = ICommand(mockRepository.createStub(ICommand));

			Expect.call(command.execute()).ignoreArguments().repeat.times(10, 10).returnValue(null);

			mockRepository.replayAll();

			var wb:WhileBlock = new WhileBlock(new FunctionConditionProvider(whileFunction));
			wb.and(command);
			wb.execute();

			mockRepository.verifyAll();
		}

		[Test(async, timeout=2000)]
		public function testExecuteWithAsync():void {
			var command1:Function = function():void {
				Assert.assertTrue(_counter < 11);
			}

			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertEquals(11, _counter);
			}

			var wb:WhileBlock = new WhileBlock(new FunctionConditionProvider(whileFunction));
			wb.next(MockOperation, "test1", 100, false, command1).end();
			wb.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			wb.execute();

		}

		protected function whileFunction():Boolean {
			return (_counter++ < 10);
		}

	}
}
