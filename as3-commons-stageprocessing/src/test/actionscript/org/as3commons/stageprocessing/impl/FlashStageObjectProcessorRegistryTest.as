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
package org.as3commons.stageprocessing.impl {
	import asmock.integration.flexunit.ASMockClassRunner;

	import flash.display.DisplayObject;
	import flash.display.Stage;

	import flexunit.framework.Assert;

	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.as3commons.stageprocessing.test.AbstractTestWithMockRepository;


	[Mock("org.as3commons.stageprocessing.IStageObjectProcessor")]
	[Mock("org.as3commons.stageprocessing.IObjectSelector")]
	[RunWith("asmock.integration.flexunit.ASMockClassRunner")]
	public class FlashStageObjectProcessorRegistryTest extends AbstractTestWithMockRepository {

		{
			IStageObjectProcessor;
			ASMockClassRunner;
			IObjectSelector;
		}

		private var _registry:FlashStageObjectProcessorRegistry;

		[Before]
		public function setUp():void {
			_registry = new FlashStageObjectProcessorRegistry();
			_registry.stage = FlexGlobals.topLevelApplication.stage as Stage;
		}

		[After]
		public function tearDown():void {
			_registry.clear();
			_registry = null;
		}

		[BeforeClass]
		public static function setUpBeforeClass():void {
		}

		[AfterClass]
		public static function tearDownAfterClass():void {
		}

		[Test]
		public function testRegisterProcessor():void {
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStrict(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			mockRepository.replayAll();

			_registry.registerStageObjectProcessor(processor, selector);
			Assert.assertEquals(1, _registry.getAllStageObjectProcessors().length);
			var sel:Vector.<IObjectSelector> = _registry.getObjectSelectorsForStageProcessor(processor);
			Assert.assertEquals(1, sel.length);
			Assert.assertStrictlyEquals(selector, sel[0]);
			Assert.assertStrictlyEquals(processor, _registry.getStageProcessorsByRootView(_registry.stage)[0]);
		}

		[Test]
		public function testRegisterProcessorWithRootView():void {
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStrict(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			mockRepository.replayAll();
			var rootView:UIComponent = new UIComponent();

			_registry.registerStageObjectProcessor(processor, selector, rootView);
			Assert.assertEquals(1, _registry.getAllStageObjectProcessors().length);
			var sel:Vector.<IObjectSelector> = _registry.getObjectSelectorsForStageProcessor(processor);
			Assert.assertEquals(1, sel.length);
			Assert.assertStrictlyEquals(selector, sel[0]);
			Assert.assertStrictlyEquals(processor, _registry.getStageProcessorsByRootView(rootView)[0]);
		}

	}
}