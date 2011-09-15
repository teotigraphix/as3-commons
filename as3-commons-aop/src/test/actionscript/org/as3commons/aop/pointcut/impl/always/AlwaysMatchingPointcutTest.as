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
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertTrue;

	public class AlwaysMatchingPointcutTest {

		public function AlwaysMatchingPointcutTest() {
		}

		[Test]
		public function testMatchesConstructor():void {
			var p:AlwaysMatchingPointcut = new AlwaysMatchingPointcut();
			var constructor:Constructor = Type.forClass(AlwaysMatchingConstructorPointcutTest).constructor;
			assertTrue(p.matchesConstructor(constructor));
		}

		[Test]
		public function testMatchesAccessor():void {
			var p:AlwaysMatchingPointcut = new AlwaysMatchingPointcut();
			var accessor:Accessor = Type.forClass(AlwaysMatchingAccessorPointcutTest).accessors[0];
			assertTrue(p.matchesAccessor(accessor));
		}

		[Test]
		public function testMatchesMethod():void {
			var p:AlwaysMatchingPointcut = new AlwaysMatchingPointcut();
			var method:Method = Type.forClass(AlwaysMatchingMethodPointcutTest).getMethod("testMatchesMethod");
			assertTrue(p.matchesMethod(method));
		}
	}
}
