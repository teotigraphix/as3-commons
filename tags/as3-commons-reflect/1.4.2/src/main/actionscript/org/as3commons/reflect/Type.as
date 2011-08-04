/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.reflect {

	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.HashArray;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * Provides information about the characteristics of a class or an interface.
	 * These are the methods, accessors (getter/setter), variables and constants,
	 * but also if the class is <code>dynamic</code> and <code>final</code>.
	 *
	 * <p>Note that information about an object cannot be retrieved by calling the
	 * <code>Type</code> constructor. Instead use one of the following static
	 * methods:</p>
	 *
	 * <p>In case of an instance:
	 * <code>var type:Type = Type.forInstance(myInstance);</code>
	 * </p>
	 *
	 * <p>In case of a <code>Class</code> variable:
	 * <code>var type:Type = Type.forClass(MyClass);</code>
	 * </p>
	 *
	 * <p>In case of a classname:
	 * <code>var type:Type = Type.forName("MyClass");</code>
	 * </p>
	 *
	 * @author Christophe Herreman
	 * @author Martino Piccinato
	 * @author Andrew Lewisohn
	 */
	public class Type extends MetadataContainer {

		/**
		 * Clears the cache and set typeProvider to null.
		 */
		public static function reset():void {
			if (typeProvider != null) {
				typeProvider.clearCache();
			}
			typeProvider = null;
		}

		public static const UNTYPED:Type = new Type(ApplicationDomain.currentDomain);
		{
			UNTYPED.fullName = UNTYPED_NAME;
			UNTYPED.name = UNTYPED_NAME;
		}

		public static const VOID:Type = new Type(ApplicationDomain.currentDomain);
		{
			VOID.fullName = VOID_NAME;
			VOID.name = VOID_NAME;
		}

		public static const PRIVATE:Type = new Type(ApplicationDomain.currentDomain);
		{
			PRIVATE.fullName = PRIVATE_NAME;
			PRIVATE.name = PRIVATE_NAME;
		}

		private static const MEMBER_PROPERTY_NAME:String = 'name';
		public static const VOID_NAME:String = "void";
		private static const UNTYPED_NAME:String = "*";
		private static const PRIVATE_NAME:String = 'private';
		public static var typeProviderKind:TypeProviderKind;
		{
			typeProviderKind = TypeProviderKind.JSON;
		}

		private static var logger:ILogger = getLogger(Type);

		private static var typeProvider:ITypeProvider;

		// --------------------------------------------------------------------
		//
		// Static Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns a <code>Type</code> object that describes the given instance.
		 *
		 * @param instance the instance from which to get a type description
		 */
		public static function forInstance(instance:*, applicationDomain:ApplicationDomain = null):Type {
			applicationDomain ||= ApplicationDomain.currentDomain;
			var result:Type;
			var clazz:Class = org.as3commons.lang.ClassUtils.forInstance(instance, applicationDomain);

			if (clazz != null) {
				result = Type.forClass(clazz, applicationDomain);
			}
			return result;
		}

		/**
		 * Returns a <code>Type</code> object that describes the given classname.
		 *
		 * @param name the classname from which to get a type description
		 */
		public static function forName(name:String, applicationDomain:ApplicationDomain = null):Type {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:Type;

			/*if(name.indexOf("$")!=-1){
			   return Type.PRIVATE;
			 }*/
			switch (name) {
				case VOID_NAME:
					result = Type.VOID;
					break;
				case UNTYPED_NAME:
					result = Type.UNTYPED;
					break;
				default:
					try {
						if (getTypeProvider().getTypeCache().contains(name)) {
							result = getTypeProvider().getTypeCache().get(name);
						} else {
							result = Type.forClass(org.as3commons.lang.ClassUtils.forName(name, applicationDomain), applicationDomain);
						}
					} catch (e:ReferenceError) {
						logger.warn("Type.forName error: " + e.message + " The class '" + name + "' is probably an internal class or it may not have been compiled.");
					} catch (e:ClassNotFoundError) {
						logger.warn("The class with the name '{0}' could not be found in the application domain '{1}'", [name, applicationDomain]);
					}
			}
			return result;
		}

		/**
		 * Returns a <code>Type</code> object that describes the given class.
		 *
		 * @param clazz the class from which to get a type description
		 */
		public static function forClass(clazz:Class, applicationDomain:ApplicationDomain = null):Type {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:Type;
			var fullyQualifiedClassName:String = org.as3commons.lang.ClassUtils.getFullyQualifiedName(clazz);

			if (getTypeProvider().getTypeCache().contains(fullyQualifiedClassName)) {
				result = getTypeProvider().getTypeCache().get(fullyQualifiedClassName);
			} else {
				result = getTypeProvider().getType(clazz, applicationDomain);
			}

			return result;
		}

		/**
		 *
		 */
		public static function getTypeProvider():ITypeProvider {
			if (typeProvider == null) {
				if (typeProviderKind === TypeProviderKind.JSON) {
					try {
						typeProvider = new JSONTypeProvider();
					} catch (e:*) {
					}
				}
				if (typeProvider == null) {
					typeProvider = new XmlTypeProvider();
				}
			}
			return typeProvider;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>Type</code> instance.
		 */
		public function Type(applicationDomain:ApplicationDomain) {
			super();
			initType(applicationDomain);
		}

		/**
		 * Initializes the current <code>Type</code> instance.
		 */
		protected function initType(applicationDomain:ApplicationDomain):void {
			_accessors = [];
			_staticConstants = [];
			_constants = [];
			_staticVariables = [];
			_variables = [];
			_extendsClasses = [];
			_interfaces = [];
			_parameters = [];
			_applicationDomain = applicationDomain;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// applicationDomain
		// ----------------------------

		private var _applicationDomain:ApplicationDomain;

		/**
		 * The ApplicationDomain which is able to retrieve the object definition for this type. The definition does not
		 * necessarily have to be part of this <code>ApplicationDomain</code>, it could possibly be present in the parent domain as well.
		 */
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		/**
		 * @private
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		// ----------------------------
		// name
		// ----------------------------

		private var _alias:String;

		public function get alias():String {
			return _alias;
		}

		public function set alias(value:String):void {
			_alias = value;
		}

		// ----------------------------
		// name
		// ----------------------------

		private var _name:String;

		/**
		 * The name of the type
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}

		// ----------------------------
		// fullName
		// ----------------------------

		private var _fullName:String;

		/**
		 * The fully qualified name of the type, this includes the namespace
		 */
		public function get fullName():String {
			return _fullName;
		}

		/**
		 * @private
		 */
		public function set fullName(value:String):void {
			_fullName = value;
		}

		// ----------------------------
		// clazz
		// ----------------------------

		private var _class:Class;

		/**
		 * The Class of the <code>Type</code>
		 */
		public function get clazz():Class {
			return _class;
		}

		/**
		 * @private
		 */
		public function set clazz(value:Class):void {
			_class = value;
		}

		// ----------------------------
		// isDynamic
		// ----------------------------

		private var _isDynamic:Boolean;

		/**
		 * True if the <code>Type</code> is dynamic
		 */
		public function get isDynamic():Boolean {
			return _isDynamic;
		}

		/**
		 * @private
		 */
		public function set isDynamic(value:Boolean):void {
			_isDynamic = value;
		}

		// ----------------------------
		// isFinal
		// ----------------------------

		private var _isFinal:Boolean;

		/**
		 * True if the <code>Type</code> is final
		 */
		public function get isFinal():Boolean {
			return _isFinal;
		}

		/**
		 * @private
		 */
		public function set isFinal(value:Boolean):void {
			_isFinal = value;
		}

		// ----------------------------
		// isStatic
		// ----------------------------

		private var _isStatic:Boolean;

		/**
		 * True if the <code>Type</code> is static
		 */
		public function get isStatic():Boolean {
			return _isStatic;
		}

		/**
		 * @private
		 */
		public function set isStatic(value:Boolean):void {
			_isStatic = value;
		}

		// ----------------------------
		// isInterface
		// ----------------------------

		private var _isInterface:Boolean;

		/**
		 * True if the <code>Type</code> is an interface
		 */
		public function get isInterface():Boolean {
			return _isInterface;
		}

		/**
		 * @private
		 */
		public function set isInterface(value:Boolean):void {
			_isInterface = value;
		}

		// ----------------------------
		// parameters
		// ----------------------------

		private var _parameters:Array;

		public function get parameters():Array {
			return _parameters;
		}

		// ----------------------------
		// interfaces
		// ----------------------------

		private var _interfaces:Array;

		public function get interfaces():Array {
			return _interfaces;
		}

		/**
		 * @private
		 */
		public function set interfaces(value:Array):void {
			_interfaces = value;
		}

		// ----------------------------
		// constructor
		// ----------------------------

		private var _constructor:Constructor;

		/**
		 * A reference to a <code>Constructor</code> instance that describes the constructor of the <code>Type</code>
		 * @see org.as3commons.reflect.Constructor Constructor
		 */
		public function get constructor():Constructor {
			return _constructor;
		}

		/**
		 * @private
		 */
		public function set constructor(constructor:Constructor):void {
			_constructor = constructor;
		}

		// ----------------------------
		// accessors
		// ----------------------------

		private var _accessors:Array;

		/**
		 * An array of <code>Accessor</code> instances
		 * @see org.as3commons.reflect.Accessor Accessor
		 */
		public function get accessors():Array {
			return _accessors;
		}

		/**
		 * @private
		 */
		public function set accessors(value:Array):void {
			_accessors = value;

			/*
			// Must invalidate the fields cache.
			// Due to the work-around implemented for constructor argument types
			// in ReflectionUtils.getTypeDescription(), an instance of Type is created,
			// which could also lead to an invalid fields cache (e.g., empty cache)
			// if the constructor uses Type.forName() and/or Type.getField().
			// Therefore it is important to invalidate the cache when any of
			// the constituents of the fields cache change.
			// See also note in XmlTypeProvider#getType().
			 */
			_fields = null;
		}

		// ----------------------------
		// methods
		// ----------------------------

		private var _methods:HashArray;

		/**
		 * An array of <code>Method</code> instances
		 * @see org.as3commons.reflect.Method Method
		 */
		public function get methods():Array {
			return (_methods != null) ? _methods.getArray() : [];
		}

		/**
		 * @private
		 */
		public function set methods(value:Array):void {
			_methods = new HashArray(MEMBER_PROPERTY_NAME, false, value);
		}

		// ----------------------------
		// staticConstants
		// ----------------------------

		private var _staticConstants:Array;

		/**
		 * An array of <code>IMember</code> instances that describe the static constants of the <code>Type</code>
		 * @see org.as3commons.reflect.IMember IMember
		 */
		public function get staticConstants():Array {
			return _staticConstants;
		}

		/**
		 * @private
		 */
		public function set staticConstants(value:Array):void {
			_staticConstants = value;

			// Must invalidate the fields cache. See note in #accessors.
			_fields = null;
		}

		// ----------------------------
		// constants
		// ----------------------------

		private var _constants:Array;

		/**
		 * An array of <code>IMember</code> instances that describe the constants of the <code>Type</code>
		 * @see org.as3commons.reflect.IMember IMember
		 */
		public function get constants():Array {
			return _constants;
		}

		/**
		 * @private
		 */
		public function set constants(value:Array):void {
			_constants = value;

			// Must invalidate the fields cache. See note in #accessors.
			_fields = null;
		}

		// ----------------------------
		// staticVariables
		// ----------------------------

		private var _staticVariables:Array;

		/**
		 * An array of <code>IMember</code> instances that describe the static variables of the <code>Type</code>
		 * @see org.as3commons.reflect.IMember IMember
		 */
		public function get staticVariables():Array {
			return _staticVariables;
		}

		/**
		 * @private
		 */
		public function set staticVariables(value:Array):void {
			_staticVariables = value;

			// Must invalidate the fields cache. See note in #accessors.
			_fields = null;
		}

		// ----------------------------
		// extendsClass
		// ----------------------------

		private var _extendsClasses:Array /* of String */;

		/**
		 * @return An <code>Array</code> of fully qualified class names that represent the inheritance order of the current <code>Type</code>.
		 * <p>The first item in the <code>Array</code> is the fully qualified classname of the super class of the current <code>Type</code>.</p>
		 */
		public function get extendsClasses():Array {
			return _extendsClasses;
		}

		/**
		 * @private
		 */
		public function set extendsClasses(value:Array):void {
			_extendsClasses = value;
		}

		// ----------------------------
		// variables
		// ----------------------------

		private var _variables:Array;

		/**
		 * An array of <code>IMember</code> instances that describe the variables of the <code>Type</code>
		 * @see org.as3commons.reflect.IMember IMember
		 */
		public function get variables():Array {
			return _variables;
		}

		/**
		 * @private
		 */
		public function set variables(value:Array):void {
			_variables = value;

			// Must invalidate the fields cache. See note in #accessors.
			_fields = null;
		}

		// ----------------------------
		// fields
		// ----------------------------

		private var _fields:HashArray;

		/**
		 * An array of all the static constants, constants, static variables and variables of the <code>Type</code>
		 * @see org.as3commons.reflect.IMember IMember
		 */
		public function get fields():Array {
			if (_fields == null) {
				createFieldsHashArray();
			}
			return _fields.getArray();
		}

		private function createFieldsHashArray():void {
			_fields = new HashArray(MEMBER_PROPERTY_NAME, false, accessors.concat(staticConstants).concat(constants).concat(staticVariables).concat(variables));
		}

		/**
		 * An array of Field containing all accessors and variables for the type.
		 *
		 * @see org.as3commons.reflect.Variable
		 * @see org.as3commons.reflect.Accessor
		 * @see org.as3commons.reflect.Field
		 */
		public function get properties():Array {
			return accessors.concat(variables);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns the <code>Method</code> object for the method in this type
		 * with the given name.
		 *
		 * @param name the name of the method
		 */
		public function getMethod(name:String, ns:String = null):Method {
			if (ns == null) {
				return _methods.get(name);
			} else {
				var mthds:Array = _methods.getArray();
				for each (var method:Method in mthds) {
					if ((method.name == name) && (method.namespaceURI == ns)) {
						return method;
					}
				}
				return null;
			}
		}

		/**
		 * Returns the <code>Field</code> object for the field in this type
		 * with the given name.
		 *
		 * @param name the name of the field
		 */
		public function getField(name:String, ns:String = null):Field {
			//force _fields HashArray to be created
			if (_fields == null) {
				createFieldsHashArray();
			}
			if (ns == null) {
				return _fields.get(name);
			} else {
				var flds:Array = _fields.getArray();
				for each (var field:Field in flds) {
					if ((field.name == name) && (field.namespaceURI == ns)) {
						return field;
					}
				}
				return null;
			}
		}

		private var _metadataLookup:Dictionary;

		public function createMetadataLookup():void {
			_metadataLookup = new Dictionary();
			addToMetadataLookup(_methods.getArray());
			if (_fields == null) {
				createFieldsHashArray();
			}
			addToMetadataLookup(_fields.getArray());
		}

		/**
		 * Retrieves an Array of <code>MetadataContainer</code> instances that are associated with the current <code>Type</code>
		 * that contain <code>Metadata</code> with the specified name.
		 * <p>Each <code>MetadataContainer</code> instance can be one of these subclasses:</p>
		 * <ul>
		 *   <li>Type</li>
		 *   <li>Method</li>
		 *   <li>Accessor</li>
		 *   <li>Constant</li>
		 *   <li>Variable</li>
		 * </ul>
		 * @param name The specified <code>Metadata</code> name.
		 * @return An Array of <code>MetadataContainer</code> instances.
		 */
		public function getMetadataContainers(name:String):Array {
			if (_metadataLookup != null) {
				return _metadataLookup[name] as Array;
			} else {
				return null;
			}
		}

		private function addToMetadataLookup(containerList:Array):void {
			for each (var container:MetadataContainer in containerList) {
				var metadatas:Array = container.metadata;
				for each (var m:Metadata in metadatas) {
					var arr:Array = _metadataLookup[m.name];
					if (arr == null) {
						arr = [];
						_metadataLookup[m.name] = arr;
					}
					arr[arr.length] = container;
				}
			}
		}

		as3commons_reflect function setParameters(value:Array):void {
			_parameters = value;
		}

	}
}
