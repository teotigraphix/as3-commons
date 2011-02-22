/*
* Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.emit.asm {
	import flexunit.framework.TestCase;

	public class AsmTest extends TestCase {

		private var _asm:Asm;

		public function AsmTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_asm = new Asm();
		}

		public function testWhitespace():void {
			var result:Boolean = _asm.whitespace(' ');
			assertTrue(result);
			result = _asm.whitespace('	');
			assertTrue(result);
			result = _asm.whitespace('a');
			assertFalse(result);
		}

		public function testInstruction():void {
			var result:Boolean = _asm.instruction(' ');
			assertFalse(result);
			result = _asm.instruction('	');
			assertFalse(result);
			result = _asm.instruction('a');
			assertTrue(result);
		}

		public function testParseOneInstructionWithoutParameter():void {
			var result:Array = _asm.parse('add_i');
			assertTrue(result.length == 1);
			assertStrictlyEquals(AsmToken(result[0]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[0]).value, "add_i");
		}

		public function testParseTwoInstructionsWithoutParameter():void {
			var result:Array = _asm.parse("add_i\r\nadd");
			assertTrue(result.length == 2);
			assertStrictlyEquals(AsmToken(result[0]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[0]).value, "add_i");
			assertStrictlyEquals(AsmToken(result[1]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[1]).value, "add");
		}

		public function testParseOneInstructionWithParameter():void {
			var result:Array = _asm.parse('applytype	1');
			assertTrue(result.length == 2);
			assertStrictlyEquals(AsmToken(result[0]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[0]).value, "applytype");
			assertStrictlyEquals(AsmToken(result[1]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[1]).value, "1");
		}

		public function testParseOneInstructionWithParameterAndMixedWhitespace():void {
			var result:Array = _asm.parse('applytype    	1');
			assertTrue(result.length == 2);
			assertStrictlyEquals(AsmToken(result[0]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[0]).value, "applytype");
			assertStrictlyEquals(AsmToken(result[1]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[1]).value, "1");
		}

		public function testParseOTwoInstructionsWithParameter():void {
			var result:Array = _asm.parse('applytype	1\r\nastype com.classes.MyType');
			assertTrue(result.length == 4);
			assertStrictlyEquals(AsmToken(result[0]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[0]).value, "applytype");
			assertStrictlyEquals(AsmToken(result[1]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[1]).value, "1");
			assertStrictlyEquals(AsmToken(result[2]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[2]).value, "astype");
			assertStrictlyEquals(AsmToken(result[3]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[3]).value, "com.classes.MyType");
		}

		public function testParseOThreeInstructionsWithAndWithoutParameterWithMultilineString():void {
			var mySource:String = (<![CDATA[
							applytype	1
							add_i
							astype	com.classes.MyType
							]]>).toString();
			var result:Array = _asm.parse(mySource);
			assertEquals(5, result.length);
			assertStrictlyEquals(AsmToken(result[0]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[0]).value, "applytype");
			assertStrictlyEquals(AsmToken(result[1]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[1]).value, "1");
			assertStrictlyEquals(AsmToken(result[2]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[2]).value, "add_i");
			assertStrictlyEquals(AsmToken(result[3]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[3]).value, "astype");
			assertStrictlyEquals(AsmToken(result[4]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[4]).value, "com.classes.MyType");
		}

		public function testParseOThreeInstructionsWithAndWithoutParameterAndWithLabelWithMultilineString():void {
			var source:String = (<![CDATA[
							applytype	1

							add_i
							L0:
							astype	com.classes.MyType
							]]>).toString();
			var result:Array = _asm.parse(source);
			assertEquals(6, result.length);
			assertStrictlyEquals(AsmToken(result[0]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[0]).value, "applytype");
			assertStrictlyEquals(AsmToken(result[1]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[1]).value, "1");
			assertStrictlyEquals(AsmToken(result[2]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[2]).value, "add_i");
			assertStrictlyEquals(AsmToken(result[3]).kind, TokenKind.LABEL);
			assertEquals(AsmToken(result[3]).value, "L0:");
			assertStrictlyEquals(AsmToken(result[4]).kind, TokenKind.INSTRUCTION);
			assertEquals(AsmToken(result[4]).value, "astype");
			assertStrictlyEquals(AsmToken(result[5]).kind, TokenKind.OPERAND);
			assertEquals(AsmToken(result[5]).value, "com.classes.MyType");
		}

		public function testParseAndConvert():void {
			var source:String = (<![CDATA[
			debugfile     	"C:\projects\as3-commons\as3-commons-lang\src\main\actionscript;org\as3commons\lang;ClassUtils.as"
			debugline     	310
			getlocal_0     	
			pushscope     	
			debug         	1 35 0 310
			debug         	1 11 1 310
			debug         	1 33 2 312
			debug         	1 88 3 314
			debugline     	311
			getlocal_2     	
			pushnull      	
			ifne          	L0
			
			findpropstrict	flash.system:ApplicationDomain
			getproperty   	flash.system:ApplicationDomain
			getproperty   	:currentDomain
			coerce        	flash.system:ApplicationDomain
			jump          	L1
			L0:
			getlocal_2     	
			coerce        	flash.system:ApplicationDomain
			L1:
			coerce        	flash.system:ApplicationDomain
			setlocal_2     	
			debugline     	312
			findpropstrict	:getFullyQualifiedImplementedInterfaceNames
			getlocal_1     	
			callproperty  	:getFullyQualifiedImplementedInterfaceNames 1
			coerce        	:Array
			setlocal_3     	
			debugline     	314
			pushbyte      	0
			convert_i     	
			setlocal      	4
			jump          	L2
			
			L3:
			label         	
			debugline     	315
			getlocal_3     	
			getlocal      	4
			findpropstrict	org.as3commons.lang:ClassUtils
			getproperty   	org.as3commons.lang:ClassUtils
			getlocal_3     	
			getlocal      	4
			getproperty   	private,,org.as3commons.lang,org.as3commons.lang,http://adobe.com/AS3/2006/builtin,private,org.as3commons.lang:ClassUtils,org.as3commons.lang:ClassUtils,Object:null
			getlocal_2     	
			callproperty  	:forName 2
			setproperty   	private,,org.as3commons.lang,org.as3commons.lang,http://adobe.com/AS3/2006/builtin,private,org.as3commons.lang:ClassUtils,org.as3commons.lang:ClassUtils,Object:null
			debugline     	314
			getlocal      	4
			increment_i   	
			convert_i     	
			setlocal      	4
			L2:
			getlocal      	4
			getlocal_3     	
			getproperty   	:length
			iflt          	L3
			
			debugline     	317
			getlocal_3     	
			returnvalue]]>).toString();
			var result:Array = _asm.parseAndConvert(source);
		}
	}
}