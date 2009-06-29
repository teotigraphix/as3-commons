package org.as3commons.lang {
	
	import flexunit.framework.TestCase;
	
	public class XMLUtilsTest extends TestCase {
		
		private var xml;
		
		public function XMLUtilsTest(methodName:String = null) {
			super(methodName);
		}
		
		override public function setUp():void {
			super.setUp();
			XML.ignoreComments = false;
			XML.ignoreProcessingInstructions = false;
			xml =  <example id="10">
					<!-- this is a comment -->
					<?test this is a pi ?>
					and some text
				</example>;
		}
		
		override public function tearDown():void {
			super.tearDown();
			XML.ignoreComments = true;
			XML.ignoreProcessingInstructions = true;
		}
		
		public function testIsElementNode():void {
			assertTrue(XMLUtils.isElementNode(xml));
			assertFalse(XMLUtils.isElementNode(xml.children()[0]));
			assertFalse(XMLUtils.isElementNode(xml.children()[1]));
			assertFalse(XMLUtils.isElementNode(xml.children()[2]));
			assertFalse(XMLUtils.isElementNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isElementNode, [null]);
		}
		
		public function testIsCommentNode():void {
			assertFalse(XMLUtils.isCommentNode(xml));
			assertTrue(XMLUtils.isCommentNode(xml.children()[0]));
			assertFalse(XMLUtils.isCommentNode(xml.children()[1]));
			assertFalse(XMLUtils.isCommentNode(xml.children()[2]));
			assertFalse(XMLUtils.isCommentNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isCommentNode, [null]);
		}
		
		public function testIsProcessingInstructionNode():void {
			assertFalse(XMLUtils.isProcessingInstructionNode(xml));
			assertFalse(XMLUtils.isProcessingInstructionNode(xml.children()[0]));
			assertTrue(XMLUtils.isProcessingInstructionNode(xml.children()[1]));
			assertFalse(XMLUtils.isProcessingInstructionNode(xml.children()[2]));
			assertFalse(XMLUtils.isProcessingInstructionNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isProcessingInstructionNode, [null]);
		}
		
		public function testIsTextNode():void {
			assertFalse(XMLUtils.isTextNode(xml));
			assertFalse(XMLUtils.isTextNode(xml.children()[0]));
			assertFalse(XMLUtils.isTextNode(xml.children()[1]));
			assertTrue(XMLUtils.isTextNode(xml.children()[2]));
			assertFalse(XMLUtils.isTextNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isTextNode, [null]);
		}
		
		public function testIsAttributeNode():void {
			assertFalse(XMLUtils.isAttributeNode(xml));
			assertFalse(XMLUtils.isAttributeNode(xml.children()[0]));
			assertFalse(XMLUtils.isAttributeNode(xml.children()[1]));
			assertFalse(XMLUtils.isAttributeNode(xml.children()[2]));
			assertTrue(XMLUtils.isAttributeNode(xml.@id[0]));
			assertThrowsIllegalArgumentError(XMLUtils.isAttributeNode, [null]);
		}
		
		private function assertThrowsIllegalArgumentError(f:Function, args:Array):void {
			try {
				f.apply(XMLUtils, args);
				fail("Expecting IllegalArgumentError being thrown");
			} catch (e:IllegalArgumentError) {
			}
		}
	}
}