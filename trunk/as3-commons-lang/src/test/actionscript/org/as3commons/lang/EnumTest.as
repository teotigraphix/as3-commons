/*
 * Copyright (c) 2007-2009 the original author or authors
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
package org.as3commons.lang {
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.testclasses.Day;
	
	/**
	 * @author Christophe Herreman
	 */
	public class EnumTest extends TestCase {
		
		public function EnumTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testNew():void {
			var enum:Enum = new Enum("myEnum");
			assertEquals("myEnum", enum.name);
			
			var enum2:Enum = new Enum("");
			assertEquals("", enum2.name);
			
			var enum3:Enum = new Enum(null);
			assertEquals(null, enum3.name);
			
			var enum4:Enum = new Enum("   ");
			assertEquals("", enum4.name);
		}
		
		public function testGetEnum():void {
			assertEquals("MONDAY", Enum.getEnum(Day, "MONDAY").name);
			assertTrue(Enum.getEnum(Day, "MONDAY").equals(Day.MONDAY));
		}
		
		public function testGetEnum_shouldFailForNullClass():void {
			try {
				Enum.getEnum(null, "test");
				fail("Enum.getEnum(null, 'test') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testGetEnum_shouldFailForNullString():void {
			try {
				Enum.getEnum(TestCase, null);
				fail("Enum.getEnum(TestCase, null) should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testGetEnum_shouldFailForEmptyString():void {
			try {
				Enum.getEnum(TestCase, "");
				fail("Enum.getEnum(TestCase, '') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testGetEnum_shouldFailForBlankString():void {
			try {
				Enum.getEnum(TestCase, "   ");
				fail("Enum.getEnum(TestCase, '   ') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testGetEnum_shouldFailForNonEnum():void {
			try {
				Enum.getEnum(TestCase, "test");
				fail("Enum.getEnum(TestCase, 'test') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testGetEnum_shouldFailForNonEnumValue():void {
			try {
				Enum.getEnum(Day, "test");
				fail("Enum.getEnum(Day, 'test') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testGetValues():void {
			var values:Array = Enum.getValues(Day);
			assertNotNull(values);
			assertEquals(7, values.length);
			
			var values2:Array = Enum.getValues(Day);
			assertNotNull(values2);
			assertEquals(7, values2.length);
		}
		
		public function testGetValues_shouldNotContainDuplicateValues():void {
			new Enum("myEnum");
			
			var numValues:uint = Enum.getValues(Enum).length;
			
			new Enum("myEnum");
			
			assertEquals(numValues, Enum.getValues(Enum).length);
		}
	}
}