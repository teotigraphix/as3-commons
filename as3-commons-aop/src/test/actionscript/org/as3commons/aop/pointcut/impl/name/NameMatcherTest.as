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
package org.as3commons.aop.pointcut.impl.name {

	import org.as3commons.lang.ClassUtils;
	import org.flexunit.asserts.assertEquals;

	/**
	 * @author Christophe Herreman
	 * Note: based on Spring Java code by Juergen Hoeller & Johan Gorter
	 */
	public class NameMatcherTest {

		public function NameMatcherTest() {
		}

		[Test]
		public function testSuperClass():void {
			// Assert that the superclass for NameMatcher is NameRegistry
			// in which case, we only test the "match" method.
			// If the implementation ever changes, this needs to be adapted
			// and tests need to be provided.
			assertEquals(NameRegistry, ClassUtils.getSuperClass(NameMatcher));
		}

		[Test]
		public function testTrivial():void {
			doTest("*", "123", true);
			doTest("123", "123", true);
		}

		[Test]
		public function testStartsWith():void {
			doTest("get*", "getMe", true);
			doTest("get*", "setMe", false);
		}

		[Test]
		public function testEndsWith():void {
			doTest("*Test", "getMeTest", true);
			doTest("*Test", "setMe", false);
		}

		[Test]
		public function testBetween():void {
			doTest("*stuff*", "getMeTest", false);
			doTest("*stuff*", "getstuffTest", true);
			doTest("*stuff*", "stuffTest", true);
			doTest("*stuff*", "getstuff", true);
			doTest("*stuff*", "stuff", true);
		}

		[Test]
		public function testStartsEnds():void {
			doTest("on*Event", "onMyEvent", true);
			doTest("on*Event", "onEvent", true);
			doTest("3*3", "3", false);
			doTest("3*3", "33", true);
		}

		[Test]
		public function testStartsEndsBetween():void {
			doTest("12*45*78", "12345678", true);
			doTest("12*45*78", "123456789", false);
			doTest("12*45*78", "012345678", false);
			doTest("12*45*78", "124578", true);
			doTest("12*45*78", "1245457878", true);
			doTest("3*3*3", "33", false);
			doTest("3*3*3", "333", true);
		}

		[Test]
		public function testRidiculous():void {
			doTest("*1*2*3*", "0011002001010030020201030", true);
			doTest("1*2*3*4", "10300204", false);
			doTest("1*2*3*3", "10300203", false);
			doTest("*1*2*3*", "123", true);
			doTest("*1*2*3*", "132", false);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function doTest(pattern:String, name:String, shouldMatch:Boolean):void {
			var nameMatcher:NameMatcher = new NameMatcher(pattern);
			assertEquals(shouldMatch, nameMatcher.match(name));
		}
	}
}
