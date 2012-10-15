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
package org.as3commons.configuration.impl {

	import avmplus.getQualifiedClassName;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.as3commons.configuration.IConfiguration;
	import org.as3commons.configuration.Property;
	import org.as3commons.configuration.error.ConversionError;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class Configuration implements IConfiguration {
		
		private var _properties:Object;
		private var _subsets:Object;
		private var _vectorClass:Class;
		private var _conversionMethods:Dictionary;
		
		/**
		 * Creates a new <code>Configuration</code> instance.
		 */
		public function Configuration() {
			super();
			_vectorClass = Object(new Vector.<*>()).constructor as Class;
			_conversionMethods = new Dictionary();
			_conversionMethods[Boolean] = parseBoolean;
			_conversionMethods[int] = parseInteger;
			_conversionMethods[Number] = parseNumber;
			clear();
		}

		public function subset(prefix:String):IConfiguration {
			return _subsets[prefix];
		}

		public function isEmpty():Boolean {
			var key:String;
			for(key in _properties) {
				return false;
			}
			for(key in _subsets) {
				return false;
			}
			return true;
		}

		public function containsKey(key:String):Boolean {
			return (key in _properties);
		}

		public function addProperty(key:String, value:*):void {
			if (containsKey(key)) {
				var currentValue:* = getProperty(key);
				var vector:Vector.<*>;
				if (currentValue is _vectorClass){
					vector = currentValue;
				} else {
					vector = new Vector.<*>();
					vector[vector.length] = currentValue;
				}
import avmplus.getQualifiedClassName;

import flash.system.ApplicationDomain;

				vector[vector.length] = value;
				_properties[key] = vector;
			}
		}

		public function setProperty(key:String, value:*):void {
			_properties[key] = value;
		}

		public function clearProperty(key:String):void {
			delete _properties[key];
		}

		public function clear():void {
			_properties = createLookupInstance();
			_subsets = createLookupInstance();
		}

		public function getProperty(key:String):* {
			return _properties[key];
		}

		public function getKeysForPrefix(prefix:String):Vector.<String> {
			var config:IConfiguration = _subsets[prefix];
			if (config != null) {
				return config.getKeys();
			}
			return null;
		}
		
		public function getKeys():Vector.<String> {
			if (!isEmpty()) {
				var result:Vector.<String> = new Vector.<String>();
				for(var name:String in _properties) {
					result[result.length] = name;
				}
				return result;
			} else {
				return null;
			}
		}

		public function getProperties(key:String):Vector.<Property> {
			if (!isEmpty()) {
				var result:Vector.<Property> = new Vector.<Property>();
				for(var name:String in _properties) {
					result[result.length] = new Property(name, _properties[name]);
				}
				return result;
			} else {
				return null;
			}
		}

		public function getBoolean(key:String):Boolean {
			return returnTyped(getProperty(key), Boolean);
		}
		
		private function returnTyped(value:*, clazz:Class):* {
			if (value is clazz) {
				return value;
			} else {
				var conversionFunc:Function = _conversionMethods[clazz];
				if (conversionFunc != null) {
					return conversionFunc(value);
				} else {
					var valueClass:Class;
					try {
						valueClass = Object(value).constructor as Class;
					} catch(e:Error) {
						valueClass = ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(value)) as Class;
					}
					throw new ConversionError(clazz, valueClass);
				}
			}
		}

		public function getBooleanOrDefault(key:String, defaultValue:Boolean):Boolean {
			return (containsKey(key)) ? getBoolean(key) : defaultValue;
		}

		public function getByte(key:String):int {
			return returnTyped(getProperty(key), int);
		}

		public function getByteOrDefault(key:String, defaultValue:int):int {
			return (containsKey(key)) ? getByte(key) : defaultValue;
		}

		public function getFloat(key:String):Number {
			return returnTyped(getProperty(key), Number);
		}

		public function getFloatOrDefault(key:String, defaultValue:Number):Number {
			return (containsKey(key)) ? getFloat(key) : defaultValue;
		}

		public function getInt(key:String):int {
			return returnTyped(getProperty(key), int);
		}

		public function getIntOrDefault(key:String, defaultValue:int):int {
			return (containsKey(key)) ? getInt(key) : defaultValue;
		}

		public function getString(key:String):String {
			return returnTyped(getProperty(key), String);
		}

		public function getStringOrDefault(key:String, defaultValue:String):String {
			return (containsKey(key)) ? getString(key) : defaultValue;
		}

		public function getList(key:String):Vector.<*> {
			return returnTyped(getProperty(key), _vectorClass);
		}

		public function getListOrDefault(key:String, defaultValue:Vector.<*>):Vector.<*> {
			return (containsKey(key)) ? getList(key) : defaultValue;
		}

		private static function createLookupInstance():Object {
			var result:Object = {};
			delete result["prototype"];
			return result;
		}
		
		private function parseBoolean(input:String):Boolean {
			input &&= input.toLowerCase();
			return (input === "true");
		}

		private function parseInteger(input:String):int {
			return parseInt(input) as int;
		}

		private function parseNumber(input:String):Number {
			return parseFloat(input);
		}
	}
}
