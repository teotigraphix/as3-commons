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

	import flexunit.framework.Assert;

	import org.as3commons.async.operation.impl.AbstractOperation;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class OperationHandlerTest extends AbstractTestWithMockRepository {

		private var _operationHandler:OperationHandler;

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			AbstractOperation //
			]);

		public function OperationHandlerTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_operationHandler = new OperationHandler();
		}

		[Test(async, timeout=1000)]
		public function testHandleOperationWithResultMethod():void {
			var o:AbstractOperation = AbstractOperation(mockRepository.createDynamic(AbstractOperation));
			mockRepository.stubEvents(o);
			mockRepository.stubAllProperties(o);
			mockRepository.replayAll();

			var result:Object = {};
			o.result = result;
			var resultMethod:Function = function(res:Object):void {
				Assert.assertStrictlyEquals(res, result);
			};
			_operationHandler.handleOperation(o, resultMethod);
			o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
		}

		[Test(async, timeout=1000)]
		public function testHandleOperationWithObjectProperty():void {
			var o:AbstractOperation = AbstractOperation(mockRepository.createDynamic(AbstractOperation));
			mockRepository.stubEvents(o);
			mockRepository.stubAllProperties(o);
			mockRepository.replayAll();

			var resultObject:Object = {};
			resultObject.testProperty = {};
			var result:Object = {};
			o.result = result;
			_operationHandler.handleOperation(o, null, resultObject, "testProperty");
			o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
			Assert.assertStrictlyEquals(result, resultObject.testProperty);
		}

		[Test(async, timeout=1000)]
		public function testHandleOperationWithObjectPropertyAndResultMethod():void {
			var o:AbstractOperation = AbstractOperation(mockRepository.createDynamic(AbstractOperation));
			mockRepository.stubEvents(o);
			mockRepository.stubAllProperties(o);
			mockRepository.replayAll();

			var resultObject:Object = {};
			var resultMethodObject:Object = {};
			resultObject.testProperty = {};
			var result:Object = {};
			o.result = result;
			var resultMethod:Function = function(res:Object):Object {
				Assert.assertStrictlyEquals(res, result);
				return resultMethodObject;
			}
			_operationHandler.handleOperation(o, resultMethod, resultObject, "testProperty");
			o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
			Assert.assertStrictlyEquals(resultMethodObject, resultObject.testProperty);
		}

		[Test(async, timeout=1000)]
		public function testHandleOperationWithNothing():void {
			var o:AbstractOperation = AbstractOperation(mockRepository.createDynamic(AbstractOperation));
			mockRepository.stubEvents(o);
			mockRepository.stubAllProperties(o);
			mockRepository.replayAll();

			_operationHandler.handleOperation(o);
			o.dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, o));
		}
	}
}
