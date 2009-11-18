/*
 * Copyright 2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.serialization.xml
{
	import flash.net.getClassByAlias;
	
	import org.as3commons.serialization.xml.converters.basic.*;
	import org.as3commons.serialization.xml.converters.extended.ByteArrayConverter;
	import org.as3commons.serialization.xml.core.*;
	
	public class XMLConverter
	{
		//identifier prepended to class alias identifier prevent any possible conflict with AMF types registered with same name as XML node
		public static const X2A:String="X2A_";
		
		/**
		 * 
		 * @param nodeName Name of XML node. For example, for <book/> node, use "book". Case sensitive.
		 * @param type Class to map XML values to. Be sure to register Aliases for all child types.
		 * 
		 */		
		public static function register(nodeName:String,type:Class):void{
			flash.net.registerClassAlias(X2A+nodeName,type);
		}
		
		public static function getClassByAlias(alias:String):Class{		
			
			try {
				return flash.net.getClassByAlias( X2A+alias);
			} catch (e:Error){
				//TODO: Remove try/catch
			}
			
			return null;
		}
		
		public function XMLConverter()
		{	
			
			//Register native type converters
			ConverterRegistery.registerConverter(ArrayConverter,"Array",.5);
			ConverterRegistery.registerConverter(BooleanConverter,"Boolean",.5);
			ConverterRegistery.registerConverter(IntConverter,"int",.5);
			ConverterRegistery.registerConverter(NumberConverter,"Number",.5);
			ConverterRegistery.registerConverter(StringConverter,"String",.5);
			ConverterRegistery.registerConverter(UintConverter,"uint",.5);
			
			//Register reflective converters
			ConverterRegistery.registerConverter(ReflectionConverter,"*",.2);
			
			//Register extended types
			ConverterRegistery.registerConverter(ByteArrayConverter,"flash.utils.ByteArray",.5);
			
		}
		
		public function fromXML(xml:XML,returnType:Class=null):*{		
			return XMLToAS.objectFromXML(xml,xml,returnType);		
		}
		
		public function toXML(obj:Object):XML{			
			return ASToXML.xmlFromObject(obj);
		}
		
		public function arrayToXML(array:Array,nodeName:String):XML{
			return ASToXML.xmlFromArray(array,nodeName);
		}
		
		public function alias(nodeName:String,type:Class):void{
			XMLConverter.register(nodeName,type);
		}	

	}
}