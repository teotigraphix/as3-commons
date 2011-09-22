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
package org.as3commons.aop.advisor.impl {
	import org.as3commons.aop.advisor.IPointcutAdvisor;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class PointcutAdvisorTest {

		public function PointcutAdvisorTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests - new
		//
		// --------------------------------------------------------------------

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNew_withNullArguments():void {
			new PointcutAdvisor(null, null);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNew_withNullPointcut():void {
			new PointcutAdvisor(null, new AdviceImpl());
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNew_withNullAdvice():void {
			new PointcutAdvisor(new PointcutImpl(), null);
		}

		// --------------------------------------------------------------------
		//
		// Tests - pointcut
		//
		// --------------------------------------------------------------------

		[Test]
		public function testPointcutGetter():void {
			var pointcut:PointcutImpl = new PointcutImpl();
			var advisor:IPointcutAdvisor = new PointcutAdvisor(pointcut, new AdviceImpl());
			assertNotNull(advisor.pointcut);
			assertEquals(pointcut, advisor.pointcut);
		}

		// --------------------------------------------------------------------
		//
		// Tests - advice
		//
		// --------------------------------------------------------------------

		[Test]
		public function testAdviceGetter():void {
			var pointcut:PointcutImpl = new PointcutImpl();
			var advice:AdviceImpl = new AdviceImpl();
			var advisor:IPointcutAdvisor = new PointcutAdvisor(pointcut, advice);
			assertNotNull(advisor.advice);
			assertEquals(advice, advisor.advice);
		}

	}
}

import org.as3commons.aop.advice.IAdvice;
import org.as3commons.aop.pointcut.IPointcut;

class PointcutImpl implements IPointcut {

	public function matches(criterion:* = null):Boolean {
		return false;
	}
}

class AdviceImpl implements IAdvice {

}
