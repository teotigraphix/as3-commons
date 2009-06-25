/*
 * Copyright 2007-2009 the original author or authors.
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
	 * @author Christophe Herreman
	 */
	public class Enum implements IEquals {
		
		private static var _values:Object = {};
		
		private var _name:String;
		
		private var _declaringClassName:String;
		
		/**
		 * Creates a new Enum object.
		 *
		 * <p>A new enum value is allowed to receive a empty string or null as its name. This is to
		 * make it possible to deserialize external data (from a remote object for instance) in which
		 * an Enum instance will be created without name and the name will be set via the name setter.
		 * The name can only be set to a non-null or non-empty value only once though.</b>
		 *
		 * @param name the name of the enum value
		 */
		public function Enum(name:String = "") {
			this.name = name;
		}
		
		/**
		 * Returns the values of the enumeration of the given Class.
		 *
		 * @param clazz the class for which to return all enum values
		 * @return an array of Enum objects or Enum subtype objects
		 */
		public static function getValues(clazz:Class):Array {
			Assert.notNull(_values[getQualifiedClassName(clazz)], "Enum values for the class '" + clazz + "' do not exist");
			return ObjectUtils.getProperties(_values[getQualifiedClassName(clazz)]);
		}
		
		/**
		 * Returns the enum entry for the given class by its name.
		 *
		 * @param clazz the class that defines the enumeration
		 * @param name the name of the enum entry to get
		 */
		public static function getEnum(clazz:Class, name:String):Enum {
			Assert.notNull(clazz, "The class must not be null");
			Assert.hasText(name, "The name must have text");
			
			var className:String = ClassUtils.getFullyQualifiedName(clazz);
			
			Assert.notNull(_values[className], "Enum values for the class '" + clazz + "' do not exist");
			Assert.notNull(_values[className][name], "An enum for type '" + clazz + "' and name '" + name + "' was not found.");
			
			return _values[className][name];
		}
		
		/**
		 * Returns the name of this enum.
		 */
		final public function get name():String {
			return _name;
		}
		
		/**
		 * Sets the name for this enum.
		 */
		final public function set name(value:String):void {
			Assert.state(name == null || name == "", "The name of an enum value can only be set once.");
			
			_name = StringUtils.trim(value);
			
			// add the enum value if we have a valid name
			// this will only happen once for each unique enum value that is not null or empty
			if (!StringUtils.isEmpty(name)) {
				if (!_values[declaringClassName]) {
					_values[declaringClassName] = {};
				}
				
				if (!_values[declaringClassName][name]) {
					_values[declaringClassName][name] = this;
				}
			}
		}
		
		/**
		 * Returns the class name of this enum.
		 */
		final public function get declaringClassName():String {
			if (!_declaringClassName) {
				_declaringClassName = getQualifiedClassName(this);
			}
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
			}
			
			if (!(other is Enum)) {
				return false;
			}
			
			// types do not match?
			if (!(other is ClassUtils.forInstance(this))) {
				return false;
			}
			
			return (name == Enum(other).name);
		}
		
		/**
		 * Returns a string representation of this enum.
		 */
		public function toString():String {
			var clazz:Class = ClassUtils.forInstance(this);
			var className:String = ClassUtils.getName(clazz);
			return ("[" + className + "(" + name + ")]");
		}
	
	}
}