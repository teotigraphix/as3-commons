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
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.AbstractTypeProvider;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.TypeCache;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public final class ByteCodeTypeProvider extends AbstractTypeProvider {

		private static var _currentApplicationDomain:ApplicationDomain;
		private static var _loaderInfos:Dictionary = new Dictionary(true);
		private static var _metaLookupByteArrays:Dictionary = new Dictionary(true);

		public function ByteCodeTypeProvider() {
			typeCache = new ByteCodeTypeCache();
			super();
		}

		public static function get currentApplicationDomain():ApplicationDomain {
			return _currentApplicationDomain;
		}

		override public function getType(cls:Class, applicationDomain:ApplicationDomain):Type {
			Assert.notNull(cls, "cls argument must not be null");
			return getTypeCache().get(ClassUtils.getFullyQualifiedName(cls, true), applicationDomain);
		}

		override public function clearCache():void {
			_loaderInfos = new Dictionary(true);
			_metaLookupByteArrays = new Dictionary(true);
			super.clearCache();
		}

		public function metaDataLookupFromLoader(loader:LoaderInfo):Object {
			Assert.notNull(loader, "loader argument must not be null");
			var loaderBytesPosition:uint = loader.bytes.position;
			if (hasProcessed(loader)) {
				return (getTypeCache() as ByteCodeTypeCache).metaDataLookup;
			}
			_loaderInfos[loader] = true;
			try {
				loader.bytes.position = 0;
				return metaDataLookupFromByteArray(loader.bytes);
			} finally {
				loader.bytes.position = loaderBytesPosition;
			}
			return null;
		}

		public function definitionNamesFromLoader(loader:LoaderInfo):Array {
			Assert.notNull(loader, "loader argument must not be null");
			if (hasProcessed(loader)) {
				return (getTypeCache() as ByteCodeTypeCache).definitionNames;
			}
			_loaderInfos[loader] = true;
			var loaderBytesPosition:uint = loader.bytes.position;
			try {
				loader.bytes.position = 0;
				return definitionNamesFromByteArray(loader.bytes);
			} finally {
				loader.bytes.position = loaderBytesPosition;
			}
			return null;
		}

		public function metaDataLookupFromByteArray(input:ByteArray):Object {
			Assert.notNull(input, "input argument must not be null");
			deserializeMetadata(input);
			return (getTypeCache() as ByteCodeTypeCache).metaDataLookup;
		}

		public function definitionNamesFromByteArray(input:ByteArray):Array {
			Assert.notNull(input, "input argument must not be null");
			deserializeMetadata(input);
			return (getTypeCache() as ByteCodeTypeCache).definitionNames;
		}

		protected function deserializeMetadata(input:ByteArray):void {
			if (_metaLookupByteArrays[input] == null) {
				_metaLookupByteArrays[input] = true;
				var deserializer:ClassMetadataDeserializer = new ClassMetadataDeserializer();
				deserializer.read(getTypeCache() as ByteCodeTypeCache, input);
			}
		}

		public function fromLoader(loader:LoaderInfo, applicationDomain:ApplicationDomain=null):void {
			Assert.notNull(loader, "loader argument must not be null");
			if (hasProcessed(loader)) {
				return;
			}
			_loaderInfos[loader] = true;
			var loaderBytesPosition:uint = loader.bytes.position;
			try {
				loader.bytes.position = 0;
				fromByteArray(loader.bytes, applicationDomain);
			} finally {
				loader.bytes.position = loaderBytesPosition;
			}
		}

		public function fromByteArray(input:ByteArray, applicationDomain:ApplicationDomain=null, isLoaderBytes:Boolean=true):void {
			Assert.notNull(input, "input argument must not be null");
			applicationDomain = getApplicationDomain(applicationDomain, isLoaderBytes);
			var initialPosition:int = input.position;
			try {
				var deserializer:ReflectionDeserializer = new ReflectionDeserializer();
				deserializer.read(getTypeCache() as ByteCodeTypeCache, input, applicationDomain, isLoaderBytes);
			} catch (e:Error) {
				throw e;
			} finally {
				input.position = initialPosition;
			}
		}

		protected function getApplicationDomain(applicationDomain:ApplicationDomain, isLoaderBytes:Boolean=true):ApplicationDomain {
			if ((_currentApplicationDomain == null) && (!isLoaderBytes)) {
				_currentApplicationDomain = Type.currentApplicationDomain;
			} else {
				applicationDomain ||= Type.currentApplicationDomain;
			}
			return applicationDomain;
		}

		public function hasProcessed(loader:LoaderInfo):Boolean {
			return (_loaderInfos[loader] != null);
		}

	}
}
