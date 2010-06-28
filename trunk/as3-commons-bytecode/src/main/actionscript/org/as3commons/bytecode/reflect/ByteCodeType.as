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
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constant;
	import org.as3commons.reflect.ITypeProvider;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.as3commons.reflect.as3commons_reflect;

	public class ByteCodeType extends Type {

		private static var typeProvider:ITypeProvider;

		public function ByteCodeType(applicationDomain:ApplicationDomain) {
			super(applicationDomain);
		}

		public static function getTypeProvider():ITypeProvider {
			if (typeProvider == null) {
				typeProvider = new ByteCodeTypeProvider();
			}
			return typeProvider;
		}

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

		public static function fromByteArray(input:ByteArray, applicationDomain:ApplicationDomain = null):void {
			Assert.notNull(input, "input argument must not be null");
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			(getTypeProvider() as ByteCodeTypeProvider).fromByteArray(input, applicationDomain);
		}

		public static function forInstance(instance:*, applicationDomain:ApplicationDomain = null):ByteCodeType {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:ByteCodeType;
			var clazz:Class = ClassUtils.forInstance(instance, applicationDomain);

			if (clazz != null) {
				result = ByteCodeType.forClass(clazz, applicationDomain);
			}
			return result;
		}

		/**
		 * Returns a <code>Type</code> object that describes the given classname.
		 *
		 * @param name the classname from which to get a type description
		 */
		public static function forName(name:String, applicationDomain:ApplicationDomain = null):ByteCodeType {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:ByteCodeType;

			result = getTypeProvider().getTypeCache().get(name) as ByteCodeType;

			return result;
		}

		/**
		 * Returns a <code>Type</code> object that describes the given class.
		 *
		 * @param clazz the class from which to get a type description
		 */
		public static function forClass(clazz:Class, applicationDomain:ApplicationDomain = null):ByteCodeType {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:ByteCodeType;
			var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(clazz);

			result = getTypeProvider().getTypeCache().get(fullyQualifiedClassName) as ByteCodeType;

			return result;
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

		// ----------------------------
		// staticConstructor
		// ----------------------------

		private var _staticConstructor:Method;

		public function get staticConstructor():Method {
			return _staticConstructor;
		}


		// ----------------------------
		// isProtected
		// ----------------------------

		private var _isProtected:Boolean;

		public function get isProtected():Boolean {
			return _isProtected;
		}

		// ----------------------------
		// protectedNamespace
		// ----------------------------

		private var _protectedNamespace:String = "";

		public function get protectedNamespace():String {
			return _protectedNamespace;
		}

		// ----------------------------
		// isSealed
		// ----------------------------

		private var _isSealed:Boolean;

		public function get isSealed():Boolean {
			return _isSealed;
		}

		as3commons_reflect function setIsSealed(value:Boolean):void {
			_isSealed = value;
		}

		as3commons_reflect function setIsProtected(value:Boolean):void {
			_isProtected = value;
		}

		as3commons_reflect function setProtectedNamespace(value:String):void {
			_protectedNamespace = value;
		}

		as3commons_reflect function setStaticConstructor(value:Method):void {
			_staticConstructor = value;
		}

		private var _initialized:Boolean = false;

		as3commons_reflect function get initialized():Boolean {
			return _initialized;
		}

		as3commons_reflect function initialize():void {
			_initialized = true;
			if (extendsClasses.length > 0) {
				var tempMethods:Array = methods;
				var parentByteCodeType:ByteCodeType = forName(this.extendsClasses[0], this.applicationDomain);
				if (parentByteCodeType != null) {
					for each (var method:ByteCodeMethod in parentByteCodeType.methods) {
						tempMethods[tempMethods.length] = method;
					}
					for each (var variable:ByteCodeVariable in parentByteCodeType.variables) {
						this.variables[this.variables.length] = variable;
					}
					for each (var acc:ByteCodeAccessor in parentByteCodeType.accessors) {
						this.accessors[this.accessors.length] = acc;
					}
					for each (var constant:ByteCodeConstant in parentByteCodeType.constants) {
						this.constants[this.constants.length] = constant;
					}
					this.methods = tempMethods;
					this.createMetaDataLookup();
				} else {
					var parentType:Type = Type.forName(this.extendsClasses[0], this.applicationDomain);
					if (parentType != null) {
						for each (var typeMethod:Method in parentType.methods) {
							tempMethods[tempMethods.length] = typeMethod;
						}
						for each (var typeVariable:Variable in parentType.variables) {
							this.variables[this.variables.length] = typeVariable;
						}
						for each (var typeAcc:Accessor in parentType.accessors) {
							this.accessors[this.accessors.length] = typeAcc;
						}
						for each (var typeConstant:Constant in parentType.constants) {
							this.constants[this.constants.length] = typeConstant;
						}
						this.methods = tempMethods;
						this.createMetaDataLookup();
					}
				}
			}
		}
	}
}