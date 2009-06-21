/*
 * Copyright (c) 2009 the original author or authors
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
package org.as3commons.lang {
	
	/**
	 * Provides utility methods for working with Object objects.
	 *
	 * @author Christophe Herreman
	 */
	public class ObjectUtils {
		
		/**
		 * @private
		 */
		public function ObjectUtils() {
		}
		
		/**
		 * Returns whether or not the given object is simple data type.
		 *
		 * @param the object to check
		 * @return true if the given object is a simple data type; false if not
		 */
		public static function isSimple(object:Object):Boolean {
			switch (typeof(object)) {
				case "number":
				case "string":
				case "boolean":
					return true;
				case "object":
					return (object is Date) || (object is Array);
			}
			
			return false;
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
	}
}