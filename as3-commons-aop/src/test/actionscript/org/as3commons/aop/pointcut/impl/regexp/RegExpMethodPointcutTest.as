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
package org.as3commons.aop.pointcut.impl.regexp {
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertFalse;
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
			assertMatch(method, "testMatchesMethod");
			assertMatch(method, ".*.testMatchesMethod");
			assertMatch(method, ".*.*");
			assertMatch(method, ".*");
			assertMatch(method, "org.as3commons.aop.pointcut.impl.regexp.RegExpMethodPointcutTest.testMatchesMethod");
			assertMatch(method, "org.as3commons.aop.pointcut.impl.regexp.*.testMatchesMethod");
			assertMatch(method, "org.as3commons.aop.pointcut.impl.regexp.*");

			assertNotMatch(method, "^com");
			assertNotMatch(method, "org.as3commons.aop.pointcut.impl.regexp::RegExpMethodPointcutTest.testMatchesMethod");
			assertNotMatch(null, "");
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function assertMatch(method:Method, pattern:String):void {
			var pointcut:RegExpMethodPointcut = new RegExpMethodPointcut();
			pointcut.pattern = pattern;
			assertTrue(pointcut.matches(method));
		}

		private function assertNotMatch(method:Method, pattern:String):void {
			var pointcut:RegExpMethodPointcut = new RegExpMethodPointcut();
			pointcut.pattern = pattern;
			assertFalse(pointcut.matches(method));
		}
	}
}
