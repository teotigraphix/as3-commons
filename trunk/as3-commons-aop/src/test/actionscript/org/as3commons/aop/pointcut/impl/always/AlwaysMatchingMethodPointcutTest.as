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
package org.as3commons.aop.pointcut.impl.always {
	import org.as3commons.aop.pointcut.IMethodPointcut;
	import org.as3commons.aop.pointcut.impl.always.AlwaysMatchingMethodPointcut;
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
