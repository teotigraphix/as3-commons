/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.reflect {

	import flexunit.framework.TestCase;

	/**
	 * @author Christophe Herreman
	 */
	public class MetadataContainerTest extends TestCase {

		/**
		 * Creates a new MetadataContainerTest.
		 */
		public function MetadataContainerTest(methodName:String = null) {
			super(methodName);
		}


		public function testHasMetadata_shouldReturnTrueIfMetadataWasFound():void {
			var metadataContainer:MetadataContainer = new MetadataContainer();
			metadataContainer.addMetadata(new Metadata("testMetadata"));
			assertTrue(metadataContainer.hasMetadata("testMetadata"));
		}

		public function testHasMetadata_shouldReturnFalseIfNoMetadataWasFound():void {
			var metadataContainer:MetadataContainer = new MetadataContainer();
			metadataContainer.addMetadata(new Metadata("testMetadata"));
			assertFalse(metadataContainer.hasMetadata("nonExistingMetadata"));
		}

		public function testHasExactMetadata_shouldReturnTrueIfMatchingMetadataWasFound():void {
			var metadataContainer:MetadataContainer = new MetadataContainer();
			var tm:Metadata = new Metadata("testMetadata");
			tm.arguments.push(new MetadataArgument("testKey", "testValue"));
			metadataContainer.addMetadata(tm);
			var tm2:Metadata = new Metadata("testMetadata");
			tm2.arguments.push(new MetadataArgument("testKey", "testValue"));
			assertTrue(metadataContainer.hasExactMetadata(tm2));
		}

		public function testHasExactMetadata_shouldReturnFalseIfNoMatchingMetadataWasFound():void {
			var metadataContainer:MetadataContainer = new MetadataContainer();
			metadataContainer.addMetadata(new Metadata("testMetadata"));
			var tm:Metadata = new Metadata("testMetadata");
			tm.arguments.push(new MetadataArgument("testKey", "testValue"));
			assertFalse(metadataContainer.hasExactMetadata(tm));
		}


	}
}