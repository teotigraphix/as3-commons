package org.as3commons.reflect {
	import flash.system.ApplicationDomain;

	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;

	import org.as3commons.reflect.as3commons_reflect;

	public class FieldTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// as3commons_reflect
		//
		// --------------------------------------------------------------------

		public function testSetProperties():void {
			var field:Field = new Field("prop", "*", "Object", false, ApplicationDomain.currentDomain);
			field.as3commons_reflect::setDeclaringType("Number");
			field.as3commons_reflect::setIsStatic(true);
			field.as3commons_reflect::setName("property");
			field.as3commons_reflect::setNamespaceURI("org.as3commons.reflect");
			field.as3commons_reflect::setType(Type.VOID.fullName);

			var NrType:Type = Type.forClass(Number, ApplicationDomain.currentDomain);
			var declType:Type = field.declaringType;
			assertStrictlyEquals(NrType, declType);
			assertTrue(field.isStatic);
			assertEquals("property", field.name);
			assertEquals("org.as3commons.reflect", field.namespaceURI);
			assertStrictlyEquals(Type.VOID, field.type);
		}
	}
}