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
	import org.as3commons.async.task.IConditionProvider;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class IfElseBlockTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			IConditionProvider, //
			ICommand //
			]);

		public function IfElseBlockTest() {
			super();
		}

		[Test]
		public function testExecuteWithTrue():void {
			var condition:IConditionProvider = IConditionProvider(mockRepository.createStrict(IConditionProvider));
			var command:ICommand = ICommand(mockRepository.createStub(ICommand));
			var command2:ICommand = ICommand(mockRepository.createStub(ICommand));

			Expect.call(condition.getResult()).returnValue(true);
			Expect.call(command.execute()).ignoreArguments().returnValue(null);
			Expect.notCalled(command2.execute()).ignoreArguments();

			mockRepository.replayAll();

			var ifelse:IfElseBlock = new IfElseBlock(condition);
			ifelse.and(command).else_().and(command2);
			ifelse.execute();

			mockRepository.verifyAll();
		}

		[Test]
		public function testExecuteWithFalse():void {
			var condition:IConditionProvider = IConditionProvider(mockRepository.createStrict(IConditionProvider));
			var command:ICommand = ICommand(mockRepository.createStub(ICommand));
			var command2:ICommand = ICommand(mockRepository.createStub(ICommand));

			Expect.call(condition.getResult()).returnValue(false);
			Expect.notCalled(command.execute()).ignoreArguments();
			Expect.call(command2.execute()).ignoreArguments().returnValue(null);

			mockRepository.replayAll();

			var ifelse:IfElseBlock = new IfElseBlock(condition);
			ifelse.and(command).else_().and(command2);
			ifelse.execute();

			mockRepository.verifyAll();
		}

	}
}
