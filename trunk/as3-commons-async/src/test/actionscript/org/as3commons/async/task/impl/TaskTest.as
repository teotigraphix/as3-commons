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

	import flash.events.Event;

	import flexunit.framework.Assert;

	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.command.MockAsyncCommand;
	import org.as3commons.async.operation.MockOperation;
	import org.as3commons.async.task.IConditionProvider;
	import org.as3commons.async.task.ICountProvider;
	import org.as3commons.async.task.event.TaskEvent;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class TaskTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			ICountProvider, //
			IConditionProvider, //
			ICommand //
			]);

		private var _counter:uint = 0;

		public function TaskTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_counter = 0;
		}

		protected function incCounter():void {
			_counter++;
		}

		[Test]
		public function testAnd():void {
			var c:ICommand = ICommand(mockRepository.createStrict(ICommand));
			Expect.call(c.execute()).returnValue(null);
			mockRepository.replayAll();

			var task:Task = new Task();
			task.and(c);
			task.execute();

			mockRepository.verifyAll();
		}

		[Test(async, timeout = 500)]
		public function testAndAsync():void {
			var task:Task = new Task();
			task.and(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, onTaskComplete);
			task.execute();
		}

		[Test(async, timeout = 6000)]
		public function testAndMultipleAsync():void {
			var counter:uint = 0;
			var command1:Function = function():void {
				Assert.assertEquals(1, counter);
			}
			var command2:Function = function():void {
				Assert.assertEquals(0, counter);
				counter++;
			}
			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertEquals(1, counter);
			}
			var task:Task = new Task();
			task.and(MockOperation, "test1", 5000, false, command1).and(MockOperation, "test2", 1000, false, command2);
			task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			task.execute();
		}

		protected function onTaskComplete(event:TaskEvent):void {
			Assert.assertEquals(1, _counter);
		}

		[Test]
		public function testAndAsyncNotAsyncMixed():void {
			var c:ICommand = ICommand(mockRepository.createStrict(ICommand));
			Expect.call(c.execute()).returnValue(null);
			mockRepository.replayAll();

			var task:Task = new Task();
			task.and(new MockAsyncCommand(false, 1, incCounter)).and(c);
			task.addEventListener(TaskEvent.TASK_COMPLETE, onTaskComplete);
			task.execute();
			mockRepository.verifyAll();
		}

		[Test]
		public function testNext():void {
			var c:ICommand = ICommand(mockRepository.createStrict(ICommand));
			Expect.call(c.execute()).returnValue(null);
			mockRepository.replayAll();

			var task:Task = new Task();
			task.next(c);
			task.execute();

			mockRepository.verifyAll();
		}

		[Test(async, timeout = 500)]
		public function testNextAsync():void {
			var task:Task = new Task();
			task.next(new MockAsyncCommand(false, 1, incCounter));
			task.addEventListener(TaskEvent.TASK_COMPLETE, onTaskComplete);
			task.execute();
		}

		[Test(async, timeout = 6000)]
		public function testNextMultipleAsync():void {
			var counter:uint = 0;
			var command1:Function = function():void {
				Assert.assertEquals(0, counter);
				counter++;
			}
			var command2:Function = function():void {
				Assert.assertEquals(1, counter);
			}
			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertEquals(1, counter);
			}
			var task:Task = new Task();
			task.next(MockOperation, "test1", 5000, false, command1).next(MockOperation, "test2", 1000, false, command2);
			task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			task.execute();
		}

		[Test]
		public function testForLoopWithCountProvider():void {
			var count:ICountProvider = ICountProvider(mockRepository.createStrict(ICountProvider));
			var command:ICommand = ICommand(mockRepository.createStrict(ICommand));

			Expect.call(count.getCount()).returnValue(10);
			Expect.call(command.execute()).repeat.times(10, 10).returnValue(null);

			mockRepository.replayAll();

			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertTrue(true);
			}

			var task:Task = new Task();
			task //
				.for_(0, count) //
				.and(command) //
				.end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			task.execute();

			mockRepository.verifyAll();
		}

		[Test]
		public function testForLoopWithFixedCount():void {
			var command:ICommand = ICommand(mockRepository.createStrict(ICommand));

			Expect.call(command.execute()).repeat.times(10, 10).returnValue(null);

			mockRepository.replayAll();

			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertTrue(true);
			}

			var task:Task = new Task();
			task.for_(10) //
				.and(command) //
				.end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			task.execute();

			mockRepository.verifyAll();
		}

		[Test(async, timeout = 2000)]
		public function testForLoopWithAsyncCommand():void {

			var command1:Function = function():void {
				_counter++;
			}

			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertEquals(10, _counter);
			}

			var task:Task = new Task();
			task.for_(10) //
				.next(MockOperation, "test1", 100, false, command1) //
				.end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			task.execute();
		}

		[Test]
		public function testWhileLoop():void {
			var returnResult:Function = function():Boolean {
				return (_counter++ != 10);
			}
			var condition:IConditionProvider = new FunctionConditionProvider(returnResult);
			var command:ICommand = ICommand(mockRepository.createStrict(ICommand));

			Expect.call(command.execute()).repeat.times(10, 10).returnValue(null);

			mockRepository.replayAll();

			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertTrue(true);
			}

			var task:Task = new Task();
			task.while_(condition) //
				.and(command) //
				.end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			task.execute();

			mockRepository.verifyAll();
		}

		[Test(async, timeout = 2000)]
		public function testWhileLoopWithAsync():void {
			var returnResult:Function = function():Boolean {
				return (_counter != 10);
			}
			var condition:IConditionProvider = new FunctionConditionProvider(returnResult);

			var handleComplete:Function = function(event:TaskEvent):void {
				Assert.assertEquals(10, _counter);
			}

			var command1:Function = function():void {
				_counter++;
			}

			var task:Task = new Task();
			task.while_(condition) //
				.next(MockOperation, "test1", 100, false, command1) //
				.end();
			task.addEventListener(TaskEvent.TASK_COMPLETE, handleComplete);
			task.execute();

		}

	}
}
