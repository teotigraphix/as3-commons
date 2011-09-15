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
	import org.as3commons.aop.pointcut.IConstructorPointcut;
	import org.as3commons.aop.pointcut.impl.always.AlwaysMatchingConstructorPointcut;
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
