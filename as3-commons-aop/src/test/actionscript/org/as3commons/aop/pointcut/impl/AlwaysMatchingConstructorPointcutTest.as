package org.as3commons.aop.pointcut.impl {
	import org.as3commons.aop.pointcut.IConstructorPointcut;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertTrue;

	public class AlwaysMatchingConstructorPointcutTest {

		public function AlwaysMatchingConstructorPointcutTest() {
		}
		
		[Test]
		public function testMatchesConstructor():void {
			var p:IConstructorPointcut = new AlwaysMatchingConstructorPointcut();
			var constructor:Constructor = Type.forClass(AlwaysMatchingConstructorPointcutTest).constructor;
			assertTrue(p.matchesConstructor(constructor));
		}
	}
}
