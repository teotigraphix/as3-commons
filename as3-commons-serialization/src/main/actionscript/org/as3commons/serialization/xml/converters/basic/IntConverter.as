package org.as3commons.serialization.xml.converters.basic
{
	import org.as3commons.serialization.xml.converters.IConverter;
	
	public class IntConverter implements IConverter
	{
		public function canConvert(clazz:Class):Boolean{
			return clazz == int;	
		}
		
		public function fromXML(xml:XML,contextXML:XML):Object
		{
			return int(xml.toString());
		}
		
		public function toString(obj:Object):String
		{
			return obj.toString();
		}
		
	}
}