/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.reflect {
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.TypeCache;
	import org.as3commons.reflect.as3commons_reflect;

	public class ByteCodeTypeCache extends TypeCache {

		private var _metaDataLookup:Object;
		private var _definitionNames:Array;

		public function ByteCodeTypeCache() {
			super();
			_metaDataLookup = {};
			_definitionNames = [];
		}


		public function get definitionNames():Array {
			return _definitionNames;
		}

		public function get metaDataLookup():Object {
			return _metaDataLookup;
		}

		override public function get(key:String):Type {
			Assert.hasText(key, "argument 'key' cannot be empty");

			var type:Type = cache[key];
			if ((type != null) && (!type.as3commons_reflect::initialized)) {
				type.as3commons_reflect::initialize();
			} else if (type == null) {
				return Type.forName(key);
			}
			return type;
		}

		as3commons_reflect function addToMetaDataCache(metaDataName:String, classname:String):void {
			Assert.hasText(metaDataName, "metaDataName argument must not be empty or null");
			Assert.hasText(classname, "classname argument must not be empty or null");
			if (!_metaDataLookup.hasOwnProperty(metaDataName)) {
				_metaDataLookup[metaDataName] = [];
			}
			var arr:Array = _metaDataLookup[metaDataName];
			if (arr.indexOf(classname) < 0) {
				arr[arr.length] = classname;
			}
		}

		as3commons_reflect function addDefinitionName(className:String):void {
			if (_definitionNames.indexOf(className) < 0) {
				_definitionNames[_definitionNames.length] = className;
			}
		}

		public function getClassesWithMetaData(metaDataName:String):Array {
			Assert.hasText(metaDataName, "metaDataName argument must not be empty or null");
			if (_metaDataLookup.hasOwnProperty(metaDataName)) {
				return _metaDataLookup[metaDataName];
			}
			return [];
		}

	}
}