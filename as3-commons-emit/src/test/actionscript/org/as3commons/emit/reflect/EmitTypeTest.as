package org.as3commons.emit.reflect {
import flexunit.framework.Assert;

import org.as3commons.emit.reflect.objects.ReflectedObject;
import org.as3commons.emit.reflect.objects.SubReflectedObject;

public class EmitTypeTest {		
	
	[Before]
	public function setUp():void {
	}
	
	[After]
	public function tearDown():void {
	}
	
	[BeforeClass]
	public static function setUpBeforeClass():void {
	}
	
	[AfterClass]
	public static function tearDownAfterClass():void {
	}
	
	[Test]
	public function testForClass():void {
		var type:EmitType = EmitType.forClass(ReflectedObject);
		Assert.assertNotNull(type);
		Assert.assertEquals("org.as3commons.emit.reflect.objects:ReflectedObject", type.qname.toString());
	}
	
	[Test]
	public function testDeclaringType():void {
		var type:EmitType = EmitType.forClass(SubReflectedObject);
		Assert.assertNotNull(type);
		Assert.assertEquals(ReflectedObject, IEmitMember(type.getDeclaredProperty("name")).declaringType.clazz);
	}
}
}