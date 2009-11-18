package org.as3commons.serialization.xml.core
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.as3commons.serialization.xml.ConverterRegistery;
	import org.as3commons.serialization.xml.XMLConverter;
	import org.as3commons.serialization.xml.converters.IConverter;
	import org.as3commons.serialization.xml.mapper.Mapper;

	public class XMLToAS
	{
		
		public static function objectFromXML(xml:XML,contextXML:XML,returnType:Class=null):*{
			
			var returnTypeString:String;
			
			//First try reflection
			returnTypeString = Mapper.resolveTypeFromAlias( xml.name() );
			
			if ( ! returnTypeString ){
				
				//Fall back to String value interpretation
				returnTypeString = Mapper.resolveNativeTypeFromStringValue( xml.valueOf() );
			
			}	
			
			//Find converter for return type
			var converter:IConverter = ConverterRegistery.getConverterForType( returnTypeString );
			
			//Use converter to convert XML
			var obj:Object = converter.fromXML(xml,contextXML);
			
			//var obj:Object = new returnType();					
			return obj;
				
		}
		
		private static function addMetadataToProperty(obj:Object,propertyName:String,newArg:MetaDataArgument):void{
			
			var type:Type = Type.forInstance(obj);
			
			for each ( var variable:Variable in type.variables ){
				
				if ( variable.name == propertyName && variable.hasMetaData("X2A") ){
					
					//If it already has some X2A metadata, see if it already has this particular MetaDataArgument			
					var metadata:MetaData = variable.getMetaData("X2A")[0];
					if ( metadata.hasArgumentWithKey(newArg.key) ) return;			
										
					variable.addMetaData( new MetaData("X2A", [newArg] ) );
					return;
					
				}
			}
			
		}
		
		
		//Load and parse functions
		
		private static var _urlLoader:URLLoader;
		private static var _request:URLRequest;
		private static var _callbackFunction:Function;
		
		public static function loadAndParse(url:String,callbackFunction:Function):void{
			
			_callbackFunction = callbackFunction;
			
			_urlLoader = new URLLoader();			
			_urlLoader.addEventListener(Event.COMPLETE, loadSuccessHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadFailHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailHandler);
			
			_urlLoader.load( new URLRequest(url) );
			
		}
		
		private static function loadSuccessHandler(event:Event):void{
			
			var xml:XML = new XML( event.target.data );
			var xstream:XMLConverter = new XMLConverter();		
			var obj:Object = xstream.fromXML(xml);	
			_callbackFunction( obj );
			
			cleanUpLoad();
			
		}
		
		private static function loadFailHandler():void{
			cleanUpLoad();
			trace("XMLToAS could not load data from "+_request.url)
		}
		
		private static function cleanUpLoad():void{
			
			_urlLoader.removeEventListener(Event.COMPLETE, loadSuccessHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loadFailHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailHandler);
			
			_request = null;
			_callbackFunction = null;
			_urlLoader = null;
			
		}	
			
	}
}