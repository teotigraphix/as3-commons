package org.as3commons.serialization.xml.converters.basic
{
	import org.as3commons.serialization.xml.converters.IConverter;
	import org.as3commons.serialization.xml.core.XMLToAS;

	public class ArrayConverter implements IConverter
	{
		public function canConvert(clazz:Class):Boolean
		{
			return clazz == Array;
		}
		
		public function fromXML(typeXML:XML, contextXML:XML):Object
		{
			var array:Array=[];
			if ( typeXML.children().length() == 0 ) return array;
			
			for each ( var childXML:XML in typeXML.children() ){
				array.push( XMLToAS.objectFromXML( childXML, contextXML ) );
			}
			
			return array;
			
		}
		
		public function toString(obj:Object):String
		{
			//TODO
			return null;
		}
		
	}
}