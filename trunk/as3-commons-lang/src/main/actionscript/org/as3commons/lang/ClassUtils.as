/*
 * Copyright 2009-2010 the original author or authors.
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
package org.as3commons.lang {

import flash.events.TimerEvent;
import flash.system.ApplicationDomain;
import flash.utils.Proxy;
import flash.utils.Timer;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

/**
 * Provides utilities for working with <code>Class</code> objects.
 *
 * @author Christophe Herreman
 * @author Erik Westra
 */
public final class ClassUtils {

	// --------------------------------------------------------------------
	//
	// describeType cache implementation
	//
	// --------------------------------------------------------------------

	/**
	 * The default value for the interval to clear the describe type cache.
	 */
	public static const CLEAR_CACHE_INTERVAL:uint = 60000;

	/**
	 * The interval (in miliseconds) at which the cache will be cleared. Note that this value is only used
	 * on the first call to getFromObject.
	 *
	 * @default 60000 (one minute)
	 */
	public static var clearCacheInterval:uint = CLEAR_CACHE_INTERVAL;

	private static var _clearCacheIntervalEnabled:Boolean = true;

	public static function get clearCacheIntervalEnabled():Boolean {
		return _clearCacheIntervalEnabled;
	}

	public static function set clearCacheIntervalEnabled(value:Boolean):void {
		_clearCacheIntervalEnabled = value;

		if (!_clearCacheIntervalEnabled) {
			stopTimer();
		}
	}


	private static const AS3VEC_SUFFIX:String = '__AS3__.vec';
	private static const CONSTRUCTOR_FIELD_NAME:String = "constructor";
	private static const LESS_THAN:String = '<';
	private static const PACKAGE_CLASS_SEPARATOR:String = "::";


	private static var _typeDescriptionCache:Object = {};

	private static var _timer:Timer;

	/**
	 * Clears the describe type cache. This method is called automatically at regular intervals
	 * defined by the clearCacheInterval property.
	 */
	public static function clearDescribeTypeCache():void {
		_typeDescriptionCache = {};

		stopTimer();
	}

	/**
	 * Converts the double colon (::) in a fully qualified class name to a dot (.)
	 */
	public static function convertFullyQualifiedName(className:String):String {
		return className.replace(PACKAGE_CLASS_SEPARATOR, ".");
	}

	/**
	 * Returns a <code>Class</code> object that corresponds with the given
	 * instance. If no correspoding class was found, a
	 * <code>ClassNotFoundError</code> will be thrown.
	 *
	 * @param instance the instance from which to return the class
	 * @param applicationDomain the optional applicationdomain where the instance's class resides
	 *
	 * @return the <code>Class</code> that corresponds with the given instance
	 *
	 * @see org.as3commons.lang.ClassNotFoundError
	 */
	public static function forInstance(instance:*, applicationDomain:ApplicationDomain = null):Class {
		if ((!(instance is Proxy)) && (instance.hasOwnProperty(CONSTRUCTOR_FIELD_NAME))) {
			return instance[CONSTRUCTOR_FIELD_NAME];
		} else {
			var className:String = getQualifiedClassName(instance);
			return forName(className, applicationDomain);
		}
	}

	/**
	 * Returns a <code>Class</code> object that corresponds with the given
	 * name. If no correspoding class was found in the applicationdomain tree, a
	 * <code>ClassNotFoundError</code> will be thrown.
	 *
	 * @param name the name from which to return the class
	 * @param applicationDomain the optional applicationdomain where the instance's class resides
	 *
	 * @return the <code>Class</code> that corresponds with the given name
	 *
	 * @see org.as3commons.lang.ClassNotFoundError
	 */
	public static function forName(name:String, applicationDomain:ApplicationDomain = null):Class {
		applicationDomain ||= ApplicationDomain.currentDomain;
		var result:Class;

		if (!applicationDomain) {
			applicationDomain = ApplicationDomain.currentDomain;
		}

		while (!applicationDomain.hasDefinition(name)) {
			if (applicationDomain.parentDomain) {
				applicationDomain = applicationDomain.parentDomain;
			} else {
				break;
			}
		}

		try {
			result = applicationDomain.getDefinition(name) as Class;
		} catch (e:ReferenceError) {
			throw new ClassNotFoundError("A class with the name '" + name + "' could not be found.");
		}
		return result;
	}

	/**
	 *
	 * @param fullName
	 * @param applicationDomain
	 * @return
	 */
	public static function getClassParameterFromFullyQualifiedName(fullName:String, applicationDomain:ApplicationDomain = null):Class {
		if (StringUtils.startsWith(fullName, AS3VEC_SUFFIX)) {
			var startIdx:int = fullName.indexOf(LESS_THAN) + 1;
			var len:int = (fullName.length - startIdx) - 1;
			var className:String = fullName.substr(startIdx, len);
			return forName(className, applicationDomain);
		} else {
			return null;
		}
	}

	/**
	 * Returns an array of all fully qualified interface names that the
	 * given class implements.
	 */
	public static function getFullyQualifiedImplementedInterfaceNames(clazz:Class, replaceColons:Boolean = false, applicationDomain:ApplicationDomain = null):Array {
		var typeDescription:ITypeDescription = getTypeDescription(clazz, applicationDomain);

		return typeDescription.getFullyQualifiedImplementedInterfaceNames(replaceColons);
	}

	/**
	 * Returns the fully qualified name of the given class.
	 *
	 * @param clazz the class to get the name from
	 * @param replaceColons whether the double colons "::" should be replaced by a dot "."
	 *             the default is false
	 *
	 * @return the fully qualified name of the class
	 */
	public static function getFullyQualifiedName(clazz:Class, replaceColons:Boolean = false):String {
		var result:String = getQualifiedClassName(clazz);

		if (replaceColons) {
			return convertFullyQualifiedName(result);
		} else {
			return result;
		}
	}

	/**
	 * Returns the fully qualified name of the given class' superclass.
	 *
	 * @param clazz the class to get its superclass' name from
	 * @param replaceColons whether the double colons "::" should be replaced by a dot "."
	 *             the default is false
	 *
	 * @return the fully qualified name of the class' superclass
	 */
	public static function getFullyQualifiedSuperClassName(clazz:Class, replaceColons:Boolean = false):String {
		var result:String = getQualifiedSuperclassName(clazz);

		if (replaceColons) {
			result = convertFullyQualifiedName(result);
		}
		return result;
	}

	/**
	 * Returns an array of all interface names that the given class implements.
	 */
	public static function getImplementedInterfaceNames(clazz:Class):Array {
		var result:Array = getFullyQualifiedImplementedInterfaceNames(clazz);

		for (var i:int = 0; i < result.length; i++) {
			result[i] = getNameFromFullyQualifiedName(result[i]);
		}
		return result;
	}

	/**
	 * Returns an array of all interface names that the given class implements.
	 */
	public static function getImplementedInterfaces(clazz:Class, applicationDomain:ApplicationDomain = null):Array {
		applicationDomain ||= ApplicationDomain.currentDomain;
		var result:Array = getFullyQualifiedImplementedInterfaceNames(clazz);

		for (var i:int = 0; i < result.length; i++) {
			result[i] = ClassUtils.forName(result[i], applicationDomain);
		}
		return result;
	}

	/**
	 * Returns the name of the given class.
	 *
	 * @param clazz the class to get the name from
	 *
	 * @return the name of the class
	 */
	public static function getName(clazz:Class):String {
		return getNameFromFullyQualifiedName(getFullyQualifiedName(clazz));
	}

	/**
	 * Returns the name of the class or interface, based on the given fully
	 * qualified class or interface name.
	 *
	 * @param fullyQualifiedName the fully qualified name of the class or interface
	 *
	 * @return the name of the class or interface
	 */
	public static function getNameFromFullyQualifiedName(fullyQualifiedName:String):String {
		var startIndex:int = fullyQualifiedName.indexOf(PACKAGE_CLASS_SEPARATOR);

		if (startIndex == -1) {
			return fullyQualifiedName;
		} else {
			return fullyQualifiedName.substring(startIndex + PACKAGE_CLASS_SEPARATOR.length, fullyQualifiedName.length);
		}
	}

	/**
	 * Returns a list of all properties of a class.
	 *
	 * @param clazz Class of which the properties should be examined,
	 * @param statik Static properties only, if false non-static only.
	 * @param readable Only properties that are readable.
	 * @param writable Only properties that are writable
	 * @param applicationDomain ApplicationDomain where the class was defined
	 *
	 * @return List of properties that match the criteria.
	 */
	public static function getProperties(clazz:*, statik:Boolean = false, readable:Boolean = true, writable:Boolean = true, applicationDomain:ApplicationDomain = null):Object {
		var typeDescription:ITypeDescription = getTypeDescription(clazz, applicationDomain);

		return typeDescription.getProperties(statik, readable, writable);
	}

	/**
	 * Returns the class that the passed in clazz extends. If no super class
	 * was found, in case of Object, null is returned.
	 *
	 * @param clazz the class to get the super class from
	 *
	 * @returns the super class or null if no parent class was found
	 */
	public static function getSuperClass(clazz:Class, applicationDomain:ApplicationDomain = null):Class {
		var typeDescription:ITypeDescription = getTypeDescription(clazz, applicationDomain);

		return typeDescription.getSuperClass();
	}

	/**
	 * Returns the name of the given class' superclass.
	 *
	 * @param clazz the class to get the name of its superclass' from
	 *
	 * @return the name of the class' superclass
	 */
	public static function getSuperClassName(clazz:Class):String {
		var fullyQualifiedName:String = getFullyQualifiedSuperClassName(clazz);
		var index:int = fullyQualifiedName.indexOf(PACKAGE_CLASS_SEPARATOR) + PACKAGE_CLASS_SEPARATOR.length;

		return fullyQualifiedName.substring(index, fullyQualifiedName.length);
	}

	/**
	 * Determines if the class or interface represented by the clazz1 parameter is either the same as, or is
	 * a superclass or superinterface of the clazz2 parameter. It returns true if so; otherwise it returns false.
	 *
	 * @return the boolean value indicating whether objects of the type clazz2 can be assigned to objects of clazz1
	 */
	public static function isAssignableFrom(clazz1:Class, clazz2:Class, applicationDomain:ApplicationDomain = null):Boolean {
		return (clazz1 === clazz2) || isSubclassOf(clazz2, clazz1, applicationDomain) || isImplementationOf(clazz2, clazz1, applicationDomain);
	}

	/**
	 * Returns whether the passed in <code>Class</code> object implements
	 * the given interface.
	 *
	 * @param clazz the class to check for an implemented interface
	 * @param interfaze the interface that the clazz argument should implement
	 *
	 * @return true if the clazz object implements the given interface; false if not
	 */
	public static function isImplementationOf(clazz:Class, interfaze:Class, applicationDomain:ApplicationDomain = null):Boolean {
		var typeDescription:ITypeDescription = getTypeDescription(clazz, applicationDomain);

		return typeDescription.isImplementationOf(interfaze);
	}

	/**
	 * Returns whether the passed in <code>Class</code> object contains all of the functions specified
	 * by the given interface, regardless of whether or not the class formally implements the interface.
	 *
	 * @param clazz the class to check for an implemented interface
	 * @param interfaze the interface that the clazz argument should implement
	 *
	 * @return true if the clazz object implements the methods of the given interface; false if not
	 */
	public static function isInformalImplementationOf(clazz:Class, interfaze:Class, applicationDomain:ApplicationDomain = null):Boolean {
		var typeDescription:ITypeDescription = getTypeDescription(clazz, applicationDomain);

		return typeDescription.isInformalImplementationOf(interfaze);
	}

	/**
	 * Returns whether the passed in Class object is an interface.
	 *
	 * @param clazz the class to check
	 * @return true if the clazz is an interface; false if not
	 */
	public static function isInterface(clazz:Class):Boolean {
		var typeDescription:ITypeDescription = getTypeDescription(clazz, ApplicationDomain.currentDomain);

		return typeDescription.isInterface();
	}

	/**
	 * Determines if the namespace of the class is private.
	 *
	 * @return A boolean value indicating the visibility of the class.
	 */
	public static function isPrivateClass(object:*):Boolean {
		var className:String = (object is Class) ? getQualifiedClassName(object) : object.toString();
		var index:int = className.indexOf("::");
		var inRootPackage:Boolean = (index == -1);

		if (inRootPackage) {
			return false;
		}

		var ns:String = className.substr(0, index);
		return (ns === "" || ns.indexOf(".as$") > -1);
	}

	/**
	 * Returns whether the passed in Class object is a subclass of the
	 * passed in parent Class. To check if an interface extends another interface, use the isImplementationOf()
	 * method instead.
	 */
	public static function isSubclassOf(clazz:Class, parentClass:Class, applicationDomain:ApplicationDomain = null):Boolean {
		var typeDescription:ITypeDescription = getTypeDescription(clazz, applicationDomain);

		return typeDescription.isSubclassOf(parentClass);
	}

	/**
	 * Creates an instance of the given class and passes the arguments to
	 * the constructor.
	 *
	 * TODO find a generic solution for this. Currently we support constructors
	 * with a maximum of 10 arguments.
	 *
	 * @param clazz the class from which an instance will be created
	 * @param args the arguments that need to be passed to the constructor
	 */
	public static function newInstance(clazz:Class, args:Array = null):* {
		var result:*;
		var a:Array = (args == null) ? [] : args;

		switch (a.length) {
			case 1:
				result = new clazz(a[0]);
				break;
			case 2:
				result = new clazz(a[0], a[1]);
				break;
			case 3:
				result = new clazz(a[0], a[1], a[2]);
				break;
			case 4:
				result = new clazz(a[0], a[1], a[2], a[3]);
				break;
			case 5:
				result = new clazz(a[0], a[1], a[2], a[3], a[4]);
				break;
			case 6:
				result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5]);
				break;
			case 7:
				result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
				break;
			case 8:
				result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
				break;
			case 9:
				result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
				break;
			case 10:
				result = new clazz(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]);
				break;
			default:
				result = new clazz();
		}

		return result;
	}


	public static function getTypeDescription(object:Object, applicationDomain:ApplicationDomain):ITypeDescription {
		Assert.notNull(object, "The clazz argument must not be null");

		var className:String = getQualifiedClassName(object);
		var typeDescription:ITypeDescription;

		if (_typeDescriptionCache.hasOwnProperty(className)) {
			typeDescription = _typeDescriptionCache[className];
		} else {
			if (!_timer && clearCacheIntervalEnabled) {
				// Only run the timer once to prevent unneeded overhead. This also prevents
				// this class from falling for the bug described here:
				// http://www.gskinner.com/blog/archives/2008/04/failure_to_unlo.html
				_timer = new Timer(clearCacheInterval, 1);
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}

			if (!(object is Class)) {
				if (object.hasOwnProperty(CONSTRUCTOR_FIELD_NAME)) {
					object = object.constructor;
				} else {
					object = forName(className, applicationDomain);
				}
			}

			typeDescription = TypeDescriptor.getTypeDescriptionForClass(object as Class);

			_typeDescriptionCache[className] = typeDescription;

			// Only run the timer if it is not already running.
			if (_timer && !_timer.running) {
				_timer.start();
			}
		}

		return typeDescription;
	}

	private static function stopTimer():void {
		if (_timer && _timer.running) {
			_timer.stop();
		}
	}

	private static function timerHandler(e:TimerEvent):void {
		clearDescribeTypeCache();
	}

}
}
