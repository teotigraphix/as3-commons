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

	import flash.utils.getQualifiedClassName;

	/**
	 * Base class for enumerations.
	 *
	 * <p>An enumeration has a name as a unique identifier and it is passed as a constructor argument. This argument
	 * is made optional and a setter is provided to allow server side Enum mapping, since this requires a no-args
	 * constructor.</p>
	 *
	 * <p>Comparing 2 enum instances with the equals() method will return true if the enums are of the same type and
	 * have the same name.</p>
	 *
	 * <p>Note: for enum mapping with BlazeDS, check the EnumProxy java class at http://bugs.adobe.com/jira/browse/BLZ-17</p>
	 *
	 * Example:
	 * <listing>
	 * import org.as3commons.lang.Enum;
	 *
	 * class MyEnum extends Enum {
	 *   public static const A: MyEnum = new MyEnum;
	 *   public static const B: MyEnum = new MyEnum;
	 *   public static const C: MyEnum = new MyEnum;
	 * }
	 * </listing>
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 * @version 2.0
	 */
	public class Enum implements IEquals {

		/**
		 * A map with the enum values of all Enum types in memory.
		 * As its keys, the fully qualified name of the enum class is used.
		 * As its values, another map is used to map the individual enum values,
		 * from name to enum instance.
		 *
		 * Example:
		 * <listing>
		 * {
		 *   "com.domain.Color": {
		 *     "RED": Color.RED,
		 *     "GREEN": Color.GREEN,
		 *     "BLUE": Color.BLUE
		 *   },
		 *   "com.domain.Day": {
		 *      "MONDAY": Day.MONDAY,
		 *      "TUESDAY": Day.TUESDAY,
		 *      "WEDNESDAY": Day.WEDNESDAY
		 *   }
		 * }
		 * </listing>
		 */
		private static var _values:Object /* <String, Enum> */ = {};

		/**
		 * A map with the value arrays of the Enum types in memory.
		 * As its keys, the fully qualified name of the enum class is used.
		 * As its values, an array with the enum values of a Enum class is used.
		 *
		 * Example:
		 * <listing>
		 * {
		 *   "com.domain.Color": [Color.RED, Color.GREEN, Color.BLUE]
		 * }
		 * </listing>
		 */
		private static var _valueArrays:Object /* <String, Array<Enum> */ = {};

		/**
		 * A map of all the Enums that are defined in the class structure.
		 *
		 * Example:
		 * {
		 *   "com.domain.Color": {
		 *     "RED": true,
		 *     "GREEN": true,
		 *     "BLUE": true
		 *   }
		 * }
		 */
		private static var _originalNames:Object /* <String, Object<Boolean>> */ = {};

		/**
		 * Infinite loop lock.
		 */
		private static var _initializing:Boolean = false;

		private var _name:String;

		private var _index:int = -1;

		private var _fixed:Boolean = false;

		/**
		 * Stores the class name, faster than retrieving it.
		 */
		private var _declaringClassName:String;

		/**
		 * Creates a new Enum object.
		 *
		 * <p>A new enum value is allowed to receive a empty string or null as its name. This is to
		 * make it possible to deserialize external data (from a remote object for instance) in which
		 * an Enum instance will be created without name and the name will be set via the name setter.
		 * The name can only be set to a non-null or non-empty value only once though.</p>
		 *
		 * @param name the name of the enum value
		 */
		public function Enum(name:String="") {
			_declaringClassName = getQualifiedClassName(this);
			this.name = name;
		}

		/**
		 * Returns the values of the enumeration of the given Class.
		 *
		 * @param clazz the class for which to return all enum values
		 * @return an array of Enum objects or Enum subtype objects
		 */
		public static function getValues(clazz:Class):Array {
			if (!ClassUtils.isSubclassOf(clazz, Enum)) {
				throw new IllegalArgumentError("Can not get enum values for class [" + clazz + "] because it is not a subclass of Enum.");
			}

			var className:String = getQualifiedClassName(clazz);
			var values:Array = _valueArrays[className];
			if (!values) {
				initializeDefinedEnums(className, clazz);
				values = _valueArrays[className];
				if (!values) {
					throw new IllegalArgumentError("Enum values for the class '" + className + "' do not exist");
				}
			}
			return values;
		}

		/**
		 * Returns the enum entry for the given class by its name.
		 *
		 * @param clazz the class that defines the enumeration
		 * @param name the name of the enum entry to get
		 */
		public static function getEnum(clazz:Class, name:String):Enum {
			if (!clazz) {
				throw new IllegalArgumentError("The class must not be null");
			}
			if (StringUtils.isBlank(name)) {
				throw new IllegalArgumentError("The name must have text");
			}

			var className:String = getQualifiedClassName(clazz);
			var values:Object = _values[className];
			if (!values) {
				initializeDefinedEnums(className);
				values = _values[className];
				if (!values) {
					throw new IllegalArgumentError("Enum values for the class '" + clazz + "' do not exist");
				}
			}

			var enum:Enum = values[name];
			if (!enum) {
				throw new IllegalArgumentError("An enum for type '" + clazz + "' and name '" + name + "' was not found.");
			}
			return enum;
		}

		/**
		 * Returns the index of the given enum, based on equality using the equals method.
		 *
		 * @return the index of the enum
		 */
		public static function getIndex(enum:Enum):int {
			if (!enum) {
				throw new IllegalArgumentError("The enum must not be null");
			}

			var values:Object = _values[enum._declaringClassName];

			if (!values) {
				initializeDefinedEnums(enum._declaringClassName);
				values = _values[enum._declaringClassName];
				if (!values) {
					throw new IllegalArgumentError("Enum values for the class name '" + enum._declaringClassName + "' do not exist");
				}
			}

			var other:Enum = values[enum._name];
			if (other) {
				return other.index;
			} else {
				return -1;
			}
		}

		/**
		 * Initializes the Enums defined in a passed class.
		 *
		 * <p>If enums in a class are defined as static </p>
		 *
		 * @param className Name of the Enum class to be initalized
		 * @param clazz Class for the classname, if not available, it will be initialized
		 */
		private static function initializeDefinedEnums(className:String, clazz:Class=null):void {
			if (!clazz) {
				try {
					clazz = ClassUtils.forName(className);
				} catch (e:Error) {
				}
			}
			// The class might not be available on class creation.
			// This method will then be called on request.
			if (clazz) {
				var obj:Object = _originalNames[className];
				// Just initialize it once
				if (!obj) {
					obj = _originalNames[className] = {};
					// Prevent "value.name" from calling this method again, infinite recursion.
					_initializing = true;

					// Collect the static readonly properties
					var properties:Object = ObjectUtils.merge(ClassUtils.getProperties(clazz, true, true, false), ClassUtils.getProperties(clazz, true, true, true));
					for (var property:String in properties) {
						var propClass:Class = properties[property];
						if (propClass == clazz || ClassUtils.isSubclassOf(propClass, clazz)) {
							// Mark the property as one defined in the class
							obj[QName(property).toString()] = true;

							// Initialze the value with its name
							var split:int = property.indexOf("::");
							var value:Enum;
							if (split > -1) {
								value = clazz[new QName(property.substr(0, split), property.substr(split + 2))];
							} else {
								value = clazz[property];
							}
							// Properties can be defined static yet be "null"
							if (value && !value._fixed) {
								value.name = property;
							}
						}
					}
					_initializing = false;
				}
			}
		}

		/**
		 * Returns the name of this enum.
		 */
		final public function get name():String {
			if (!_fixed) {
				initializeDefinedEnums(_declaringClassName);
				// Set fixed true, even if the name was not defined.
				_fixed = true;
			}
			return _name;
		}

		/**
		 * Sets the name for this enum.
		 * The name will be ignored if its empty.
		 *
		 * @throws IllegalArgumentError if the name has been set before.
		 */
		final public function set name(value:String):void {
			if (_fixed) {
				throw new IllegalArgumentError("The name of an enum value can only be set once.");
			}
			_name = StringUtils.trim(value);
			initializeEnum(value);
		}

		/**
		 * Index of the Enums, according to the time when they are properly named.
		 */
		final public function get index():int {
			return _index;
		}

		/**
		 * Returns the class name of this enum.
		 */
		final public function get declaringClassName():String {
			return _declaringClassName;
		}

		/**
		 * Checks if this enum is equal to the other passed in enum.
		 *
		 * To be equal, the 2 enums should be of the same type and should have the same name.
		 *
		 * @param other the other enum with which to compare
		 * @return true if this enum is equal to the other; false otherwise
		 */
		public function equals(other:Object):Boolean {
			if (this == other) {
				return true;
			} else if (other is Enum) {
				var that:Enum = Enum(other);
				return that._name == _name && that._declaringClassName == _declaringClassName;
			} else {
				return false;
			}
		}

		/**
		 * Returns a string representation of this enum.
		 */
		public function toString():String {
			return ("[" + _declaringClassName + "(" + _name + ")]");
		}

		/**
		 * Initiliazes the enum value.
		 */
		private function initializeEnum(name:String):void {
			// add the enum value if we have a valid name
			// this will only happen once for each unique enum value that is not null or empty
			if (!StringUtils.isEmpty(name) && !_fixed) {
				_fixed = true;

				// Initialize the Enums defined in the class
				if (!_initializing) {
					initializeDefinedEnums(_declaringClassName);
				}

				// initializeDefinedEnums might not have worked because the clas
				// is not readable during instantiation of the class (static properties) 
				var map:Object = _originalNames[_declaringClassName];
				if (map && !map[_name]) {
					trace("Warning: new Enum '" + _name + "' is not specified in " + _declaringClassName);
				}

				// create the lookup maps to store the enum values for this class
				var values:Object = _values[declaringClassName];
				var valueArray:Array;
				if (!values) {
					_values[declaringClassName] = values = {};
					_valueArrays[declaringClassName] = valueArray = [];
				} else {
					valueArray = _valueArrays[declaringClassName];
				}

				var equalityIndex:int = Enum.getIndex(this);

				// if this is a new enum, set its index to the number of same enum types
				// and add it to the lookup maps
				if (equalityIndex == -1) {
					// set the index on the enum
					_index = valueArray.length;

					// add the enum to the values array
					values[name] = this;
					valueArray.push(this);
				} else {
					// this enum is already created, set its index to the one found
					_index = equalityIndex;
				}
			}
		}
	}
}
