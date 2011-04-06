package org.as3commons.codec.serialization.amf
{
	import mx.utils.UIDUtil;
	
	[RemoteClass(alias="be.idamf.flash.amf.Amf3TestObject")]
	public class Amf3TestObject
	{
		public var uid:String = UIDUtil.createUID();
		public var date:Date = new Date();
		public var list:Array = [1, 2, 3];
		public var map:Object = {a:"foo", b:"bar", c:666};
		
		public function Amf3TestObject()
		{
		}
	}
}