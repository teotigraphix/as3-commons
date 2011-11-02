/*
 * Copyright 2007-2011 the original author or authors.
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
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.TypeCache;
	import org.as3commons.reflect.as3commons_reflect;

	/**
	 * Extension of <code>TypeCache</code> that adds a few extra functions that are
	 * enabled by the bytecode based reflection system.
	 * @author Roland Zwaga
	 */
	public final class ByteCodeTypeCache extends TypeCache {

		private var _metaDataLookup:Object;
		private var _interfaceLookup:Object;
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
			_interfaceLookup = {};
			_definitionNames = [];
		}

		override public function clear(applicationDomain:ApplicationDomain=null):void {
			super.clear(applicationDomain);
			initByteCodeTypeCache();
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
		 * <p><code>var classnames:Array = ByteCodeType.getTypeProvider().getTypeCache().getClassesWithMetadata('Mixin');</code></p>
		 */
		public function get metaDataLookup():Object {
			return _metaDataLookup;
		}

		/**
		 * A lookup of interface name -&gt; <code>Array</code> of class names.
		 * <p>For example, to retrieve all the names of classes that implement the com.interfaces.ITestInterface:</p>
		 * <p><code>var classnames:Array = ByteCodeType.getTypeProvider().getTypeCache().interfaceLookup['com.interfaces.ITestInterface'];</code></p>
		 */
		public function get interfaceLookup():Object {
			return _interfaceLookup;
		}

		/**
		 * @inheritDoc
		 */
		override public function get(key:String, applicationDomain:ApplicationDomain):Type {
			Assert.hasText(key, "argument 'key' cannot be empty");


			var type:Type = super.get(key, applicationDomain);
			if ((type != null) && (!type.as3commons_reflect::initialized)) {
				type.as3commons_reflect::initialize();
			}
			/* else if (type == null) {
				type = Type.forName(key);
			}
			if (type == null) {
				var func:Function = PlayerGlobalTypes.typeMethods[key];
				if (func != null) {
					type = func();
					cache[key] = type;
				}
			}*/
			return type;
		}

		/**
		 *
		 * @param metaDataName
		 * @param classname
		 *
		 */
		as3commons_reflect function addToMetadataCache(metaDataName:String, classname:String):void {
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
		public function getClassesWithMetadata(metaDataName:String):Array {
			Assert.hasText(metaDataName, "metaDataName argument must not be empty or null");
			metaDataName = metaDataName.toLowerCase();
			if (_metaDataLookup.hasOwnProperty(metaDataName)) {
				return _metaDataLookup[metaDataName] as Array;
			}
			return [];
		}

		/**
		 * Returns an <code>Array</code> of class names that implement the specified interface.
		 * @param intf The specified interface.
		 * @return an <code>Array</code> of class names.
		 */
		public function getImplementationNames(intf:Class):Array {
			Assert.notNull(intf, "intf argument must not be empty or null");
			var interfaceName:String = getQualifiedClassName(intf);
			interfaceName = AbcFileUtil.normalizeFullName(interfaceName);
			if (_interfaceLookup.hasOwnProperty(interfaceName)) {
				return _interfaceLookup[interfaceName] as Array;
			}
			return [];
		}

	}
}
