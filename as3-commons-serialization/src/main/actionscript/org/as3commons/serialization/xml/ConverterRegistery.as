package org.as3commons.serialization.xml
{
	import flash.utils.getDefinitionByName;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.serialization.xml.converters.IConverter;
	
	
	public class ConverterRegistery
	{
		private static var _converters:Array=[];
		
		public static function registerConverter(converter:Class,type:String,priority:Number=.5):void{
			
			if ( hasConverterForTypeName(type) ){
				trace("Converter already registered with this type: "+type);
				return;
			}
			
			var converterInstance:IConverter = new converter();
			var entry:Entry = new Entry(type,converterInstance,priority);		
			
			_converters.push( entry );
			_converters.sortOn("priority",Array.DESCENDING);
			
		}
		
		public static function getConverterForType(type:String):IConverter{
			
			var entry:Entry;
			
			for each ( entry in _converters ){
				if ( entry.type == type ){
					return entry.converter;
				}
			}
			
			var clazz:Class = getDefinitionByName( type ) as Class;
			if ( ! clazz ) return null;
			
			for each ( entry in _converters ){
				if ( entry.converter.canConvert(clazz) ){
					return entry.converter;
				}
			}
			
			
			return null;
		}
		
		public static function hasConverterForType(type:String):Boolean{
			
			if ( hasConverterForTypeName(type) ){
				return true;
			}
			
			var clazz:Class = ClassUtils.forName( type );
			if ( ! clazz ) return false;
			
			return hasConverterForClass( clazz );
			
		}
		
		protected static function hasConverterForTypeName(type:String):Boolean{
			
			for each ( var entry:Entry in _converters ){
				if ( entry.type == type ){
					return true;
				}
			}
			
			return false;
			
		}
		
		protected static function hasConverterForClass(clazz:Class):Boolean{
			
			for each ( var entry:Entry in _converters ){
				if ( entry.converter.canConvert(clazz) ){
					return true;
				}
			}
			
			return false;
			
		}
		
	}
}

import org.as3commons.serialization.xml.converters.IConverter;	

class Entry {
	
	public function Entry(type:String,converter:IConverter,priority:Number){
		this.type=type;
		this.priority=priority;
		this.converter=converter;
	}
	
	public var type:String;
	public var converter:IConverter;
	public var priority:Number;

}