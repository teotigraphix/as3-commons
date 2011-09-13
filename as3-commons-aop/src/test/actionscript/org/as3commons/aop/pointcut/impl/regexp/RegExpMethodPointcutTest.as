package org.as3commons.aop.pointcut.impl.regexp {
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertTrue;

	public class RegExpMethodPointcutTest {
		public function RegExpMethodPointcutTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		[Test]
		public function testMatchesMethod():void {
			var method:Method = Type.forClass(RegExpMethodPointcutTest).getMethod("testMatchesMethod");
			assertMatch(method, ".*.testMatchesMethod");
			assertMatch(method, ".*.*");
			assertMatch(method, ".*");
			assertMatch(method, "org.as3commons.aop.pointcut.impl.regexp.RegExpMethodPointcutTest.testMatchesMethod");
			assertMatch(method, "org.as3commons.aop.pointcut.impl.regexp.*.testMatchesMethod");
			assertMatch(method, "org.as3commons.aop.pointcut.impl.regexp.*");
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function assertMatch(method:Method, pattern:String):void {
			var pointcut:RegExpMethodPointcut = new RegExpMethodPointcut();
			pointcut.pattern = pattern;
			assertTrue(pointcut.matchesMethod(method));
		}
	}
}
