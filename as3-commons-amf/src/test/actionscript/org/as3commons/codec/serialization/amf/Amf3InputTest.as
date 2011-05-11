package org.as3commons.codec.serialization.amf
{
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	
	public class Amf3InputTest
	{
		private var amf3Data:ByteArray;
		private var amf3Input:AMF3Input;
		
		public function Amf3InputTest()
		{
		}
		
		[Before]
		public function setUp():void
		{
			amf3Data = new ByteArray();
			amf3Data.objectEncoding = ObjectEncoding.AMF3;
			
			amf3Input = new AMF3Input();
		}
		
		[After]
		public function tearDown():void
		{
			//amf3Data.clear();
			amf3Data = null;
			
			amf3Input.dispose();
			amf3Input = null;
		}
		
		protected function recycle(value:Object):void
		{
			amf3Data.writeObject(value);
			amf3Data.position = 0;
			amf3Input.load(amf3Data);
		}
		
		[Test]
		public function testReadDate():void
		{
			var date:Date = new Date();
			
			recycle(date);
			
			assertEquals(date.toString(), amf3Input.readObject().toString());
		}
		
		[Test]
		public function testReadString():void
		{
			var string:String = "Hello world!";
			
			recycle(string);
			
			assertEquals(string, amf3Input.readObject());
		}

		[Test]
		public function testReadXML():void
		{
			var xmlString:String = '<root><child property="foo"/></root>';
			var xml:XML = new XML(xmlString);
			
			recycle(xml);
			
			assertEquals(xml.toString(), amf3Input.readObject().toString());
		}
		
		[Test]
		public function testReadByteArray():void
		{
			var result:Object;
			var bytes:ByteArray;
			
			bytes = new ByteArray();
			bytes.writeObject({foo:123, bar:"boenk"});
			bytes.position = 0;
			
			recycle(bytes);
			
			result = amf3Input.readObject();
			
			assertTrue(result is ByteArray);
			assertEquals(bytes.length, ByteArray(result).length);
		}
		
		[Test]
		public function testReadSimpleArray():void
		{
			var array:Array = [{foo:123, bar:"boenk"}, new Date(), 123, "Hello", false, true, null, .6873628];
			var result:Array;
			
			recycle(array);
			
			result = amf3Input.readObject();
			
			assertEquals(array.length, result.length);
		}
		
		[Test]
		public function testReadComplex():void
		{
			var array:Array = [];
			var result:Array;
			
			for (var i:int = 0; i < 10; ++i)
				array.push(new Amf3TestObject());
			
			recycle(array);
			
			result = amf3Input.readObject();
			
			assertEquals(array.length, result.length);
			assertTrue(result[0] is Amf3TestObject);
		}
		
		[Test]
		public function testMedia():void
		{
			var data:Array = MediaLibrary.data;
			var result:Array;
			
			recycle(data);
			
			result = amf3Input.readObject();
			
			assertEquals(data.length, result.length);
			assertTrue(result[0] is Album);
			assertTrue(result[0].artist is Artist);
			assertTrue(result[0] === result[0].tracks[0].album);
			assertTrue(result[0].artist === result[0].tracks[0].artist);
		}
	}
}