package org.as3commons.aop.pointcut.impl {
	import org.as3commons.aop.pointcut.IMethodPointcut;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertTrue;

	public class AlwaysMatchingMethodPointcutTest {

		public function AlwaysMatchingMethodPointcutTest() {
		}
		
		[Test]
		public function testMatchesMethod():void {
			var p:IMethodPointcut = new AlwaysMatchingMethodPointcut();
			var method:Method = Type.forClass(AlwaysMatchingMethodPointcutTest).getMethod("testMatchesMethod");
			assertTrue(p.matchesMethod(method));
		}
	}
}
