package org.as3commons.serialization.xml.converters.basic
{
	import org.as3commons.serialization.xml.converters.IConverter;

	public class DateConverter implements IConverter
	{
		public function DateConverter()
		{
		}

		public function canConvert(clazz:Class):Boolean
		{
			return clazz == Date;
		}
		
		public function fromXML(typeXML:XML, contextXML:XML):Object
		{
			return new Date(Number(typeXML));
		}
		
		public function toString(obj:Object):String
		{
			return obj.getTime().toString();
		}
		
	}
}