package org.as3commons.serialization.xml.converters
{
	public interface IConverter
	{
		function canConvert(clazz:Class):Boolean;
		function fromXML(typeXML:XML,contextXML:XML):Object;
		function toString(obj:Object):String;
	}
}