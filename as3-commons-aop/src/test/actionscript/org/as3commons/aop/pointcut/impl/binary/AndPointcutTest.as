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
package org.as3commons.aop.pointcut.impl.binary {
	import org.as3commons.aop.pointcut.IPointcut;
	import org.as3commons.aop.pointcut.impl.AlwaysMatchingPointcut;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class AndPointcutTest {

		public function AndPointcutTest() {
		}

		[Test]
		public function testMatches_leftAndRightMatches():void {
			var left:IPointcut = new AlwaysMatchingPointcut();
			var right:IPointcut = new AlwaysMatchingPointcut();
			var andPointcut:AndPointcut = new AndPointcut(left, right);
			assertTrue(andPointcut.matches());
		}

		[Test]
		public function testMatches_leftMatches():void {
			var left:IPointcut = new AlwaysMatchingPointcut();
			var right:IPointcut = new NotMatchingPointcut();
			var andPointcut:AndPointcut = new AndPointcut(left, right);
			assertFalse(andPointcut.matches());
		}

		[Test]
		public function testMatches_rightMatches():void {
			var left:IPointcut = new NotMatchingPointcut();
			var right:IPointcut = new AlwaysMatchingPointcut();
			var andPointcut:AndPointcut = new AndPointcut(left, right);
			assertFalse(andPointcut.matches());
		}

		[Test]
		public function testMatches_noneMatches():void {
			var left:IPointcut = new NotMatchingPointcut();
			var right:IPointcut = new NotMatchingPointcut();
			var andPointcut:AndPointcut = new AndPointcut(left, right);
			assertFalse(andPointcut.matches());
		}
	}
}

import org.as3commons.aop.pointcut.IPointcut;

class NotMatchingPointcut implements IPointcut {

	public function NotMatchingPointcut() {
	}

	public function matches(criterion:* = null):Boolean {
		return false;
	}
}