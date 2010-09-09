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

	/**
	 * Extension of <code>TypeCache</code> that adds a few extra functions that are
	 * enabled by the bytecode based reflection system.
	 * @author Roland Zwaga
	 */
	public class ByteCodeTypeCache extends TypeCache {

		private var _metaDataLookup:Object;
		private var _definitionNames:Array;

		/**
		 * Creates a new <code>ByteCodeTypeCache</code> instance.
		 *
		 */
		public function ByteCodeTypeCache() {
			super();
			initByteCodeTypeCache();
		}

		protected function initByteCodeTypeCache():void {
			_metaDataLookup = {};
			_definitionNames = [];
		}

		/**
		 * List of all fully qualified definition names that have been encountered in all
		 * the bytecode that was scanned.
		 */
		public function get definitionNames():Array {
			return _definitionNames.concat();
		}

		/**
		 * A lookup of metadata name -&gt; <code>Array</code> of class names.
		 * <p>For example, to retrieve all the names of classes that are annotated with the [Mixin] metadata:</p>
		 * <p>var classnames:Array = ByteCodeType.getTypeProvider().getTypeCache().getClassesWithMetaData('Mixin');</p>
		 */
		public function get metaDataLookup():Object {
			return _metaDataLookup;
		}

		/**
		 * @inheritDoc
		 */
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

		/**
		 *
		 * @param metaDataName
		 * @param classname
		 *
		 */
		as3commons_reflect function addToMetaDataCache(metaDataName:String, classname:String):void {
			Assert.hasText(metaDataName, "metaDataName argument must not be empty or null");
			Assert.hasText(classname, "classname argument must not be empty or null");
			metaDataName = metaDataName.toLowerCase();
			if (!_metaDataLookup.hasOwnProperty(metaDataName)) {
				_metaDataLookup[metaDataName] = [];
			}
			var arr:Array = _metaDataLookup[metaDataName] as Array;
			if (arr.indexOf(classname) < 0) {
				arr[arr.length] = classname;
			}
		}

		/**
		 *
		 * @param className
		 *
		 */
		as3commons_reflect function addDefinitionName(className:String):void {
			if (_definitionNames.indexOf(className) < 0) {
				_definitionNames[_definitionNames.length] = className;
			}
		}

		/**
		 * Returns an <code>Array</code> of class names that have been annotated with the specified metadata name.
		 * @param metaDataName The specified metadata name.
		 * @return an <code>Array</code> of class names.
		 */
		public function getClassesWithMetaData(metaDataName:String):Array {
			Assert.hasText(metaDataName, "metaDataName argument must not be empty or null");
			metaDataName = metaDataName.toLowerCase();
			if (_metaDataLookup.hasOwnProperty(metaDataName)) {
				return _metaDataLookup[metaDataName] as Array;
			}
			return [];
		}

	}
}