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
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;

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
	public class Type extends MetaDataContainer {

		public static const UNTYPED:Type = new Type(ApplicationDomain.currentDomain);
		{
			UNTYPED.fullName = '*';
			UNTYPED.name = '*';
		}

		public static const VOID:Type = new Type(ApplicationDomain.currentDomain);
		{
			VOID.fullName = 'void';
			VOID.name = 'void';
		}

		public static const PRIVATE:Type = new Type(ApplicationDomain.currentDomain);
		private static const MEMBER_PROPERTY_NAME:String = 'name';
		{
			PRIVATE.fullName = 'private';
			PRIVATE.name = 'private';
		}

		private static var logger:ILogger = LoggerFactory.getClassLogger(Type);

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
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
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
				case "void":
					result = Type.VOID;
					break;
				case "*":
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
						logger.warn("The class with the name '{0}' could not be found in the application domain '{1}'", name, applicationDomain);
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
				typeProvider = new TypeXmlParser();
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

		private var _isProtected:Boolean;

		public function get isProtected():Boolean {
			return _isProtected;
		}

		/**
		 * @private
		 */
		public function set isProtected(value:Boolean):void {
			_isProtected = value;
		}

		private var _isSealed:Boolean;

		public function get isSealed():Boolean {
			return _isSealed;
		}

		/**
		 * @private
		 */
		public function set isSealed(value:Boolean):void {
			_isSealed = value;
		}

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
		public function getMethod(name:String):Method {
			return _methods.get(name);
		}

		/**
		 * Returns the <code>Field</code> object for the field in this type
		 * with the given name.
		 *
		 * @param name the name of the field
		 */
		public function getField(name:String):Field {
			//force _fields HashArray to be created
			if (_fields == null) {
				createFieldsHashArray();
			}
			return _fields.get(name);
		}

		private var _metaDataLookup:Dictionary;

		public function createMetaDataLookup():void {
			_metaDataLookup = new Dictionary();
			addToMetaDataLookup(_methods.getArray());
			if (_fields == null) {
				createFieldsHashArray();
			}
			addToMetaDataLookup(_fields.getArray());
		}

		/**
		 * Retrieves an Array of <code>MetadataContainer</code> instances that are associated with the current <code>Type</code>
		 * that contain <code>MetaData</code> with the specified name.
		 * <p>Each <code>MetadataContainer</code> instance can be one of these subclasses:</p>
		 * <ul>
		 *   <li>Type</li>
		 *   <li>Method</li>
		 *   <li>Accessor</li>
		 *   <li>Constant</li>
		 *   <li>Variable</li>
		 * </ul>
		 * @param name The specified <code>MetaData</code> name.
		 * @return An Array of <code>MetadataContainer</code> instances.
		 */
		public function getMetaDataContainers(name:String):Array {
			if (_metaDataLookup != null) {
				return _metaDataLookup[name] as Array;
			} else {
				return null;
			}
		}

		private function addToMetaDataLookup(containerList:Array):void {
			for each (var container:MetaDataContainer in containerList) {
				var metadatas:Array = container.metaData;
				for each (var m:MetaData in metadatas) {
					var arr:Array = _metaDataLookup[m.name];
					if (arr == null) {
						arr = [];
						_metaDataLookup[m.name] = arr;
					}
					arr[arr.length] = container;
				}
			}
		}

	}
}
import flash.system.ApplicationDomain;

import org.as3commons.lang.ClassUtils;
import org.as3commons.reflect.Accessor;
import org.as3commons.reflect.AccessorAccess;
import org.as3commons.reflect.Constant;
import org.as3commons.reflect.Constructor;
import org.as3commons.reflect.IMember;
import org.as3commons.reflect.IMetaDataContainer;
import org.as3commons.reflect.INamespaceOwner;
import org.as3commons.reflect.ITypeProvider;
import org.as3commons.reflect.MetaData;
import org.as3commons.reflect.MetaDataArgument;
import org.as3commons.reflect.MetaDataContainer;
import org.as3commons.reflect.Method;
import org.as3commons.reflect.Parameter;
import org.as3commons.reflect.ReflectionUtils;
import org.as3commons.reflect.Type;
import org.as3commons.reflect.TypeCache;
import org.as3commons.reflect.Variable;
import org.as3commons.reflect.as3commons_reflect;

/**
 * Internal xml parser
 */
internal class TypeXmlParser implements ITypeProvider {

	private static var typeCache:TypeCache = new TypeCache();

	public function getTypeCache():TypeCache {
		return typeCache;
	}

	public function clearCache():void {
		typeCache.clear();
	}

	/**
	 *
	 */
	private function concatMetadata(type:Type, metaDataContainers:Array, propertyName:String):void {
		for each (var container:IMetaDataContainer in metaDataContainers) {
			type[propertyName].some(function(item:MetaDataContainer, index:int, arr:Array):Boolean {
					if (Object(item).name == Object(container).name) {
						var metaDataList:Array = container.metaData;
						var numMetaData:int = metaDataList.length;
						for (var j:int = 0; j < numMetaData; j++) {
							if (!item.hasExactMetaData(metaDataList[j])) {
								item.addMetaData(metaDataList[j]);
							}
						}
						return true;
					}
					return false;
				});
		}
	}

	public function getType(cls:Class, applicationDomain:ApplicationDomain):Type {
		var type:Type = new Type(applicationDomain);
		var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(cls);

		// Add the Type to the cache before assigning any values to prevent looping.
		// Due to the work-around implemented for constructor argument types
		// in getTypeDescription(), an instance is created, which could also
		// lead to infinite recursion if the constructor uses Type.forName().
		// Therefore it is important to seed the cache before calling
		// getTypeDescription (thanks to Jürgen Failenschmid for reporting this)
		typeCache.put(fullyQualifiedClassName, type);
		var description:XML = ReflectionUtils.getTypeDescription(cls);
		type.fullName = fullyQualifiedClassName;
		type.name = ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);
		type.clazz = cls;
		type.isDynamic = description.@isDynamic;
		type.isFinal = description.@isFinal;
		type.isStatic = description.@isStatic;
		type.alias = description.@alias;
		type.isInterface = (cls === Object) ? false : (description.factory.extendsClass.length() == 0);
		type.constructor = parseConstructor(type, description.factory.constructor, applicationDomain);
		type.accessors = parseAccessors(type, description, applicationDomain);
		type.methods = parseMethods(type, description, applicationDomain);
		type.staticConstants = parseMembers(Constant, description.constant, fullyQualifiedClassName, true, applicationDomain);
		type.constants = parseMembers(Constant, description.factory.constant, fullyQualifiedClassName, false, applicationDomain);
		type.staticVariables = parseMembers(Variable, description.variable, fullyQualifiedClassName, true, applicationDomain);
		type.variables = parseMembers(Variable, description.factory.variable, fullyQualifiedClassName, false, applicationDomain);
		type.extendsClasses = parseExtendsClasses(description.factory.extendsClass, type.applicationDomain);
		parseMetaData(description.factory[0].metadata, type);
		type.interfaces = parseImplementedInterfaces(description.factory.implementsInterface);

		// Combine metadata from implemented interfaces
		var numInterfaces:int = type.interfaces.length;
		for (var i:int = 0; i < numInterfaces; i++) {
			var interfaze:Type = Type.forName(type.interfaces[i], applicationDomain);
			concatMetadata(type, interfaze.methods, "methods");
			concatMetadata(type, interfaze.accessors, "accessors");
			var interfaceMetaData:Array = interfaze.metaData;
			var numMetaData:int = interfaceMetaData.length;

			for (var j:int = 0; j < numMetaData; j++) {
				if (!type.hasExactMetaData(interfaceMetaData[j])) {
					type.addMetaData(interfaceMetaData[j]);
				}
			}
		}

		type.createMetaDataLookup();

		return type;
	}

	/**
	 *
	 */
	private function parseConstructor(type:Type, constructorXML:XMLList, applicationDomain:ApplicationDomain):Constructor {
		if (constructorXML.length() > 0) {
			var params:Array = parseParameters(constructorXML[0].parameter, applicationDomain);
			return new Constructor(type.fullName, applicationDomain, params);
		} else {
			return new Constructor(type.fullName, applicationDomain);
		}
	}

	/**
	 *
	 */
	private function parseMethods(type:Type, xml:XML, applicationDomain:ApplicationDomain):Array {
		var classMethods:Array = parseMethodsByModifier(type, xml.method, true, applicationDomain);
		var instanceMethods:Array = parseMethodsByModifier(type, xml.factory.method, false, applicationDomain);
		return classMethods.concat(instanceMethods);
	}

	/**
	 *
	 */
	private function parseAccessors(type:Type, xml:XML, applicationDomain:ApplicationDomain):Array {
		var classAccessors:Array = parseAccessorsByModifier(type, xml.accessor, true, applicationDomain);
		var instanceAccessors:Array = parseAccessorsByModifier(type, xml.factory.accessor, false, applicationDomain);
		return classAccessors.concat(instanceAccessors);
	}

	/**
	 *
	 */
	private function parseMembers(memberClass:Class, members:XMLList, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain):Array {
		var result:Array = [];

		for each (var m:XML in members) {
			var member:IMember = new memberClass(m.@name, m.@type.toString(), declaringType, isStatic, applicationDomain);
			if (member is INamespaceOwner) {
				INamespaceOwner(member).as3commons_reflect::setNamespaceURI(m.@uri);
			}
			parseMetaData(m.metadata, member);
			result.push(member);
		}
		return result;
	}

	private function parseImplementedInterfaces(interfacesDescription:XMLList):Array {
		var result:Array = [];

		if (interfacesDescription) {
			var numInterfaces:int = interfacesDescription.length();
			for (var i:int = 0; i < numInterfaces; i++) {
				var fullyQualifiedInterfaceName:String = interfacesDescription[i].@type.toString();
				fullyQualifiedInterfaceName = ClassUtils.convertFullyQualifiedName(fullyQualifiedInterfaceName);
				result[result.length] = fullyQualifiedInterfaceName;
			}
		}
		return result;

	}

	/**
	 *
	 */
	private function parseExtendsClasses(extendedClasses:XMLList, applicationDomain:ApplicationDomain):Array {
		var result:Array = [];
		for each (var node:XML in extendedClasses) {
			result[result.length] = node.@type.toString();
		}
		return result;
	}

	private function parseMethodsByModifier(type:Type, methodsXML:XMLList, isStatic:Boolean, applicationDomain:ApplicationDomain):Array {
		var result:Array = [];

		for each (var methodXML:XML in methodsXML) {
			var params:Array = parseParameters(methodXML.parameter, applicationDomain);
			var method:Method = new Method(type.fullName, methodXML.@name, isStatic, params, methodXML.@returnType, applicationDomain);
			method.as3commons_reflect::setNamespaceURI(methodXML.@uri);
			parseMetaData(methodXML.metadata, method);
			result.push(method);
		}
		return result;
	}

	private function parseParameters(paramsXML:XMLList, applicationDomain:ApplicationDomain):Array {
		var params:Array = [];

		for each (var paramXML:XML in paramsXML) {
			var param:Parameter = new Parameter(paramXML.@index, paramXML.@type, applicationDomain, paramXML.@optional == "true" ? true : false);
			params.push(param);
		}

		return params;
	}

	private function parseAccessorsByModifier(type:Type, accessorsXML:XMLList, isStatic:Boolean, applicationDomain:ApplicationDomain):Array {
		var result:Array = [];

		for each (var accessorXML:XML in accessorsXML) {
			var accessor:Accessor = new Accessor(accessorXML.@name, AccessorAccess.fromString(accessorXML.@access), accessorXML.@type.toString(), accessorXML.@declaredBy.toString(), isStatic, applicationDomain);
			accessor.as3commons_reflect::setNamespaceURI(accessorXML.@uri);
			parseMetaData(accessorXML.metadata, accessor);
			result.push(accessor);
		}
		return result;
	}

	/**
	 * Parses MetaData objects from the given metaDataNodes XML data and adds them to the given metaData array.
	 */
	private function parseMetaData(metaDataNodes:XMLList, metaData:IMetaDataContainer):void {
		for each (var metaDataXML:XML in metaDataNodes) {
			var metaDataArgs:Array = [];

			for each (var metaDataArgNode:XML in metaDataXML.arg) {
				metaDataArgs.push(new MetaDataArgument(metaDataArgNode.@key, metaDataArgNode.@value));
			}
			metaData.addMetaData(new MetaData(metaDataXML.@name, metaDataArgs));
		}
	}
}
