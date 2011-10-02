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
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	/**
	 *
	 * @author rolandzwaga
	 */
	public class AbstractMetadataProcessorTest {
		/**
		 * Creates a new <code>AbstractMetadataProcessorTest</code> instance.
		 */
		public function AbstractMetadataProcessorTest() {
			super();
		}

		[Test]
		public function testConstructor():void {
			var proc:AbstractMetadataProcessor = new AbstractMetadataProcessor();
			assertNotNull(proc.metadataNames);
		}

		[Test]
		public function testCanProcess():void {
			var proc:AbstractMetadataProcessor = new AbstractMetadataProcessor();
			proc.metadataNames[proc.metadataNames.length] = "test";
			assertTrue(proc.canProcess("test"));
			assertFalse(proc.canProcess("test2"));
		}
	}
}
