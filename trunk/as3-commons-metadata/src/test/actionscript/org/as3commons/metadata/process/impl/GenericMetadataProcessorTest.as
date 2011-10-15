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
	import org.as3commons.metadata.test.AnonMetadataProcessorWithAllArguments;
	import org.as3commons.metadata.test.AnonMetadataProcessorWithArgumentsInDifferentOrderAndDifferentProcessName;
	import org.as3commons.metadata.test.AnonMetadataProcessorWithOneArgument;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class GenericMetadataProcessorTest {

		private var _processor:GenericMetadataProcessor;

		/**
		 * Creates a new <code>GenericMetadataProcessorTest</code> instance.
		 */
		public function GenericMetadataProcessorTest() {
			super();
		}

		[Test]
		public function testCreateWithObjectWithAllArguments():void {
			var anonProcessor:AnonMetadataProcessorWithAllArguments = new AnonMetadataProcessorWithAllArguments();
			_processor = new GenericMetadataProcessor(anonProcessor, "process");
			var target:Object = {};
			_processor.process(target, "test", "testInfo");
			assertEquals(3, anonProcessor.processArgsValues.length);
			assertStrictlyEquals(target, anonProcessor.processArgsValues[0]);
			assertEquals("test", anonProcessor.processArgsValues[1]);
			assertEquals("testInfo", anonProcessor.processArgsValues[2]);
		}

		[Test]
		public function testCreateWithObjectWithAllArgumentsInDifferentOrder():void {
			var anonProcessor:AnonMetadataProcessorWithArgumentsInDifferentOrderAndDifferentProcessName = new AnonMetadataProcessorWithArgumentsInDifferentOrderAndDifferentProcessName();
			_processor = new GenericMetadataProcessor(anonProcessor, "process");
			var target:Object = {};
			_processor.process(target, "test", "testInfo");
			assertEquals(3, anonProcessor.processArgsValues.length);
			assertStrictlyEquals(target, anonProcessor.processArgsValues[0]);
			assertEquals("test", anonProcessor.processArgsValues[1]);
			assertEquals("testInfo", anonProcessor.processArgsValues[2]);
		}

		[Test]
		public function testCreateWithObjectWithOneArgument():void {
			var anonProcessor:AnonMetadataProcessorWithOneArgument = new AnonMetadataProcessorWithOneArgument();
			_processor = new GenericMetadataProcessor(anonProcessor, "process");
			var target:Object = {};
			_processor.process(target, "test", "testInfo");
			assertEquals(1, anonProcessor.processArgsValues.length);
			assertStrictlyEquals(target, anonProcessor.processArgsValues[0]);
		}
	}
}
