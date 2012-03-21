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
	import flexunit.framework.TestCase;
	import org.as3commons.lang.testclasses.Day;
	import org.as3commons.lang.testclasses.SampleEnum;
	import org.as3commons.lang.testclasses.UntrimmedEnum;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;


	/**
	 * @author Christophe Herreman
	 */
	public class EnumTest {
		
		public function EnumTest() {
		}

		[Test]
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

		[Test]
		public function testGetEnum():void {
			assertEquals("MONDAY", Enum.getEnum(Day, "MONDAY").name);
			assertTrue(Enum.getEnum(Day, "MONDAY").equals(Day.MONDAY));
		}

		[Test]
		public function testFetEnum_UntrimmedEnumNames():void {
		var values:Array = UntrimmedEnum.values;
			for each (var untrimmedEnum:UntrimmedEnum in values) {
				assertEquals("Wrong enum returned when creating an enum from it's own name", untrimmedEnum, Enum.getEnum(UntrimmedEnum, untrimmedEnum.name))
			}
		}

		[Test]
		public function testGetEnum_shouldFailForNullClass():void {
			try {
				Enum.getEnum(null, "test");
				fail("Enum.getEnum(null, 'test') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		[Test]
		public function testGetEnum_shouldFailForNullString():void {
			try {
				Enum.getEnum(TestCase, null);
				fail("Enum.getEnum(TestCase, null) should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		[Test]
		public function testGetEnum_shouldFailForEmptyString():void {
			try {
				Enum.getEnum(TestCase, "");
				fail("Enum.getEnum(TestCase, '') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		[Test]
		public function testGetEnum_shouldFailForBlankString():void {
			try {
				Enum.getEnum(TestCase, "   ");
				fail("Enum.getEnum(TestCase, '   ') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		[Test]
		public function testGetEnum_shouldFailForNonEnum():void {
			try {
				Enum.getEnum(TestCase, "test");
				fail("Enum.getEnum(TestCase, 'test') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		[Test]
		public function testGetEnum_shouldFailForNonEnumValue():void {
			try {
				Enum.getEnum(Day, "test");
				fail("Enum.getEnum(Day, 'test') should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		[Test]
		public function testGetValues():void {
			var values:Array = Enum.getValues(Day);
			assertNotNull(values);
			assertEquals(7, values.length);
			
			var values2:Array = Enum.getValues(Day);
			assertNotNull(values2);
			assertEquals(7, values2.length);
		}

		[Test]
		public function testGetValues_shouldNotContainDuplicateValues():void {
			new Day("MONDAY");
			
			var numValues:uint = Enum.getValues(Day).length;
			
			new Day("MONDAY");
			
			assertEquals(numValues, Enum.getValues(Day).length);
		}

		[Test]
		public function testGetValues_shouldFailForNonEnumClass():void {
			try {
				Enum.getValues(TestCase);
				fail("Enum.getValues(TestCase) should fail");
			} catch(e:IllegalArgumentError) {
			}
		}

		[Test]
		public function testAutoFill():void {
			assertEquals("A undefined name should be defined immediately.", "A", SampleEnum.A.name);
			assertEquals("Enums may not override proper names", "X", SampleEnum.B.name);
			namespace ns = "as3commons";
			assertEquals("Namespaced constants should work too", "as3commons::G", SampleEnum.ns::G.name);
			assertEquals("Public vars should work too", "F", SampleEnum.F.name);
			assertEquals("Even getters should work", "E", SampleEnum.E.name);
			assertTrue("Indexing has to work from top to bottom", SampleEnum.A.index != -1);
			var sample1: SampleEnum = new SampleEnum("Sample");
			assertTrue("A new sample enum must be listed", Enum.getIndex(sample1) != -1);
			var sample2: SampleEnum = new SampleEnum("Sample");
			assertEquals("The name should be sure", "Sample", sample2.name);
			assertEquals("A second enum with same name may not override the first one", Enum.getEnum(SampleEnum, "Sample"), sample1 );
		}
	}
}

import org.as3commons.lang.Enum;

class LocalEnum extends Enum {
	public static const A: LocalEnum = new LocalEnum;
	public static const B: LocalEnum = new LocalEnum;
	public static const C: LocalEnum = new LocalEnum;
	
	private static const _E: LocalEnum = new LocalEnum;
	
	public static function get E(): LocalEnum {
		return _E;
	}
	
	public static const X1: Number = 1;
	public var X2: Number = 2;
	public var X3: LocalEnum;

	public function LocalEnum() {
	}

	public function get X4(): LocalEnum {
		return X3;
	}
}