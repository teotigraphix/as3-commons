package org.as3commons.lang {
import avmplus.DescribeType;

import flash.events.EventDispatcher;

import org.as3commons.lang.typedescription.JSONTypeDescription;
import org.as3commons.lang.typedescription.XMLTypeDescription;
import org.flexunit.asserts.assertTrue;

public class TypeDescriptorTest {

	public function TypeDescriptorTest() {
	}

	[Test]
	public function testGetTypeDescriptionForClass():void {
		assertTrue(TypeDescriptor.getTypeDescriptionForClass(EventDispatcher) is ITypeDescription);
	}

	[Test]
	public function testGetTypeDescriptionForClass_withTypeDescriptionKindDefault():void {
		var type:Class = (null != DescribeType.getJSONFunction() && TypeDescriptor.typeDescriptionKind == TypeDescriptionKind.JSON)
				? JSONTypeDescription
				: XMLTypeDescription;

		assertTrue(TypeDescriptor.getTypeDescriptionForClass(EventDispatcher) is type);
	}

	[Test]
	public function testGetTypeDescriptionForClass_withXMLTypeDescriptionKind():void {
		TypeDescriptor.typeDescriptionKind = TypeDescriptionKind.XML;

		assertTrue(TypeDescriptor.getTypeDescriptionForClass(EventDispatcher) is XMLTypeDescription);
	}

}
}
