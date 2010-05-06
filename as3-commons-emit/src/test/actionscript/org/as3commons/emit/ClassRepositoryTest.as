package org.as3commons.emit {
import flash.events.IEventDispatcher;

import flexunit.framework.Assert;

import org.as3commons.emit.reflect.objects.ReflectedObject;


public class ClassRepositoryTest {		
	
	[Before]
	public function setUp():void {
	}
	
	[After]
	public function tearDown():void {
	}
	
	[Test]
	public function testPrepare():void {
		var repo:ClassRepository = new ClassRepository(new ClassGenerator());
		var dispatcher:IEventDispatcher = repo.prepare([ReflectedObject]);
		
		Assert.assertNotNull(dispatcher);
	}
}
}
import org.as3commons.emit.IClassGenerator;
import org.as3commons.emit.bytecode.DynamicClass;
import org.as3commons.emit.reflect.EmitType;

class ClassGenerator implements IClassGenerator {
	
	public function createClass(type:EmitType):DynamicClass {
		
		return new DynamicClass(type.qname, type, []);
	}
}