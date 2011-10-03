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
	import mockolate.stub;
	import mockolate.verify;

	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.as3commons.metadata.test.AnnotatedClass;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.instanceOf;

	public class AS3ReflectMetadataProcessorRegistryTest {

		private var _registry:AS3ReflectMetadataProcessorRegistry;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var metadataProcessor:IMetadataProcessor;

		[Before]
		public function setUp():void {
			_registry = new AS3ReflectMetadataProcessorRegistry();
		}

		[Test]
		public function testProcessorProcessIsCalledForAppropriateInstance():void {
			var annotated:AnnotatedClass = new AnnotatedClass();
			var processor:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "testmetadata";
			stub(processor).getter("metadataNames").returns(names);
			mock(processor).method("process").args(annotated, "testmetadata", instanceOf(Type)).once();
			_registry.addProcessor(processor);
			_registry.process(annotated);
			verify(processor);
		}

		[Test]
		public function testProcessorProcessIsCalledAppropriateNumberOfTimes():void {
			var annotated:AnnotatedClass = new AnnotatedClass();
			var processor:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "testmethod";
			names[names.length] = "testmetadata";
			stub(processor).getter("metadataNames").returns(names);
			mock(processor).method("process").args(annotated, "testmethod", instanceOf(Method)).times(4);
			mock(processor).method("process").args(annotated, "testmetadata", instanceOf(Type)).once();
			_registry.addProcessor(processor);
			_registry.process(annotated);
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
			assertNotNull(result);
			assertEquals(1, result.length);
			assertStrictlyEquals(result[0], processor);
			verify(processor);
		}

	}
}
