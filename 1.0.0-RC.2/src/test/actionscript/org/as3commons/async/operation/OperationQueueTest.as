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
	import asmock.integration.flexunit.IncludeMocksRule;

	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.async.operation.impl.AbstractOperation;
	import org.as3commons.async.operation.impl.OperationQueue;
	import org.as3commons.async.test.AbstractTestWithMockRepository;
	import org.flexunit.asserts.assertStrictlyEquals;

	public class OperationQueueTest extends AbstractTestWithMockRepository {

		private var _queue:OperationQueue;

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			AbstractOperation //
			]);

		public function OperationQueueTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_queue = new OperationQueue();
		}

		[Test(async, timeout=1000)]
		public function testQueue():void {
			var o1:AbstractOperation = AbstractOperation(mockRepository.createDynamic(AbstractOperation));
			var o2:AbstractOperation = AbstractOperation(mockRepository.createDynamic(AbstractOperation));

			mockRepository.stubEvents(o1);
			mockRepository.stubAllProperties(o1);
			mockRepository.stubEvents(o2);
			mockRepository.stubAllProperties(o2);
			mockRepository.replayAll();

			_queue.addOperation(o1);
			_queue.addOperation(o2);

			var handleComplete:Function = function(event:OperationEvent):void {
				assertStrictlyEquals(_queue, event.target);
			}
			_queue.addEventListener(OperationEvent.COMPLETE, handleComplete);
			o1.dispatchCompleteEvent();
			o2.dispatchCompleteEvent();
		}

	}
}
