package org.as3commons.serialization.xml.converters.basic
{
	import org.as3commons.lang.StringUtils;
	import org.as3commons.serialization.xml.converters.IConverter;
	
	public class UintConverter implements IConverter
	{
		public function canConvert(clazz:Class):Boolean{
			return clazz == uint;	
		}
		
		public function fromXML(xml:XML,contextXML:XML):Object
		{
			var stringValue:String = xml.toString();
			if ( stringValue.indexOf("#") == 0 ) {
				stringValue = "0x"+stringValue.substr(1,stringValue.length);
			}
			
			return uint( stringValue );
			
		}
		
		public function toString(obj:Object):String{
			return "0x"+StringUtils.rightPadChar(uint(obj).toString(16).toUpperCase(),6,"0");
		}
		
	}
}