package org.as3commons.codec.serialization.utils
{
	
	public class TraitsInfo
	{
		public var type:String;
		public var isDynamic:Boolean;
		public var isExternalizable:Boolean;
		public var kind:Class;
		public var properties:Vector.<PropertyInfo>;
		
		public function TraitsInfo(type:String, isDynamic:Boolean = false, isExternalizable:Boolean = false)
		{
			this.type = type;
			this.isDynamic = isDynamic;
			this.isExternalizable = isExternalizable;
			
			properties = new Vector.<PropertyInfo>();
		}
		
		public function addProperty(name:String, info:TraitsInfo = null):void
		{
			properties.push(new PropertyInfo(name, info));
		}
	}
}