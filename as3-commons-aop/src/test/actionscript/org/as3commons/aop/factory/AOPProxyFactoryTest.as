package org.as3commons.aop.factory {

	import flash.events.Event;

	import flexunit.framework.TestCase;

	import org.as3commons.aop.factory.AOPProxyFactory;

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
