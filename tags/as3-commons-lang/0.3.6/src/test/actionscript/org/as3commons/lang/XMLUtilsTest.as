/*
 * Copyright 2009-2010 the original author or authors.
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
package org.as3commons.lang {

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	/**
	 * @author Christophe Herreman
	 */
	public class XMLUtilsTest {

		private var xml:XML;

		public function XMLUtilsTest() {
		}

		[Before]
		public function setUp():void {
			XML.ignoreComments = false;
			XML.ignoreProcessingInstructions = false;
			xml = <example id="10">
				<!-- this is a comment -->
			<?test this is a pi ?>
			and some text
			</example>;
		}

		[After]
		public function tearDown():void {
			XML.ignoreComments = true;
			XML.ignoreProcessingInstructions = true;
		}

		[Test]
		public function testIsElementNode():void {
			assertTrue(XMLUtils.isElementNode(xml));
			assertFalse(XMLUtils.isElementNode(xml.children()[0]));
			assertFalse(XMLUtils.isElementNode(xml.children()[1]));
			assertFalse(XMLUtils.isElementNode(xml.children()[2]));
			assertFalse(XMLUtils.isElementNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isElementNode, [null]);
		}

		[Test]
		public function testIsCommentNode():void {
			assertFalse(XMLUtils.isCommentNode(xml));
			assertTrue(XMLUtils.isCommentNode(xml.children()[0]));
			assertFalse(XMLUtils.isCommentNode(xml.children()[1]));
			assertFalse(XMLUtils.isCommentNode(xml.children()[2]));
			assertFalse(XMLUtils.isCommentNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isCommentNode, [null]);
		}

		[Test]
		public function testIsProcessingInstructionNode():void {
			assertFalse(XMLUtils.isProcessingInstructionNode(xml));
			assertFalse(XMLUtils.isProcessingInstructionNode(xml.children()[0]));
			assertTrue(XMLUtils.isProcessingInstructionNode(xml.children()[1]));
			assertFalse(XMLUtils.isProcessingInstructionNode(xml.children()[2]));
			assertFalse(XMLUtils.isProcessingInstructionNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isProcessingInstructionNode, [null]);
		}

		[Test]
		public function testIsTextNode():void {
			assertFalse(XMLUtils.isTextNode(xml));
			assertFalse(XMLUtils.isTextNode(xml.children()[0]));
			assertFalse(XMLUtils.isTextNode(xml.children()[1]));
			assertTrue(XMLUtils.isTextNode(xml.children()[2]));
			assertFalse(XMLUtils.isTextNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isTextNode, [null]);
		}

		[Test]
		public function testIsAttributeNode():void {
			assertFalse(XMLUtils.isAttributeNode(xml));
			assertFalse(XMLUtils.isAttributeNode(xml.children()[0]));
			assertFalse(XMLUtils.isAttributeNode(xml.children()[1]));
			assertFalse(XMLUtils.isAttributeNode(xml.children()[2]));
			assertTrue(XMLUtils.isAttributeNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isAttributeNode, [null]);
		}

		[Test]
		public function testMergeXML():void {
			var source:XML = new XML("<root><element/></root>");
			var merged:XML = new XML("<root><element/></root>");
			source = XMLUtils.mergeXML(source, merged);
			assertEquals(2, source.children().length());
		}

		[Test]
		public function testMergeXMLWithMergedExtraNamespace():void {
			var source:XML = new XML("<root><element/></root>");
			var merged:XML = new XML('<root xmlns:pre="http://www.springactionscript.org/schema/objects"><pre:element/></root>');
			source = XMLUtils.mergeXML(source, merged);
			assertEquals(2, source.children().length());
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testHasAttribute_withNullXML():void {
			XMLUtils.hasAttribute(null, "attributeName");
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testHasAttribute_withNullArgumentName():void {
			XMLUtils.hasAttribute(<node/>, null);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testHasAttribute_withEmptyArgumentName():void {
			XMLUtils.hasAttribute(<node/>, "");
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testHasAttribute_withAllSpacesArgumentName():void {
			XMLUtils.hasAttribute(<node/>, "   ");
		}

		[Test]
		public function testHasAttribute():void {
			assertFalse(XMLUtils.hasAttribute(<node/>, "id"));
			assertTrue(XMLUtils.hasAttribute(<node id="123"/>, "id"));
			assertFalse(XMLUtils.hasAttribute(<node id="123"/>, "name"));
		}

		private static function assertThrowsIllegalArgumentError(f:Function, args:Array):void {
			try {
				f.apply(XMLUtils, args);
				fail("Expecting IllegalArgumentError being thrown");
			} catch (e:IllegalArgumentError) {
			}
		}
	}
}
