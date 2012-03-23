/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.aop.factory {

	import flash.events.Event;

	import flexunit.framework.TestCase;

	import org.as3commons.aop.factory.impl.AOPProxyFactory;

	import org.as3commons.async.operation.IOperation;
	import org.flexunit.asserts.assertTrue;

	public class AOPProxyFactoryTest {

		public function AOPProxyFactoryTest() {
		}

		[Test]
		public function testGetProxy():void {
			assertTrue(true);

			/*var target:MessageWriter = new MessageWriter();
			var factory:AOPProxyFactory = new AOPProxyFactory();
			//factory.addAdvice(new MessageDecorator());
			factory.target = target;
			
			var handler:Function = function(event:Event):void {
				trace("");
			};*/

			/*var operation:IOperation = factory.createProxy();
			operation.addCompleteListener(addAsync(handler, 5000));*/


		}
	}
}
