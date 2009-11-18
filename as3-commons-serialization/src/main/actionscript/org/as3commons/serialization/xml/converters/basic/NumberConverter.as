package org.as3commons.serialization.xml.converters.basic
{
	import org.as3commons.serialization.xml.converters.IConverter;
	import org.as3commons.serialization.xml.converters.IConverter;
	
	public class NumberConverter implements IConverter
	{
		public function canConvert(clazz:Class):Boolean{
			return clazz == Number;	
		}
		
		public function fromXML(xml:XML,contextXML:XML):Object
		{
			return Number(xml.toString());
		}
		
		public function toString(obj:Object):String
		{
			return obj.toString();
		}
	}
}