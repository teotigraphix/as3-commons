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

	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * Provides utility methods for working with Object objects.
	 *
	 * @author Christophe Herreman
	 * @author James Ghandour
	 */
	public final class ObjectUtils {

		public static const DOT:String = '.';
		public static const NUMBER_CLASSNAME:String = "number";
		public static const STRING_FIELD_NAME:String = "string";
		public static const BOOLEAN_FIELD_NAME:String = "boolean";
		public static const OBJECT_FIELD_NAME:String = "object";
		public static const VARIABLE_ELEMENT_NAME:String = "variable";

		/**
		 * Returns whether or not the given object is simple data type.
		 *
		 * @param the object to check
		 * @return true if the given object is a simple data type; false if not
		 */
		public static function isSimple(object:Object):Boolean {
			switch (typeof(object)) {
				case NUMBER_CLASSNAME:
				case STRING_FIELD_NAME:
				case BOOLEAN_FIELD_NAME:
					return true;
				case OBJECT_FIELD_NAME:
					return (object is Date) || (object is Array);
			}

			return false;
		}

		/**
		 * Returns a dictionary of key and values of this object.
		 */
		public static function toDictionary(instance:Object):Dictionary {
			var result:Dictionary = new Dictionary();
			for each (var key:* in getKeys(instance)) {
				result[key] = instance[key];
			}
			return result;
		}

		/**
		 * Returns an array with the keys of this object.
		 */
		public static function getKeys(object:Object):Array {
			var result:Array = [];

			for (var k:* in object) {
				result.push(k);
			}
			return result;
		}

		/**
		 * Returns the number of properties in the given object.
		 *
		 * @param object the object for which to get the number of properties
		 * @return the number of properties in the given object
		 */
		public static function getNumProperties(object:Object):int {
			var result:int = 0;

			for (var p:String in object) {
				result++;
			}
			return result;
		}

		/**
		 * Returns an array with the properties of the given object.
		 */
		public static function getProperties(object:Object):Array {
			var result:Array = [];

			for each (var p:Object in object) {
				result.push(p);
			}
			return result;
		}

		/**
		 *
		 */
		public static function clone(object:Object):* {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			byteArray.position = 0;
			return byteArray.readObject();
		}


        /**
         * Compares two objects based on their serialized AMF representation
         *
         * @param object The object to compare
         * @param other The object to compare to
         *
         * @return true if equal, false if not
         */
        public static function compare(object:Object, other:Object):Boolean {
            var objectByteArray:ByteArray = new ByteArray();
            var otherByteArray:ByteArray = new ByteArray();

            objectByteArray.writeObject(object);
            otherByteArray.writeObject(other);

            var size:uint = objectByteArray.length;

            if (objectByteArray.length == otherByteArray.length) {
                objectByteArray.position = 0;
                otherByteArray.position = 0;

                while (objectByteArray.position < size) {
                    if (objectByteArray.readByte() != otherByteArray.readByte()) {
                        return false;
                    }
                }
            }

            return (objectByteArray.toString() == otherByteArray.toString());
        }

		/**
		 * Converts a plain vanilla object to be an instance of the class
		 * passed as the second variable.  This is not a recursive function
		 * and will only work for the first level of nesting.  When you have
		 * deeply nested objects, you first need to convert the nested
		 * objects to class instances, and then convert the top level object.
		 *
		 * TODO: This method can be improved by making it recursive.  This would be
		 * done by looking at the typeInfo returned from describeType and determining
		 * which properties represent custom classes.  Those classes would then
		 * be registerClassAlias'd using getDefinititonByName to get a reference,
		 * and then objectToInstance would be called on those properties to complete
		 * the recursive algorithm.
		 * http://www.darronschall.com/weblog/archives/000247.cfm
		 *
		 * @author Darron Schall
		 *
		 * @param object The plain object that should be converted
		 * @param clazz The type to convert the object to
		 */
		public static function toInstance(object:Object, clazz:Class):* {
			var bytes:ByteArray = new ByteArray();
			bytes.objectEncoding = ObjectEncoding.AMF0;

			// Find the objects and byetArray.writeObject them, adding in the
			// class configuration variable name -- essentially, we're constructing
			// an AMF packet here that contains the class information so that
			// we can simplly byteArray.readObject the sucker for the translation

			// Write out the bytes of the original object
			var objBytes:ByteArray = new ByteArray();
			objBytes.objectEncoding = ObjectEncoding.AMF0;
			objBytes.writeObject(object);

			// Register all of the classes so they can be decoded via AMF
			var typeInfo:XML = describeType(clazz);
			var fullyQualifiedName:String = typeInfo.@name.toString().replace(/::/, ".");
			registerClassAlias(fullyQualifiedName, clazz);

			// Write the new object information starting with the class information
			var len:int = fullyQualifiedName.length;
			bytes.writeByte(0x10); // 0x10 is AMF0 for "typed object (class instance)"
			bytes.writeUTF(fullyQualifiedName);
			// After the class name is set up, write the rest of the object
			bytes.writeBytes(objBytes, 1);

			// Read in the object with the class property added and return that
			bytes.position = 0;

			// This generates some ReferenceErrors of the object being passed in
			// has properties that aren't in the class instance, and generates TypeErrors
			// when property values cannot be converted to correct values (such as false
			// being the value, when it needs to be a Date instead).  However, these
			// errors are not thrown at runtime (and only appear in trace ouput when
			// debugging), so a try/catch block isn't necessary.  I'm not sure if this
			// classifies as a bug or not... but I wanted to explain why if you debug
			// you might seem some TypeError or ReferenceError items appear.
			var result:* = bytes.readObject();
			return result;
		}

		/**
		 * Checks if the given object is an explicit instance of the given class.
		 *
		 * <p>That means that true will only be returned if the object
		 * was instantiated directly from the given class.</p>
		 *
		 * @param object the object to check
		 * @param clazz the class from which the object should be an explicit instance
		 * @return true if the object is an explicit instance of the class, false if not
		 */
		public static function isExplicitInstanceOf(object:Object, clazz:Class):Boolean {
			var c:Class = ClassUtils.forInstance(object);
			return (c === clazz);
		}

		/**
		 * Returns the class name of the given object.
		 */
		public static function getClassName(object:Object):String {
			return ClassUtils.getName(ClassUtils.forInstance(object));
		}

		/**
		 * Returns the fully qualified class name of the given object.
		 */
		public static function getFullyQualifiedClassName(object:Object, replaceColons:Boolean=false):String {
			return ClassUtils.getFullyQualifiedName(ClassUtils.forInstance(object), replaceColons);
		}

		/**
		 * Returns an object iterator
		 */
		public static function getIterator(instance:Object):IIterator {
			var name:String = getFullyQualifiedClassName(instance);
			var keys:XMLList;

			if ((keys = ObjectIterator.getDescription(name)) == null) {
				var description:XML = describeType(instance);
				keys = description.descendants(VARIABLE_ELEMENT_NAME).@name + description.descendants("accessor").(@access == "readwrite").@name;
				ObjectIterator.setDescription(name, keys);
			}

			return new ObjectIterator(instance, keys);
		}

		/**
		 * Returns the value of a property that is specified by a property chain. I.e. <code>myVariable.myField.myValue</code>.<br/>
		 * This method will fail if one of the property values in the chain is null.
		 * @param chain A string representing a property chain. I.e. <code>myVariable.myField.myValue</code>.
		 * @param targetObject The instance that represents the start of the chain. So in the case of <code>myVariable.myField.myValue</code> the target instance would be the object that has a property called <code>myVariable</code>.
		 * @return The value of the last property in the specified property chain. So in the case of <code>myVariable.myField.myValue</code> this would be the value of <code>myValue</code>.
		 */
		public static function resolvePropertyChain(chain:String, targetInstance:Object):* {
			var propertyNames:Array = chain.split(DOT);
			var field:String = String(propertyNames.pop());
			var propName:String;
			for each (propName in propertyNames) {
				targetInstance = targetInstance[propName];
			}
			return targetInstance[field];
		}

		/**
		 * Merges two objects to become one.
		 *
		 * @param objectA Master object, overrides properties of <code>objectB</code>
		 * @param objectB Slave object, just properties that not part of <code>objectA</code> will be taken.
		 * @return a Object that contains all properties of objectA and objectB
		 */
		public static function merge(objectA:Object, objectB:Object):Object {
			var result:Object = {};
			var prop:String;
			for (prop in objectB) {
				result[prop] = objectB[prop];
			}
			for (prop in objectA) {
				result[prop] = objectA[prop];
			}
			return result;
		}
	}
}
