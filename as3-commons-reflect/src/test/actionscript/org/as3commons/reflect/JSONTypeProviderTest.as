package org.as3commons.reflect {
	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	import org.as3commons.reflect.testclasses.FullTestClass;
	import org.as3commons.reflect.testclasses.Interface;

	public class JSONTypeProviderTest extends TestCase {

		public function JSONTypeProviderTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			Type.reset();
			Type.typeProviderKind = TypeProviderKind.JSON;
		}

		public function testConstructor():void {
			var td:JSONTypeProvider = new JSONTypeProvider();
		}

		public function testIsInterface():void {
			var type:Type = Type.forClass(Interface, ApplicationDomain.currentDomain);
			assertTrue(type.isInterface);
		}

		public function testGetType():void {
			var type:Type = Type.forClass(FullTestClass, ApplicationDomain.currentDomain);
			assertFalse(type.isInterface);
			assertFalse(type.isDynamic);
			assertFalse(type.isFinal);
			assertFalse(type.isStatic);
			//accessors
			assertEquals(JSONTypeProvider.ALIAS_NOT_AVAILABLE, type.alias);
			assertEquals(4, type.accessors.length);
			//constructor
			assertStrictlyEquals(type, type.constructor.declaringType);
			assertEquals(2, type.constructor.parameters.length);
			var param:Parameter = type.constructor.parameters[0];
			assertEquals(1, param.index);
			assertEquals(false, param.isOptional);
			assertEquals("String", param.type.name);
			param = type.constructor.parameters[1];
			assertEquals(2, param.index);
			assertEquals(false, param.isOptional);
			assertEquals("int", param.type.name);
			//variables
			assertEquals(2, type.variables.length);
			//static variables
			assertEquals(1, type.staticVariables.length);
			//constants
			assertEquals(1, type.constants.length);
			//static constants
			assertEquals(1, type.staticConstants.length);
			//interfaces
			assertEquals(1, type.interfaces.length);
			//methods
			assertEquals(11, type.methods.length);
			var m:Method = type.getMethod("someMethodWithRestParams");
			var i:int = 0;
		}

	}
}