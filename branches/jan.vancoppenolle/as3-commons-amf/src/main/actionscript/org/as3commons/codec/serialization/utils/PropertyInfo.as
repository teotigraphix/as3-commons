package org.as3commons.codec.serialization.utils
{
	public class PropertyInfo
	{
		public var name:String;
		public var info:TraitsInfo;
		
		public function PropertyInfo(name:String, info:TraitsInfo = null)
		{
			this.name = name;
			this.info = info;
		}
	}
}