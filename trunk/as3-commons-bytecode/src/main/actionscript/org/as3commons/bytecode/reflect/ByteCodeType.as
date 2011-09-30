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
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.SoftReference;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constant;
	import org.as3commons.reflect.ITypeProvider;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.as3commons.reflect.as3commons_reflect;

	public class ByteCodeType extends Type {
		private static const FLASH_NATIVE_PACKAGE_PREFIX:String = 'flash.';
		private static const nativeClassNames:Dictionary = new Dictionary();

		private static var typeProvider:ITypeProvider;

		/**
		 * Retrieves a list of all class names found in the specified <code>ByteArray</code>.
		 * @param input The <code>ByteArray</code> will be used to generate the classname <code>Array</code>.
		 * @return A list of all class names found in the specified <code>ByteArray</code>.
		 */
		public static function definitionNamesFromByteArray(input:ByteArray):Array {
			Assert.notNull(input, "input argument must not be null");
			return (getTypeProvider() as ByteCodeTypeProvider).definitionNamesFromByteArray(input);
		}

		/**
		 * Retrieves a list of all class names found in the specified <code>LoaderInfo</code>.
		 * @param loader The loader whose bytecode will be used to generate the classname <code>Array</code>.
		 * @return A list of all class names found in the specified <code>ByteArray</code>.
		 */
		public static function definitionNamesFromLoader(loader:LoaderInfo):Array {
			Assert.notNull(loader, "loader argument must not be null");
			return (getTypeProvider() as ByteCodeTypeProvider).definitionNamesFromLoader(loader);
		}

		/**
		 * Returns a <code>ByteCodeType</code> object that describes the given class.
		 * @param clazz the class from which to get a type description
		 */
		public static function forClass(clazz:Class, applicationDomain:ApplicationDomain=null):ByteCodeType {
			applicationDomain ||= Type.currentApplicationDomain;
			var result:ByteCodeType;
			var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(clazz, true);
			var type:ByteCodeType = forName(fullyQualifiedClassName, applicationDomain);
			if ((type != null) && (type.clazz == null)) {
				type.clazz = clazz;
			}
			return type;
		}

		/**
		 * Returns a <code>ByteCodeType</code> object that describes the given instance.
		 * @param instance the instance from which to get a type description
		 */
		public static function forInstance(instance:*, applicationDomain:ApplicationDomain=null):ByteCodeType {
			applicationDomain ||= Type.currentApplicationDomain;
			var result:ByteCodeType = null;
			var clazz:Class = ClassUtils.forInstance(instance, applicationDomain);

			if (clazz != null) {
				result = ByteCodeType.forClass(clazz, applicationDomain);
			}

			return result;
		}

		/**
		 * Returns a <code>ByteCodeType</code> object that describes the given classname.
		 *
		 * @param name the classname from which to get a type description
		 */
		public static function forName(name:String, applicationDomain:ApplicationDomain=null):ByteCodeType {
			applicationDomain ||= Type.currentApplicationDomain;
			var result:ByteCodeType;

			name = AbcFileUtil.normalizeFullName(name);

			result = getTypeProvider().getTypeCache().get(name, applicationDomain) as ByteCodeType;
			if ((result == null) && (isNativeName(name))) {
				result = PlayerGlobalData.forName(name);
				if (result != null) {
					getTypeProvider().getTypeCache().put(name, result, applicationDomain);
				}
			}

			return result;
		}

		/**
		 * Generates <code>ByteCodeType</code> instances for all classes found in the specified <code>ByteArray</code>.
		 * @param input The specified <code>ByteArray</code>.
		 * @param applicationDomain The <code>ApplicationDomain</code> that is associated with the specified <code>ByteArray</code>.
		 */
		public static function fromByteArray(input:ByteArray, applicationDomain:ApplicationDomain=null, isLoaderBytes:Boolean=true):void {
			Assert.notNull(input, "input argument must not be null");
			applicationDomain ||= Type.currentApplicationDomain;
			(getTypeProvider() as ByteCodeTypeProvider).fromByteArray(input, applicationDomain, isLoaderBytes);
		}

		/**
		 * Generates <code>ByteCodeType</code> instances for all classes found in the specified <code>LoaderInfo</code>'s
		 * bytecode.
		 * @param loader The specified <code>LoaderInfo</code>.
		 */
		public static function fromLoader(loader:LoaderInfo):void {
			Assert.notNull(loader, "loader argument must not be null");
			var loaderBytesPosition:uint = loader.bytes.position;
			try {
				loader.bytes.position = 0;
				(getTypeProvider() as ByteCodeTypeProvider).fromByteArray(loader.bytes, loader.applicationDomain);
			} finally {
				loader.bytes.position = loaderBytesPosition;
			}
		}

		/**
		 * Returns the <code>ByteCodeTypeCache</code> that contains all the <code>ByteCodeType</code> instances
		 * that have been extracted.
		 */
		public static function getCache():ByteCodeTypeCache {
			return getTypeProvider().getTypeCache() as ByteCodeTypeCache;
		}

		/**
		 * Returns an <code>Array</code> of class names that have been annotated with the specified metadata name.
		 * @param metaDataName The specified metadata name.
		 * @return an <code>Array</code> of class names.
		 */
		public static function getClassesWithMetadata(metaDataName:String):Array {
			return getCache().getClassesWithMetadata(metaDataName);
		}

		/**
		 * Returns an <code>Array</code> of class names that implement the specified interface.
		 * @param intf The specified interface.
		 * @return an <code>Array</code> of class names.
		 */
		public static function getImplementationNames(intf:Class):Array {
			return getCache().getImplementationNames(intf);
		}

		public static function getTypeProvider():ITypeProvider {
			if (typeProvider == null) {
				typeProvider = new ByteCodeTypeProvider();
			}
			return typeProvider;
		}

		public static function isNativeName(name:String):Boolean {
			return ( //
				(StringUtils.startsWith(name, FLASH_NATIVE_PACKAGE_PREFIX)) || //
				(nativeClassNames[name] == true) || //
				(StringUtils.startsWith(name, '__AS3__.')) //
				);
		}

		/**
		 * Generates a lookup of metadata name -&gt; <code>Array</code> of class names.
		 * @param input The <code>ByteArray</code> will be used to generate the lookup
		 * @return A lookup of metadata name -&gt; <code>Array</code> of class names.
		 */
		public static function metaDataLookupFromByteArray(input:ByteArray):Object {
			Assert.notNull(input, "input argument must not be null");
			return (getTypeProvider() as ByteCodeTypeProvider).metaDataLookupFromByteArray(input);
		}

		/**
		 * Generates a lookup of metadata name -&gt; <code>Array</code> of class names.
		 * @param loader The loader whose bytecode will be used to generate the lookup
		 * @return A lookup of metadata name -&gt; <code>Array</code> of class names.
		 */
		public static function metaDataLookupFromLoader(loader:LoaderInfo):Object {
			Assert.notNull(loader, "loader argument must not be null");
			return (getTypeProvider() as ByteCodeTypeProvider).metaDataLookupFromLoader(loader);
		}

		{
			nativeClassNames['Object'] = true;
			nativeClassNames['Function'] = true;
			nativeClassNames['RegExp'] = true;
			nativeClassNames['Array'] = true;
			nativeClassNames['Error'] = true;
			nativeClassNames['DefinitionError'] = true;
			nativeClassNames['EvalError'] = true;
			nativeClassNames['RangeError'] = true;
			nativeClassNames['ReferenceError'] = true;
			nativeClassNames['SecurityError'] = true;
			nativeClassNames['SyntaxError'] = true;
			nativeClassNames['TypeError'] = true;
			nativeClassNames['URIError'] = true;
			nativeClassNames['VerifyError'] = true;
			nativeClassNames['UninitializedError'] = true;
			nativeClassNames['ArgumentError'] = true;
		}

		public function ByteCodeType(applicationDomain:ApplicationDomain, byteArray:ByteArray=null, constantPool:IConstantPool=null) {
			super(applicationDomain);
			_byteArray = byteArray;
			_constantPool = constantPool;
		}

		private var _byteArray:ByteArray;
		private var _constantPool:IConstantPool;

		private var _initialized:Boolean = false;

		private var _instanceConstructor:ByteCodeMethod;

		private var _isNative:Boolean = false;

		private var _isProtected:Boolean;

		private var _isSealed:Boolean;

		private var _namespaceName:String = "";

		private var _protectedNamespace:String = "";

		private var _staticConstructor:ByteCodeMethod;

		public function get byteArray():ByteArray {
			return _byteArray;
		}

		override public function get clazz():Class {
			if (super.clazz == null) {
				try {
					clazz = ClassUtils.forName(fullName, applicationDomain);
				} catch (e:*) {
					clazz = null;
				}
			}
			return super.clazz;
		}

		public function get constantPool():IConstantPool {
			return _constantPool;
		}

		/**
		 * List of all fully qualified definition names that have been encountered in all
		 * the bytecode that was scanned.
		 */
		public static function get definitionNames():Array {
			return getCache().definitionNames;
		}

		as3commons_reflect function get initialized():Boolean {
			return _initialized;
		}

		public function get instanceConstructor():ByteCodeMethod {
			return _instanceConstructor;
		}

		/**
		 * A lookup of interface name -&gt; <code>Array</code> of class names.
		 * <p>For example, to retrieve all the names of classes that implement the com.interfaces.ITestInterface:</p>
		 * <p>var classnames:Array = ByteCodeType.getTypeProvider().getTypeCache().interfaceLookup['com.interfaces.ITestInterface'];</p>
		 */
		public static function get interfaceLookup():Object {
			return getCache().interfaceLookup;
		}

		public function get isNative():Boolean {
			return _isNative;
		}

		public function get isProtected():Boolean {
			return _isProtected;
		}

		public function get isSealed():Boolean {
			return _isSealed;
		}

		/**
		 * A lookup of metadata name -&gt; <code>Array</code> of class names.
		 * <p>For example, to retrieve all the names of classes that are annotated with the [Mixin] metadata:</p>
		 * <p>var classnames:Array = ByteCodeType.getClassesWithMetadata('Mixin');</p>
		 */
		public static function get metaDataLookup():Object {
			return getCache().metaDataLookup;
		}

		public function get namespaceName():String {
			return _namespaceName;
		}

		public function get protectedNamespace():String {
			return _protectedNamespace;
		}

		public function get staticConstructor():ByteCodeMethod {
			return _staticConstructor;
		}

		protected function objectExists(objectToCheck:Object, members:Array):Boolean {
			for each (var obj:Object in members) {
				if ((obj.name == objectToCheck.name) && (obj.namespaceURI == objectToCheck.namespaceURI)) {
					return true;
				}
			}
			return false;
		}

		as3commons_reflect function initialize():void {
			_initialized = true;
			if (extendsClasses.length > 0) {
				var tempMethods:Array = methods;
				var parentType:ByteCodeType = forName(this.extendsClasses[0], this.applicationDomain);
				if (parentType != null) {
					for each (var method:ByteCodeMethod in parentType.methods) {
						if (!objectExists(method, tempMethods)) {
							tempMethods[tempMethods.length] = method;
						}
					}
					for each (var variable:ByteCodeVariable in parentType.variables) {
						if (!objectExists(variable, variables)) {
							this.variables[this.variables.length] = variable;
						}
					}
					for each (var acc:ByteCodeAccessor in parentType.accessors) {
						if (!objectExists(acc, accessors)) {
							this.accessors[this.accessors.length] = acc;
						}
					}
					for each (var constant:ByteCodeConstant in parentType.constants) {
						this.constants[this.constants.length] = constant;
					}
					this.methods = tempMethods;
					this.createMetadataLookup();
				}
			}
		}

		as3commons_reflect function setInstanceConstructor(value:ByteCodeMethod):void {
			_instanceConstructor = value;
		}

		as3commons_reflect function setIsNative(value:Boolean):void {
			_isNative = value;
		}

		as3commons_reflect function setIsProtected(value:Boolean):void {
			_isProtected = value;
		}

		as3commons_reflect function setIsSealed(value:Boolean):void {
			_isSealed = value;
		}

		as3commons_reflect function setNamespaceName(value:String):void {
			_namespaceName = value;
		}

		as3commons_reflect function setProtectedNamespace(value:String):void {
			_protectedNamespace = value;
		}

		as3commons_reflect function setStaticConstructor(value:ByteCodeMethod):void {
			_staticConstructor = value;
		}
	}
}
