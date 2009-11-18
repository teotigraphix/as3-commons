package org.as3commons.serialization.xml.converters.extended
{
	import com.dynamicflash.util.Base64;
	
	import flash.utils.ByteArray;
	
	import org.as3commons.serialization.xml.converters.IConverter;
	
	public class ByteArrayConverter implements IConverter
	{
		public function canConvert(clazz:Class):Boolean{
			return clazz == ByteArray;	
		}

		public function fromXML(xml:XML,contextXML:XML):Object
		{			
			return Base64.decodeToByteArray(xml.toString());			
		}
		
		public function toString(obj:Object):String{
			return Base64.encodeByteArray( obj as ByteArray );
		}	
		
	}
}