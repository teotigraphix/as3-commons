package org.as3commons.reflect {
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
		var field:Field = new Field("prop", "*", "Object", false); 
		field.as3commons_reflect::setDeclaringType(Type.forClass(Number));
		field.as3commons_reflect::setIsStatic(true);
		field.as3commons_reflect::setName("property");
		field.as3commons_reflect::setNamespaceURI("org.as3commons.reflect");
		field.as3commons_reflect::setType(Type.VOID);
		
		assertEquals(Type.forClass(Number), field.declaringType);
		assertTrue(field.isStatic);
		assertEquals("property", field.name);
		assertEquals("org.as3commons.reflect", field.namespaceURI);
		assertEquals(Type.VOID, field.type);
	}
}
}