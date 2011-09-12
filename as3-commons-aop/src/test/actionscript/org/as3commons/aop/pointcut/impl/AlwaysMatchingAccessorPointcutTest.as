package org.as3commons.aop.pointcut.impl {
	import org.as3commons.aop.pointcut.IAccessorPointcut;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertTrue;

	public class AlwaysMatchingAccessorPointcutTest {

		public function AlwaysMatchingAccessorPointcutTest() {
		}
		
		[Test]
		public function testMatchesAccessor():void {
			var p:IAccessorPointcut = new AlwaysMatchingAccessorPointcut();
			var accessor:Accessor = Type.forClass(AlwaysMatchingAccessorPointcutTest).accessors[0];
			assertTrue(p.matchesAccessor(accessor));
		}
	}
}
