package org.as3commons.serialization.xml.converters.basic
{
	import org.as3commons.serialization.xml.converters.IConverter;
	
	public class BooleanConverter implements IConverter
	{
		public function canConvert(clazz:Class):Boolean{
			return clazz == Boolean;
		}
		
		public function fromXML(xml:XML,contextXML:XML):Object
		{
			return xml.toString() == "true" ? true : false;
		}
		
		public function toString(obj:Object):String
		{
			return obj.toString();
		}
		
	}
}