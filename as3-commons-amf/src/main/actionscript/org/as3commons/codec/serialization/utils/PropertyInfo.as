package org.as3commons.codec.serialization.utils
{
	public class PropertyInfo
	{
		public var name:String;
		public var traits:TraitsInfo;
		
		public function PropertyInfo(name:String, traits:TraitsInfo = null)
		{
			this.name = name;
			this.traits = traits;
		}
	}
}