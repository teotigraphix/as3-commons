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
package org.as3commons.aop.pointcut.impl.name {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Christophe Herreman
	 */
	public class NameRegistryTest {

		public function NameRegistryTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests - new
		//
		// --------------------------------------------------------------------

		[Test]
		public function testNew_withoutArguments():void {
			var reg:NameRegistry = new NameRegistry();
			assertEquals(0, reg.numNames);
			assertNotNull(reg.names);
			assertEquals(0, reg.names.length);
		}

		[Test]
		public function testNew_withString():void {
			var reg:NameRegistry = new NameRegistry("aName");
			assertEquals(1, reg.numNames);
			assertNotNull(reg.names);
			assertEquals(1, reg.names.length);
			assertEquals("aName", reg.names[0]);
		}

		[Test]
		public function testNew_withVector():void {
			var names:Vector.<String> = new Vector.<String>();
			names.push("aName");
			names.push("anotherName");
			var reg:NameRegistry = new NameRegistry(names);
			assertEquals(2, reg.numNames);
			assertNotNull(reg.names);
			assertEquals(2, reg.names.length);
			assertEquals("aName", reg.names[0]);
			assertEquals("anotherName", reg.names[1]);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNew_withVectorThatContainsNullOrEmptyValues():void {
			var names:Vector.<String> = new Vector.<String>();
			names.push("aName");
			names.push("anotherName");
			names.push("");
			names.push(null);
			var reg:NameRegistry = new NameRegistry(names);
		}

		[Test]
		public function testNew_withArray():void {
			var names:Array = ["aName", "anotherName"];
			var reg:NameRegistry = new NameRegistry(names);
			assertEquals(2, reg.numNames);
			assertNotNull(reg.names);
			assertEquals(2, reg.names.length);
			assertEquals("aName", reg.names[0]);
			assertEquals("anotherName", reg.names[1]);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNew_withArrayThatContainsNullOrEmptyValues():void {
			var names:Array = ["aName", "anotherName", null, "", "   "];
			var reg:NameRegistry = new NameRegistry(names);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNew_withArrayThatContainsNonStringValues():void {
			var names:Array = [true, 123, {}, []];
			var reg:NameRegistry = new NameRegistry(names);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNew_withUnsupportedArgument():void {
			var reg:NameRegistry = new NameRegistry({});
		}

		// --------------------------------------------------------------------
		//
		// Tests - names
		//
		// --------------------------------------------------------------------

		[Test]
		public function testNames_shouldReturnCopy():void {
			var names:Vector.<String> = new Vector.<String>();
			names.push("aName");
			names.push("anotherName");
			var reg:NameRegistry = new NameRegistry(names);
			assertFalse(names === reg.names);
		}

		// --------------------------------------------------------------------
		//
		// Tests - addName()
		//
		// --------------------------------------------------------------------

		[Test]
		public function testAddName():void {
			var reg:NameRegistry = new NameRegistry();
			reg.addName("aName");
			assertEquals(1, reg.names.length);
			assertEquals("aName", reg.names[0]);
		}

		[Test]
		public function testAddName_shouldTrimName():void {
			var reg:NameRegistry = new NameRegistry();
			reg.addName("    aName       ");
			assertEquals(1, reg.names.length);
			assertEquals("aName", reg.names[0]);
		}

		[Test]
		public function testAddName_shouldNotAddSameName():void {
			var reg:NameRegistry = new NameRegistry();
			reg.addName("aName");
			reg.addName("aName");
			assertEquals(1, reg.names.length);
			assertEquals("aName", reg.names[0]);
		}

		[Test]
		public function testAddName_shouldNotAddSameNameAfterTrimming():void {
			var reg:NameRegistry = new NameRegistry();
			reg.addName("aName");
			reg.addName("  aName   ");
			assertEquals(1, reg.names.length);
			assertEquals("aName", reg.names[0]);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testAddName_withNullName():void {
			var reg:NameRegistry = new NameRegistry();
			reg.addName(null);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testAddName_withEmptyName():void {
			var reg:NameRegistry = new NameRegistry();
			reg.addName("");
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testAddName_withEmptyNameAfterTrimming():void {
			var reg:NameRegistry = new NameRegistry();
			reg.addName("     ");
		}

		// --------------------------------------------------------------------
		//
		// Tests - containsName()
		//
		// --------------------------------------------------------------------

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testContainsName_withNullName():void {
			var reg:NameRegistry = new NameRegistry();
			reg.containsName(null);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testContainsName_withEmptyName():void {
			var reg:NameRegistry = new NameRegistry();
			reg.containsName("");
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testContainsName_withEmptyNameAfterTrimming():void {
			var reg:NameRegistry = new NameRegistry();
			reg.containsName("   ");
		}

		[Test]
		public function testContainsName_onEmptyRegistry():void {
			var reg:NameRegistry = new NameRegistry();
			assertFalse(reg.containsName("aName"));
		}

		[Test]
		public function testContainsName_true():void {
			var reg:NameRegistry = new NameRegistry("aName");
			assertTrue(reg.containsName("aName"));
		}

		[Test]
		public function testContainsName_false():void {
			var reg:NameRegistry = new NameRegistry("aName");
			assertFalse(reg.containsName("anotherName"));
		}

		// --------------------------------------------------------------------
		//
		// Tests - removeName()
		//
		// --------------------------------------------------------------------

	}
}
