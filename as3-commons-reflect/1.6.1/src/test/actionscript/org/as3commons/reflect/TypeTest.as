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

	import flash.events.IEventDispatcher;
	import flash.net.registerClassAlias;

	import flexunit.framework.TestCase;

	import org.as3commons.reflect.testclasses.ClassInheritingInternalInterface;
	import org.as3commons.reflect.testclasses.ComplexClass;
	import org.as3commons.reflect.testclasses.ComplexerClass;
	import org.as3commons.reflect.testclasses.ConstructorRecursionHazardClass;
	import org.as3commons.reflect.testclasses.DynamicFinalComplexClass;
	import org.as3commons.reflect.testclasses.PublicClass;
	import org.as3commons.reflect.testclasses.PublicSubClass;

	/**
	 * @author Christophe Herreman
	 */
	public class TypeTest extends TestCase {

		public function TypeTest(methodName:String=null) {
			super(methodName);
		}

		override public function setUp():void {
			Type.reset();
			Type.typeProviderKind = TypeProviderKind.XML;
		}

		public function testForInstanceWithCustomClassInstance():void {
			var instance:PublicClass = new PublicClass();
			var type:Type = Type.forInstance(instance);
			assertEquals(12, type.methods.length);
			assertEquals(2, type.staticConstants.length);
			assertEquals(3, type.staticVariables.length);
			assertEquals(1, type.constants.length);
			assertEquals(4, type.variables.length);
			assertEquals("PublicClass", type.name);
			assertEquals("org.as3commons.reflect.testclasses::PublicClass", type.fullName);
		}

		public function testClassAlias():void {
			assertStrictlyEquals(TypeProviderKind.XML, Type.typeProviderKind);
			registerClassAlias("this_is_an_alias", PublicClass);
			var type:Type = Type.forClass(PublicClass);
			assertEquals("this_is_an_alias", type.alias);
		}

		public function testExtendsClasses():void {
			var type:Type = Type.forClass(ComplexerClass);
			assertEquals(2, type.extendsClasses.length);
			assertEquals(2, type.methods.length);
			assertEquals("org.as3commons.reflect.testclasses::ComplexClass", type.extendsClasses[0]);
		}

		public function testForInstanceWithStringInstance():void {
			//var type:Type = Type.forInstance("myString");
		}

		public function testForClassWithNativeAccess():void {
			var type:Type = Type.forClass(Array);
			assertEquals(6, type.staticConstants.length);
			assertEquals(0, type.methods.length);
			assertEquals("Array", type.name);
			assertEquals("Array", type.fullName);
		}

		public function testForClass_shouldHaveCorrectDeclaringTypesOnAccessors():void {
			var type:Type = Type.forClass(PublicSubClass);
			for each (var accessor:Accessor in type.accessors) {
				// acc4 is defined in PublicSubClass
				// prototype is defined in Class
				// all other accessors are defined in PublicClass
				if (accessor.name == "acc4") {
					assertEquals("PublicSubClass", accessor.declaringType.name);
				} else if (accessor.name == "prototype") {
					assertEquals("Class", accessor.declaringType.name);
				} else {
					assertEquals("PublicClass", accessor.declaringType.name);
				}
			}
		}

		public function testNoArgumentConstructorClass():void {
			var type:Type = Type.forClass(PublicClass);
			var constructor:Constructor = type.constructor;
			assertNotNull(constructor);
			assertNotNull(constructor.declaringType);
			assertEquals(constructor.declaringType.clazz, PublicClass);
			assertEquals(constructor.parameters.length, 0);
		}

		public function testWithArgumentConstructorClass():void {
			var type:Type = Type.forClass(ComplexClass);

			var constructor:Constructor = type.constructor;
			assertNotNull(constructor);
			assertNotNull(constructor.declaringType);
			assertEquals(constructor.declaringType.clazz, ComplexClass);
			assertEquals(constructor.parameters.length, 3);

			var firstParameter:Parameter = constructor.parameters[0];

			assertFalse(firstParameter.isOptional);
			assertEquals(String, firstParameter.type.clazz);

			var secondParameter:Parameter = constructor.parameters[1];

			assertFalse(secondParameter.isOptional);
			assertEquals(Number, secondParameter.type.clazz);


			var thirdParameter:Parameter = constructor.parameters[2];

			assertTrue(thirdParameter.isOptional);
			assertEquals(Array, thirdParameter.type.clazz);
		}

		// Test that no infinite loop is generated by constructor using Type.forName,Type.forInstance etc.
		// in the constructor due to constructor workaround in Type._getTypeDescription
		// (thanks to Jürgen Failenschmid for reporting this)
		public function testConstructorRecursionHazard():void {
			var type:Type = Type.forClass(ConstructorRecursionHazardClass);

			var constructor:Constructor = type.constructor;
			assertNotNull(constructor);
			assertNotNull(constructor.declaringType);
			assertEquals(constructor.declaringType.clazz, ConstructorRecursionHazardClass);
			assertEquals(constructor.parameters.length, 1);

			var firstParameter:Parameter = constructor.parameters[0];

			assertTrue(firstParameter.isOptional);
			assertEquals(String, firstParameter.type.clazz);

			//Assertion depends on which player version is used for the unit tests,
			//player version 10.1 or higher no longer has the bug that needed to be worked around:
			if (ReflectionUtils.playerHasConstructorBug()) {
				// Constructor should be called just once in any case:
				assertEquals(1, ConstructorRecursionHazardClass.constructorCalls);
			} else {
				// Constructor should not have been called:
				assertEquals(0, ConstructorRecursionHazardClass.constructorCalls);
			}
		}

		public function testIsInterfaceProperty():void {
			assertFalse(Type.forClass(Object).isInterface);
			assertFalse(Type.forClass(Array).isInterface);
			assertTrue(Type.forClass(IEventDispatcher).isInterface);
		}

		public function testIsDynamic():void {
			assertTrue(Type.forInstance(new DynamicFinalComplexClass("name", 10)).isDynamic);
			//commented out for now, it seems as if the describeType XML is returning faulty data...
			//assertFalse(Type.forInstance(new ComplexClass("",0)).isDynamic);
		}

		public function testIsFinal():void {
			assertTrue(Type.forInstance(new DynamicFinalComplexClass("name", 10)).isFinal);
			//commented out for now, it seems as if the describeType XML is returning faulty data...
			//assertFalse(Type.forInstance(new ComplexClass("",0)).isFinal);
		}

		public function testClassParameters():void {
			var type:Type = Type.forInstance(new String());
			assertEquals(0, type.parameters.length);
			type = Type.forInstance(new Vector.<Type>());
			assertEquals(1, type.parameters.length);
			assertStrictlyEquals(Type, type.parameters[0]);
		}

		public function testClassInheritingInternalInterface():void {
			var type:Type = Type.forClass(ClassInheritingInternalInterface);
			assertEquals(1, type.interfaces.length);
			assertNull(Type.forName(type.interfaces[0]));
		}

	}
}
