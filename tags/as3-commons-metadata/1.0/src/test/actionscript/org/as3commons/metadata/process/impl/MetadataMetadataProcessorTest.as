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
package org.as3commons.metadata.process.impl {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
	import org.as3commons.metadata.test.AnonMetadataProcessorWithTwoArgumentsAndCustomProcessName;
	import org.hamcrest.core.anything;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class MetadataMetadataProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		[Mock]
		public var registry:IMetadataProcessorRegistry;

		/**
		 * Creates a new <code>MetadataMetadataProcessorTest</code> instance.
		 */
		public function MetadataMetadataProcessorTest() {
			super();
		}

		[Test]
		public function testProcess():void {
			registry = nice(IMetadataProcessorRegistry);
			var processor:MetadataMetadataProcessor = new MetadataMetadataProcessor(registry);
			mock(registry).method("addProcessor").args(anything()).once();
			var anonProcessor:AnonMetadataProcessorWithTwoArgumentsAndCustomProcessName = new AnonMetadataProcessorWithTwoArgumentsAndCustomProcessName();
			processor.process(anonProcessor, "MetadataProcessor");
			verify(registry);
		}

	}
}
