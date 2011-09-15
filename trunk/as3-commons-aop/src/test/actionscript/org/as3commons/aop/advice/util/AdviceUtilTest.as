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
package org.as3commons.aop.advice.util {
	import org.as3commons.aop.advice.IAdvice;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	/**
	 * @author Christophe Herreman
	 */
	public class AdviceUtilTest {

		public function AdviceUtilTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests - getAdviceByType
		//
		// --------------------------------------------------------------------

		[Test]
		public function testGetAdviceByType_withEmptyVector():void {
			var advice:Vector.<IAdvice> = new Vector.<IAdvice>();
			var result:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IAdvice, advice);
			assertNotNull(result);
			assertEquals(0, result.length);
		}

		[Test]
		public function testGetAdviceByType_withSameTypes():void {
			var advice:Vector.<IAdvice> = new Vector.<IAdvice>();
			advice.push(new AdviceImpl());
			advice.push(new AdviceImpl());
			var result:Vector.<IAdvice> = AdviceUtil.getAdviceByType(AdviceImpl, advice);
			assertNotNull(result);
			assertEquals(2, result.length);
		}

		[Test]
		public function testGetAdviceByType_withMixedTypes():void {
			var advice:Vector.<IAdvice> = new Vector.<IAdvice>();
			advice.push(new AdviceImpl());
			advice.push(new AdviceImpl2());
			var result:Vector.<IAdvice> = AdviceUtil.getAdviceByType(AdviceImpl, advice);
			assertNotNull(result);
			assertEquals(1, result.length);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testGetAdviceByType_withNullClass():void {
			var advice:Vector.<IAdvice> = new Vector.<IAdvice>();
			AdviceUtil.getAdviceByType(null, advice);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testGetAdviceByType_withNullAdvice():void {
			AdviceUtil.getAdviceByType(IAdvice, null);
		}
	}
}

import org.as3commons.aop.advice.IAdvice;

class AdviceImpl implements IAdvice {}
class AdviceImpl2 implements IAdvice {}