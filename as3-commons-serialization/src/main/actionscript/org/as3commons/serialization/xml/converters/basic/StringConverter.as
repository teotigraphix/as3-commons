package org.as3commons.serialization.xml.converters.basic
{
	import org.as3commons.serialization.xml.converters.IConverter;
	import org.as3commons.serialization.xml.converters.IConverter;
	
	public class StringConverter implements IConverter
	{
		public function canConvert(clazz:Class):Boolean{
			return clazz == String;	
		}
		
		public function fromXML(xml:XML,contextXML:XML):Object
		{
			return xml.toString();
		}
		
		public function toString(obj:Object):String
		{
			return obj.toString();
		}
	}
}