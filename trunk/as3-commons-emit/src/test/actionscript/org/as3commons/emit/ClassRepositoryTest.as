package org.as3commons.emit {
import flash.events.Event;

import flexunit.framework.Assert;

import org.as3commons.emit.reflect.objects.ReflectedObject;
import org.flexunit.async.Async;


public class ClassRepositoryTest {		
	
	private static var repository:ClassRepository;
	
	[BeforeClass]
	public static function setUp():void {
		if(repository == null) {
			repository = new ClassRepository(new ClassGenerator());
		}
	}
	
	[Test(async, order="1")]
	public function testPrepare():void {
		Async.handleEvent(this, repository.prepare([ReflectedObject]), Event.COMPLETE, prepareComplete, 5000);
	}
	
	private function prepareComplete(event:Event, o:Object=null):void {
		Assert.assertTrue(repository.contains(ReflectedObject));
	}
	
	[Test(order="2")]
	public function testCreate():void {
		var object:Object = repository.create(ReflectedObject);
		
		Assert.assertNotNull(object);
		Assert.assertTrue(object is ReflectedObject);
		Assert.assertEquals("ReflectedObject", ReflectedObject(object).name);
		//Assert.assertEquals("", object.property);
	}
}
}