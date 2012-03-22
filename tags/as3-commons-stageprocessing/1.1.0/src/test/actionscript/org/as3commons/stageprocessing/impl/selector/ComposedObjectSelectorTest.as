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
package org.as3commons.stageprocessing.impl.selector {
	import asmock.framework.Expect;
	import asmock.integration.flexunit.IncludeMocksRule;

	import flexunit.framework.Assert;

	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.test.AbstractTestWithMockRepository;


	public class ComposedObjectSelectorTest extends AbstractTestWithMockRepository {

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([IObjectSelector]);

		public function ComposedObjectSelectorTest() {
			super();
		}

		[Test]
		public function testApproveWithAllApprovingSelectors():void {
			var selector1:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));
			var selector2:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));
			Expect.call(selector1.approve(null)).ignoreArguments().returnValue(true);
			Expect.call(selector2.approve(null)).ignoreArguments().returnValue(true);
			mockRepository.replayAll();

			var selectors:Vector.<IObjectSelector> = new Vector.<IObjectSelector>();
			selectors[selectors.length] = selector1;
			selectors[selectors.length] = selector2;
			var cs:ComposedObjectSelector = new ComposedObjectSelector(selectors);
			var result:Boolean = cs.approve({});
			mockRepository.verifyAll();
			Assert.assertTrue(result);
		}

		[Test]
		public function testApproveWithOneApprovingSelectors():void {
			var selector1:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));
			var selector2:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));
			Expect.call(selector1.approve(null)).ignoreArguments().returnValue(false);
			Expect.call(selector2.approve(null)).ignoreArguments().returnValue(true);
			mockRepository.replayAll();

			var selectors:Vector.<IObjectSelector> = new Vector.<IObjectSelector>();
			selectors[selectors.length] = selector1;
			selectors[selectors.length] = selector2;
			var cs:ComposedObjectSelector = new ComposedObjectSelector(selectors, false);
			var result:Boolean = cs.approve({});
			mockRepository.verifyAll();
			Assert.assertTrue(result);
		}

		[Test]
		public function testApproveWithOneApprovingSelectorsButUnanimousRequired():void {
			var selector1:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));
			var selector2:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));
			Expect.call(selector1.approve(null)).ignoreArguments().returnValue(true);
			Expect.call(selector2.approve(null)).ignoreArguments().returnValue(false);
			mockRepository.replayAll();

			var selectors:Vector.<IObjectSelector> = new Vector.<IObjectSelector>();
			selectors[selectors.length] = selector1;
			selectors[selectors.length] = selector2;
			var cs:ComposedObjectSelector = new ComposedObjectSelector(selectors);
			var result:Boolean = cs.approve({});
			mockRepository.verifyAll();
			Assert.assertFalse(result);
		}

	}
}
