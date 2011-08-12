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

	import org.as3commons.async.command.impl.GenericOperationCommand;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.OperationEvent;
	import org.as3commons.async.operation.impl.MockOperation;
	import org.as3commons.async.test.AbstractTestWithMockRepository;

	public class GenericOperationCommandTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			IOperation //
			]);

		public function GenericOperationCommandTest() {
			super();
		}

		[Test]
		public function testConstructor():void {
			var o:IOperation = IOperation(mockRepository.createStrict(IOperation));
			var clazz:Class = Class(Object(o).constructor);
			var gc:GenericOperationCommand = new GenericOperationCommand(clazz, "test1", 1, null);
			Assert.assertStrictlyEquals(clazz, gc.operationClass);
			Assert.assertEquals(3, gc.constructorArguments.length);
			Assert.assertEquals("test1", gc.constructorArguments[0]);
			Assert.assertEquals(1, gc.constructorArguments[1]);
			Assert.assertEquals(null, gc.constructorArguments[2]);
		}

		[Test(async, timeout=2000)]
		public function testExecute():void {

			var result:Object = {};
			var completeListener:Function = function(event:OperationEvent):void {
				Assert.assertStrictlyEquals(event.result, result);
			};
			var gc:GenericOperationCommand = new GenericOperationCommand(MockOperation, result);
			gc.addCompleteListener(completeListener);
			gc.execute();

		}
	}
}
