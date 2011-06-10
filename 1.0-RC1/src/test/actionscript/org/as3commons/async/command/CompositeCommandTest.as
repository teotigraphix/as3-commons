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
package org.as3commons.async.command {
	import asmock.integration.flexunit.IncludeMocksRule;

	import flexunit.framework.Assert;

	import org.as3commons.async.command.event.CompositeCommandEvent;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.MockOperation;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class CompositeCommandTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			ICommand, //
			IOperation //
			]);

		private var _compositeCommand:CompositeCommand;

		public function CompositeCommandTest() {
			super();
		}

		[Test]
		public function testAddCommandAndOperation():void {
			var c:ICommand = ICommand(mockRepository.createStub(ICommand));
			var o:IOperation = IOperation(mockRepository.createStub(IOperation));
			mockRepository.replayAll();
			var cc:CompositeCommand = new CompositeCommand();
			Assert.assertEquals(0, cc.numCommands);
			cc.addCommand(c);
			Assert.assertEquals(1, cc.numCommands);
			cc.addOperation(Class(Object(o).constructor));
			Assert.assertEquals(2, cc.numCommands);
		}

		[Test(async, timeout = "4000")]
		public function testSequenceExecute():void {
			var cc:CompositeCommand = new CompositeCommand(CompositeCommandKind.SEQUENCE);
			var counter:uint = 0;
			var command1:Function = function():void {
				Assert.assertEquals(0, counter);
				counter++;
			}
			var command2:Function = function():void {
				Assert.assertEquals(1, counter);
			}
			cc.addOperation(MockOperation, "test1", 2000, false, command1).addOperation(MockOperation, "test2", 1000, false, command2);
			cc.execute();
		}

		[Test(async, timeout = "6000")]
		public function testParallelExecute():void {
			var cc:CompositeCommand = new CompositeCommand(CompositeCommandKind.PARALLEL);
			var counter:uint = 0;
			var command1:Function = function():void {
				Assert.assertEquals(1, counter);
			}
			var command2:Function = function():void {
				Assert.assertEquals(0, counter);
				counter++;
			}
			cc.addOperation(MockOperation, "test1", 5000, false, command1, false).addOperation(MockOperation, "test2", 1000, false, command2, false);
			cc.execute();
		}

		[Test(async, timeout = "4000")]
		public function testFailOnfaultIsTrue():void {
			var cc:CompositeCommand = new CompositeCommand(CompositeCommandKind.SEQUENCE);
			var counter:uint = 0;
			var command1:Function = function():void {
				Assert.assertTrue(true);
			}
			var command2:Function = function():void {
				Assert.assertTrue(false);
			}
			cc.addOperation(MockOperation, "test1", 2000, true, command1, false).addOperation(MockOperation, "test2", 1000, false, command2, false);
			cc.failOnFault = true;
			cc.execute();
		}

		[Test(async, timeout = "4000")]
		public function testFailOnfaultIsFalse():void {
			var cc:CompositeCommand = new CompositeCommand(CompositeCommandKind.SEQUENCE);
			var counter:uint = 0;
			var command1:Function = function():void {
				Assert.assertEquals(0, counter);
				counter++;
			}
			var command2:Function = function():void {
				Assert.assertEquals(1, counter);
			}
			cc.addOperation(MockOperation, "test1", 2000, true, command1, false).addOperation(MockOperation, "test2", 1000, false, command2, false);
			cc.failOnFault = false;
			cc.execute();
		}

	}
}
