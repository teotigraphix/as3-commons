package org.as3commons.logging.util {
	import flash.utils.ByteArray;
	import flexunit.framework.TestCase;

	/**
	 * @author mh
	 */
	public class JsonXifyTest extends TestCase {
		
		public function testBasics():void {
			assertEquals('{data:"Hello World"}', jsonXify("Hello World") );
			assertEquals('{data:1}', jsonXify(1) );
			assertEquals('{data:["Hello","World",1]}', jsonXify(["Hello", "World", 1]) );
			assertEquals('{data:"<xml/>"}', jsonXify(<xml/>) );
			
			var test: ByteArray = new ByteArray();
			test.writeFloat(2.25);
			test.writeUTFBytes("muxasdasd");
			
			assertEquals('{data:"BASE64QBAAAG11eGFzZGFzZA=="}', jsonXify(test) );
			
			var obj: Object = {test:1};
			obj.test2 = obj;
			assertEquals('{id:1,"test2":{"$ref":1},"test":1}', jsonXify(obj) );
			
			var arr:Array = [];
			arr.push(arr);
			arr.push(1);
			assertEquals('{data:[[[[[["Depth exceeded."],1],1],1],1],1],1]}', jsonXify(arr) );
		}
	}
}
