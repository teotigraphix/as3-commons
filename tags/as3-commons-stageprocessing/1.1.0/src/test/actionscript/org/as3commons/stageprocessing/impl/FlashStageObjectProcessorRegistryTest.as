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
	import asmock.framework.Expect;
	import asmock.framework.SetupResult;
	import asmock.integration.flexunit.IncludeMocksRule;

	import flash.display.DisplayObject;
	import flash.display.Stage;

	import flexunit.framework.Assert;

	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.as3commons.stageprocessing.mock.MockOrderedStageObjectProcessor;
	import org.as3commons.stageprocessing.test.AbstractTestWithMockRepository;

	public class FlashStageObjectProcessorRegistryTest extends AbstractTestWithMockRepository {

		public function FlashStageObjectProcessorRegistryTest()
		{
		}

		[Rule]
		public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ //
			IStageObjectProcessor, //
			IObjectSelector //
			]);

		private var _registry:FlashStageObjectProcessorRegistry;
		private var _stage:Stage;

		[Before]
		public function setUp():void {
			_registry = new FlashStageObjectProcessorRegistry();
			_stage = FlexGlobals.topLevelApplication.stage as Stage;
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
			Assert.assertStrictlyEquals(processor, _registry.getStageProcessorsByRootView(_stage)[0]);
		}

		[Test]
		public function testRegisterOrderedProcessors():void {
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			mockRepository.replayAll();

			var mock1:MockOrderedStageObjectProcessor = new MockOrderedStageObjectProcessor();
			mock1.order = 10;
			var mock2:MockOrderedStageObjectProcessor = new MockOrderedStageObjectProcessor();
			mock2.order = 2;

			_registry.registerStageObjectProcessor(mock1, selector);
			_registry.registerStageObjectProcessor(mock2, selector);

			var procs:Vector.<IStageObjectProcessor> = _registry.getProcessorVector(_stage, selector);
			Assert.assertEquals(2, procs.length);
			Assert.assertStrictlyEquals(mock2, procs[0]);
			Assert.assertStrictlyEquals(mock1, procs[1]);
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

		[Test]
		public function testGetStageProcessorsByType():void {
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStrict(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			mockRepository.replayAll();

			_registry.registerStageObjectProcessor(processor, selector);
			var result:Vector.<IStageObjectProcessor> = _registry.getStageObjectProcessorsByType(IStageObjectProcessor);
			Assert.assertEquals(1, result.length);
			Assert.assertStrictlyEquals(processor, result[0]);
		}

		[Test]
		public function testGetAllObjectSelectors():void {
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStrict(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			var processor2:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStrict(IStageObjectProcessor));
			var selector2:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			mockRepository.replayAll();

			_registry.registerStageObjectProcessor(processor, selector);
			var result:Vector.<IObjectSelector> = _registry.getAllObjectSelectors();
			Assert.assertEquals(1, result.length);
			Assert.assertStrictlyEquals(selector, result[0]);

			_registry.registerStageObjectProcessor(processor2, selector2);
			result = _registry.getAllObjectSelectors();
			Assert.assertEquals(2, result.length);
			Assert.assertTrue(result.indexOf(selector2) > -1);
		}

		[Test]
		public function testAllRootViews():void {
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStrict(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			mockRepository.replayAll();
			var rootView:UIComponent = new UIComponent();

			_registry.registerStageObjectProcessor(processor, selector, rootView);
			var result:Vector.<DisplayObject> = _registry.getAllRootViews();
			Assert.assertEquals(1, result.length);
			Assert.assertStrictlyEquals(rootView, result[0]);
		}

		[Test]
		public function testGetObjectSelectorsForStageProcessor():void {
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStrict(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStrict(IObjectSelector));
			mockRepository.replayAll();

			_registry.registerStageObjectProcessor(processor, selector);
			var result:Vector.<IObjectSelector> = _registry.getObjectSelectorsForStageProcessor(processor);
			Assert.assertEquals(1, result.length);
			Assert.assertStrictlyEquals(selector, result[0]);
		}

		[Test]
		public function testProcessorInvocationForAddedStageObjectWithoutRootView():void {
			var childView:UIComponent = new UIComponent();
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStub(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));
			SetupResult.forCall(selector.approve(childView)).ignoreArguments().returnValue(true);
			SetupResult.forCall(selector.approve(_stage.root)).ignoreArguments().returnValue(false);
			Expect.call(processor.process(null)).ignoreArguments().returnValue(null);
			mockRepository.replayAll();

			_registry.registerStageObjectProcessor(processor, selector);
			_registry.initialize();
			_stage.addChild(childView);

			mockRepository.verifyAll();
		}

		[Test]
		public function testProcessorInvocationForAddedStageObjectWithRootView():void {
			var rootView:UIComponent = new UIComponent();
			var childView:UIComponent = new UIComponent();
			var childView2:UIComponent = new UIComponent();
			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStub(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));

			SetupResult.forCall(selector.approve(childView)).ignoreArguments().returnValue(true);
			SetupResult.forCall(selector.approve(_stage.root)).ignoreArguments().returnValue(false);
			Expect.call(processor.process(childView)).returnValue(childView);
			Expect.notCalled(processor.process(childView2));
			mockRepository.replayAll();

			_stage.addChild(rootView);
			_registry.registerStageObjectProcessor(processor, selector, rootView);
			_registry.initialize();
			rootView.addChild(childView);
			_stage.addChild(childView2);

			mockRepository.verifyAll();
		}

		[Test]
		public function testProcessorInvocationForAddedNestedStageObjectWithRootView():void {
			var rootView:UIComponent = new UIComponent();
			var childView1:UIComponent = new UIComponent();
			var childView2:UIComponent = new UIComponent();

			childView1.addChild(childView2);

			var processor:IStageObjectProcessor = IStageObjectProcessor(mockRepository.createStub(IStageObjectProcessor));
			var selector:IObjectSelector = IObjectSelector(mockRepository.createStub(IObjectSelector));

			SetupResult.forCall(selector.approve(childView2)).ignoreArguments().returnValue(true);
			SetupResult.forCall(selector.approve(_stage.root)).ignoreArguments().returnValue(false);
			SetupResult.forCall(selector.approve(childView1)).ignoreArguments().returnValue(false);
			Expect.call(processor.process(childView2)).returnValue(childView2);
			Expect.notCalled(processor.process(childView1));
			mockRepository.replayAll();

			_stage.addChild(rootView);
			_registry.registerStageObjectProcessor(processor, selector, rootView);
			_registry.initialize();
			rootView.addChild(childView1);

			mockRepository.verifyAll();
		}
	}
}
