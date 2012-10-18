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

	import flash.utils.getQualifiedClassName;

	import flexunit.framework.Assert;
	import flexunit.framework.Reflective;
	import flexunit.framework.Test;
	import flexunit.framework.TestCase;

	import org.as3commons.lang.testclasses.ComplexClass;
	import org.as3commons.lang.testclasses.ISubInterface;
	import org.as3commons.lang.testclasses.IncompleteInterfaceImplementation;
	import org.as3commons.lang.testclasses.IncorrectInterfaceImplementation;
	import org.as3commons.lang.testclasses.InformalInterfaceImplementation;
	import org.as3commons.lang.testclasses.Interface;
	import org.as3commons.lang.testclasses.InterfaceImplementation;
	import org.as3commons.lang.testclasses.PropertiesClass;
	import org.as3commons.lang.testclasses.PublicClass;
	import org.as3commons.lang.testclasses.PublicSubClass;
	import org.as3commons.lang.testclasses.SampleEnum;
	import org.as3commons.lang.testclasses.SubInterfaceImplementation;
	import org.as3commons.lang.testclasses.ProxySubclass;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;


	/**
	 * @author Christophe Herreman
	 */
	public class ClassUtilsTest {

		public function ClassUtilsTest() {
		}

		[Test]
		public function testForInstance():void {
			assertEquals(ClassUtilsTest, ClassUtils.forInstance(this));
			assertEquals(String, ClassUtils.forInstance(new String("a")));
			assertEquals(String, ClassUtils.forInstance("b"));
		}

		[Test]
		public function testForName_shouldReturnString():void {
			assertEquals(String, ClassUtils.forName("String"));
		}

		[Test]
		public function testForName_shouldReturnNumber():void {
			assertEquals(Number, ClassUtils.forName("Number"));
		}

		[Test]
		public function testForName_shouldReturnint():void {
			assertEquals(int, ClassUtils.forName("int"));
		}

		[Test]
		public function testForName_shouldReturnUint():void {
			assertEquals(uint, ClassUtils.forName("uint"));
		}

		[Test]
		public function testForName_shouldReturnBoolean():void {
			assertEquals(Boolean, ClassUtils.forName("Boolean"));
		}

		[Test]
		public function testForName_shouldReturnArray():void {
			assertEquals(Array, ClassUtils.forName("Array"));
		}

		[Test]
		public function testForName_shouldReturnDate():void {
			assertEquals(Date, ClassUtils.forName("Date"));
		}

		[Test]
		public function testForName_shouldReturnClass():void {
			assertEquals(Class, ClassUtils.forName("Class"));
		}

		[Test]
		public function testForName_shouldThrowClassNotFoundError():void {
			try {
				assertEquals(String, ClassUtils.forName("string"));
				fail("Calling forName() with unknown class should throw ClassNotFoundError");
			} catch (e:ClassNotFoundError) {
			}
		}

		[Test]
		public function testIsPrivateClass():void {
			assertTrue(ClassUtils.isPrivateClass(PrivateClass));
			assertTrue(ClassUtils.isPrivateClass(getQualifiedClassName(PrivateClass)));
			assertFalse(ClassUtils.isPrivateClass(Main));
			assertFalse(ClassUtils.isPrivateClass(ClassUtilsTest));
			assertFalse(ClassUtils.isPrivateClass(getQualifiedClassName(ClassUtilsTest)));
		}

		[Test]
		public function testIsSubclassOf():void {
			assertFalse(ClassUtils.isSubclassOf(ClassUtilsTest, String));
			assertTrue(ClassUtils.isSubclassOf(String, Object));
			assertTrue(ClassUtils.isSubclassOf(SampleEnum, Enum));
		}

		[Test]
		public function testGetSuperClass():void {
			var clazz:Class = SampleEnum;
			var parentClass:Class = ClassUtils.getSuperClass(clazz);
			assertEquals(Enum, parentClass);

			assertEquals(Enum, ClassUtils.getSuperClass(SampleEnum));
		}

		[Test]
		public function testGetSuperClassWithString():void {
			assertEquals(Object, ClassUtils.getSuperClass(String));
		}

		[Test]
		public function testGetSuperClassWithObject():void {
			assertEquals(null, ClassUtils.getSuperClass(Object));
		}

		[Test]
		public function testGetName():void {
			var result:String = ClassUtils.getName(ClassUtilsTest);
			assertEquals("ClassUtilsTest", result);
		}

		[Test]
		public function testGetFullyQualifiedName():void {
			var result:String = ClassUtils.getFullyQualifiedName(ClassUtilsTest);
			assertEquals("org.as3commons.lang::ClassUtilsTest", result);
		}

		[Test]
		public function testGetFullyQualifiedNameWithReplaceColons():void {
			var result:String = ClassUtils.getFullyQualifiedName(ClassUtilsTest, true);
			assertEquals("org.as3commons.lang.ClassUtilsTest", result);
		}

		[Test]
		public function testGetSuperClassName():void {
			var result:String = ClassUtils.getSuperClassName(SampleEnum);
			assertEquals("Enum", result);
		}

		[Test]
		public function testGetFullyQualifiedSuperClassName():void {
			var result:String = ClassUtils.getFullyQualifiedSuperClassName(SampleEnum);
			assertEquals("org.as3commons.lang::Enum", result);
		}

		[Test]
		public function testGetFullyQualifiedSuperClassNameWithReplaceColons():void {
			var result:String = ClassUtils.getFullyQualifiedSuperClassName(SampleEnum, true);
			assertEquals("org.as3commons.lang.Enum", result);
		}

		[Test]
		public function testGetNameFromFullyQualifiedName():void {
			var result:String = ClassUtils.getNameFromFullyQualifiedName("flexunit.framework::Reflective");
			assertEquals("Reflective", result);
		}

		[Test]
		public function testGetNameFromFullyQualifiedName_forArray():void {
			var result:String = ClassUtils.getNameFromFullyQualifiedName("Array");
			assertEquals("Array", result);
		}

		[Test]
		public function testNewInstance():void {
			var result:PublicClass = ClassUtils.newInstance(PublicClass, []);
			assertNotNull(result);
		}


		[Test]
		public function testGetImplementedInterfaceNames():void {
			var result:Array = ClassUtils.getImplementedInterfaceNames(TestCase);
			assertEquals(2, result.length);
			assertTrue(result.indexOf("Reflective") > -1);
			assertTrue(result.indexOf("Test") > -1);
		}

		[Test]
		public function testGetFullyQualifiedImplementedInterfaceNames():void {
			var result:Array = ClassUtils.getFullyQualifiedImplementedInterfaceNames(TestCase);
			assertEquals(2, result.length);
			assertTrue(result.indexOf("flexunit.framework::Reflective") > -1);
			assertTrue(result.indexOf("flexunit.framework::Test") > -1);
		}

		[Test]
		public function testGetFullyQualifiedImplementedInterfaceNames_replaceColons():void {
			var result:Array = ClassUtils.getFullyQualifiedImplementedInterfaceNames(TestCase, true);
			assertEquals(2, result.length);
			assertTrue(result.indexOf("flexunit.framework.Reflective") > -1);
			assertTrue(result.indexOf("flexunit.framework.Test") > -1);
		}

		[Test]
		public function testGetImplementedInterfaces():void {
			var result:Array = ClassUtils.getImplementedInterfaces(TestCase);
			assertEquals(2, result.length);
			assertTrue(result.indexOf(Reflective) > -1);
			assertTrue(result.indexOf(Test) > -1);
		}

		[Test]
		public function testConvertFullyQualifiedName():void {
			var result:String = ClassUtils.convertFullyQualifiedName("flexunit.framework::TestCase");
			assertEquals("flexunit.framework.TestCase", result);
		}

		// --------------------------------------------------------------------
		// isAssignableFrom
		// --------------------------------------------------------------------

		// helpers

		private static function assertIsAssignableFrom(c1:Class, c2:Class):void {
			assertTrue(ClassUtils.isAssignableFrom(c1, c2));
		}

		private static function assertIsNotAssignableFrom(c1:Class, c2:Class):void {
			assertFalse(ClassUtils.isAssignableFrom(c1, c2));
		}

		// assignable

		[Test]
		public function testIsAssignableFrom_shouldReturnTrueForObjectAndObject():void {
			assertIsAssignableFrom(Object, Object);
		}

		[Test]
		public function testIsAssignableFrom_shouldReturnTrueForObjectAndString():void {
			assertIsAssignableFrom(Object, String);
		}

		[Test]
		public function testIsAssignableFrom_shouldReturnTrueForObjectAndInt():void {
			assertIsAssignableFrom(Object, int);
		}

		[Test]
		public function testIsAssignableFrom_shouldReturnTrueForInterfaceAndInterfaceImplementation():void {
			assertIsAssignableFrom(Interface, InterfaceImplementation);
		}

		[Test]
		public function testIsAssignableFrom_shouldReturnTrueForInterfaceAndSubInterfaceImplementation():void {
			assertIsAssignableFrom(Interface, SubInterfaceImplementation);
		}

		[Test]
		public function testIsAssignableFrom_shouldReturnTrueForPublicClassAndPublicSubClass():void {
			assertIsAssignableFrom(PublicClass, PublicSubClass);
		}

		[Test]
		public function testIsAssignableFrom_shouldReturnTrueForObjectAndPublicSubClass():void {
			assertIsAssignableFrom(Object, PublicSubClass);
		}

		// NOT assignable

		[Test]
		public function testIsNotAssignableFrom_shouldReturnFalseForStringAndObject():void {
			assertIsNotAssignableFrom(String, Object);
		}

		// --------------------------------------------------------------------
		// isImplementationOf
		// --------------------------------------------------------------------

		[Test]
		public function testIsImplementationOf_shouldReturnTrueForInterfaceImplementation():void {
			assertTrue(ClassUtils.isImplementationOf(InterfaceImplementation, Interface));
		}

		[Test]
		public function testIsImplementationOf_shouldReturnTrueForSubInterface():void {
			assertTrue(ClassUtils.isImplementationOf(ISubInterface, Interface));
		}

		[Test]
		public function testIsImplementationOf_shouldReturnFalseForSameInterface():void {
			assertFalse(ClassUtils.isImplementationOf(Interface, Interface));
		}

		// --------------------------------------------------------------------
		// isInformalImplementationOf
		// --------------------------------------------------------------------

		[Test]
		public function testIsInformalImplementationOf_shouldReturnTrueForInterfaceImplementation():void {
			assertTrue(ClassUtils.isInformalImplementationOf(InterfaceImplementation, Interface));
		}

		[Test]
		public function testIsInformalImplementationOf_shouldReturnTrueForInformalInterfaceImplementation():void {
			assertTrue(ClassUtils.isInformalImplementationOf(InformalInterfaceImplementation, Interface));
		}

		[Test]
		public function testIsInformalImplementationOf_shouldReturnFalseForIncompleteInterfaceImplementation():void {
			assertFalse(ClassUtils.isInformalImplementationOf(IncompleteInterfaceImplementation, Interface));
		}

		[Test]
		public function testIsInformalImplementationOf_shouldReturnFalseForIncorrectInterfaceImplementation():void {
			assertFalse(ClassUtils.isInformalImplementationOf(IncorrectInterfaceImplementation, Interface));
		}

		// --------------------------------------------------------------------
		// isInterface
		// --------------------------------------------------------------------

		[Test]
		public function testIsInterface_withInterface():void {
			assertTrue(ClassUtils.isInterface(Interface));
		}

		[Test]
		public function testIsInterface_withSubInterface():void {
			assertTrue(ClassUtils.isInterface(ISubInterface));
		}

		/*[Test]
		public function testIsInterface_withObjectClass():void {
			assertFalse(ClassUtils.isInterface(Object));
		}*/

		[Test]
		public function testIsInterface_withComplexClass():void {
			assertFalse(ClassUtils.isInterface(ComplexClass));
		}

		[Test]
		public function testIsInterface_withPublicSubClass():void {
			assertFalse(ClassUtils.isInterface(PublicSubClass));
		}

		[Test]
		public function testIsInterface_withInterfaceImplementation():void {
			assertFalse(ClassUtils.isInterface(InterfaceImplementation));
		}

		[Test]
		public function testIsInterface_withSubInterfaceImplementation():void {
			assertFalse(ClassUtils.isInterface(SubInterfaceImplementation));
		}

		[Test]
		public function testGetClassParameterFromFullyQualifiedName():void {
			var cls:Class = ClassUtils.getClassParameterFromFullyQualifiedName('org.as3commons.lang.testclasses.ComplexClass');
			assertNull(cls);
			cls = ClassUtils.getClassParameterFromFullyQualifiedName('__AS3__.vec::Vector.<org.as3commons.lang.testclasses::ComplexClass>');
			assertNotNull(cls);
			assertStrictlyEquals(ComplexClass, cls);
			cls = ClassUtils.getClassParameterFromFullyQualifiedName('__AS3__.vec::Vector.<String>');
			assertNotNull(cls);
			assertStrictlyEquals(String, cls);
		}

		[Test]
		public function testProperties():void {
			flexunit.framework.Assert.assertObjectEquals({publicSetter: String, "as3commons::publicSetter": String}, ClassUtils.getProperties(PropertiesClass, false, false, true));
			flexunit.framework.Assert.assertObjectEquals({publicVar: String, publicSetterGetter: String, "as3commons::publicVar": String, "as3commons::publicSetterGetter": String}, ClassUtils.getProperties(PropertiesClass, false, true, true));
			flexunit.framework.Assert.assertObjectEquals({publicConst: String, publicGetter: String, "as3commons::publicConst": String, "as3commons::publicGetter": String}, ClassUtils.getProperties(PropertiesClass, false, true, false));
			flexunit.framework.Assert.assertObjectEquals({staticSetter: Number, "as3commons::staticSetter": Array}, ClassUtils.getProperties(PropertiesClass, true, false, true));
			flexunit.framework.Assert.assertObjectEquals({staticVar: int, staticSetterGetter: String, "as3commons::staticVar": uint, "as3commons::staticSetterGetter": Object}, ClassUtils.getProperties(PropertiesClass, true, true, true));
			flexunit.framework.Assert.assertObjectEquals({staticConst: String, staticGetter: Object, prototype: Object, "as3commons::staticConst": int, "as3commons::staticGetter": Array}, ClassUtils.getProperties(PropertiesClass, true, true, false));
		}

		[Test]
		public function testForInstanceWithProxy():void {
			var proxy:ProxySubclass = new ProxySubclass();
			var cls:Class = ClassUtils.forInstance(proxy);
			assertStrictlyEquals(ProxySubclass, cls);
		}
	}
}

class PrivateClass {

	public function PrivateClass() {
	}
}
