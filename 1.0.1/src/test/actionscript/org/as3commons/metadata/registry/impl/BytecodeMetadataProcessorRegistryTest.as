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

	import mx.core.FlexGlobals;

	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.as3commons.metadata.test.AnnotatedClass;
	import org.as3commons.reflect.Type;
	import org.hamcrest.object.instanceOf;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class BytecodeMetadataProcessorRegistryTest {

		private var _registry:BytecodeMetadataProcessorRegistry;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var metadataProcessor:IMetadataProcessor;

		/**
		 * Creates a new <code>BytecodeMetadataProcessorRegistryTest</code> instance.
		 */
		public function BytecodeMetadataProcessorRegistryTest() {
			super();
			ByteCodeType.metaDataLookupFromLoader(FlexGlobals.topLevelApplication.loaderInfo);
		}

		[Before]
		public function setUp():void {
			_registry = new BytecodeMetadataProcessorRegistry();
		}

		[Test]
		public function testExecute():void {
			var processor:IMetadataProcessor = nice(IMetadataProcessor);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "testmetadata";
			stub(processor).getter("metadataNames").returns(names);
			mock(processor).method("process").args(AnnotatedClass, "testmetadata", instanceOf(Array)).once();
			_registry.addProcessor(processor);
			_registry.execute();
			verify(processor);
		}
	}
}
