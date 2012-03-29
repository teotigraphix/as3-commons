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
package org.as3commons.metadata.registry.impl {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AbstractMetadataProcessorRegistryTest {

		private var _registry:AbstractMetadataProcessorRegistry;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var metadataProcessor:IMetadataProcessor;

		[Before]
		public function setUp():void {
			_registry = new AbstractMetadataProcessorRegistry();
		}

		/**
		 * Creates a new <code>AbstractMetadataProcessorRegistryTest</code> instance.
		 */
		public function AbstractMetadataProcessorRegistryTest() {
			super();
		}

		[Test]
		public function testAddProcessor():void {
			var processor:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "test";
			mock(processor).getter("metadataNames").returns(names).once();
			_registry.addProcessor(processor);
			var result:Vector.<IMetadataProcessor> = _registry.getProcessorsForMetadata("test");
			assertNotNull(result);
			assertEquals(1, result.length);
			assertStrictlyEquals(result[0], processor);
			verify(processor);
		}

		[Test]
		public function testAddProcessorTwice():void {
			var processor:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "test";
			mock(processor).getter("metadataNames").returns(names).twice();
			_registry.addProcessor(processor);
			_registry.addProcessor(processor);
			var result:Vector.<IMetadataProcessor> = _registry.getProcessorsForMetadata("test");
			assertNotNull(result);
			assertEquals(1, result.length);
			assertStrictlyEquals(result[0], processor);
			verify(processor);
		}

		[Test]
		public function testAddProcessorCaseInsensitive():void {
			var processor:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "test";
			mock(processor).getter("metadataNames").returns(names).once();
			_registry.addProcessor(processor);
			var result:Vector.<IMetadataProcessor> = _registry.getProcessorsForMetadata("TesT");
			assertNull(result);
			verify(processor);
		}

		[Test]
		public function testRemoveProcessor():void {
			var processor:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "test";
			mock(processor).getter("metadataNames").returns(names).twice();
			_registry.addProcessor(processor);
			_registry.removeProcessor(processor);
			var result:Vector.<IMetadataProcessor> = _registry.getProcessorsForMetadata("test");
			assertNull(result);
			verify(processor);
		}

		[Test]
		public function testAddTwoAndRemoveOneProcessor():void {
			var processor1:IMetadataProcessor = nice(IMetadataProcessor);
			var processor2:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "test";
			mock(processor1).getter("metadataNames").returns(names).twice();
			mock(processor2).getter("metadataNames").returns(names).once();
			_registry.addProcessor(processor1);
			_registry.addProcessor(processor2);
			_registry.removeProcessor(processor1);
			var result:Vector.<IMetadataProcessor> = _registry.getProcessorsForMetadata("test");
			assertNotNull(result);
			assertEquals(1, result.length);
			assertStrictlyEquals(result[0], processor2);
			verify(processor1);
			verify(processor2);
		}
	}
}
