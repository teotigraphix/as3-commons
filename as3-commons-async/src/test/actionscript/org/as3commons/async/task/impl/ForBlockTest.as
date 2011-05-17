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

	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.task.ICountProvider;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class ForBlockTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			ICountProvider, //
			ICommand]);

		public function ForBlockTest() {
			super();
		}

		[Test]
		public function testExecute():void {
			var count:ICountProvider = ICountProvider(mockRepository.createStrict(ICountProvider));
			var command:ICommand = ICommand(mockRepository.createStrict(ICommand));

			Expect.call(count.getCount()).returnValue(10);
			Expect.call(command.execute()).repeat.times(10, 10).returnValue(null);

			mockRepository.replayAll();

			var fb:ForBlock = new ForBlock(count);
			fb.and(command);
			fb.execute();

			mockRepository.verifyAll();
		}

		[Test]
		public function testExecuteWithBreak():void {
			var count:ICountProvider = ICountProvider(mockRepository.createStrict(ICountProvider));
			var command:ICommand = ICommand(mockRepository.createStub(ICommand));
			var command2:ICommand = ICommand(mockRepository.createStub(ICommand));

			Expect.call(count.getCount()).returnValue(10);
			Expect.call(command.execute()).ignoreArguments().repeat.times(1, 1).returnValue(null);
			Expect.notCalled(command2.execute()).ignoreArguments();

			mockRepository.replayAll();

			var fb:ForBlock = new ForBlock(count);
			ForBlock(fb.and(command)).break_().and(command2);
			fb.execute();

			mockRepository.verifyAll();
		}

		[Test]
		public function testExecuteWithContinue():void {
			var count:ICountProvider = ICountProvider(mockRepository.createStrict(ICountProvider));
			var command:ICommand = ICommand(mockRepository.createStub(ICommand));
			var command2:ICommand = ICommand(mockRepository.createStub(ICommand));

			Expect.call(count.getCount()).returnValue(10);
			Expect.call(command.execute()).ignoreArguments().repeat.times(10, 10).returnValue(null);
			Expect.notCalled(command2.execute()).ignoreArguments();

			mockRepository.replayAll();

			var fb:ForBlock = new ForBlock(count);
			fb.and(command).continue_().and(command2);
			fb.execute();

			mockRepository.verifyAll();
		}
	}
}
