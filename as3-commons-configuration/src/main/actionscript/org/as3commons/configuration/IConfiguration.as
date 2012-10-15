/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.configuration {
	
	/**
	 *
	 * @author Roland Zwaga
	 */
	public interface IConfiguration {
		function subset(prefix:String):IConfiguration;
		
		function isEmpty():Boolean;
		
		function containsKey(key:String):Boolean;
		
		function addProperty(key:String, value:*):void;
		
		function setProperty(key:String, value:*):void;
		
		function clearProperty(key:String):void;
		
		function clear():void;
		
		function getProperty(key:String):*;
		
		function getKeysForPrefix(prefix:String):Vector.<String>;
		
		function getKeys():Vector.<String>;
		
		function getProperties(key:String):Vector.<Property>;
		
		function getBoolean(key:String):Boolean;
		
		function getBooleanOrDefault(key:String, defaultValue:Boolean):Boolean;
		
		function getByte(key:String):int;
		
		function getByteOrDefault(key:String, defaultValue:int):int;
		
		function getFloat(key:String):Number;
		
		function getFloatOrDefault(key:String, defaultValue:Number):Number;
		
		function getInt(key:String):int;
		
		function getIntOrDefault(key:String, defaultValue:int):int;
		
		function getString(key:String):String;
		
		function getStringOrDefault(key:String, defaultValue:String):String;
		
		function getList(key:String):Vector.<*>;
		
		function getListOrDefault(key:String, defaultValue:Vector.<*>):Vector.<*>;
		
	}
}