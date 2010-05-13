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
package org.as3commons.emit.bytecode {

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;

	/**
	 * Utility methods related to bytecode generation.
	 *
	 * @author Richard Szalay
	 * @author Andrew Lewisohn
	 */
	public class ByteCodeUtils {

		//--------------------------------------------------------------------
		//
		// Class methods
		//
		//--------------------------------------------------------------------

		/**
		 * Examines a package string such as <code>flash.events.*</code> and compares
		 * it to the package string of a class.
		 *
		 * @param pkg A string representing a package.
		 * @param cls Can be either <code>String</code>, <code>Class</code>, or an
		 * 	instance of a class.
		 * @return  <code>true</code>, if the packages match.
		 */
		public static function packagesMatch(pkg:String, cls:*):Boolean {
			var classString:String = null;

			if (cls is String) {
				classString = (cls as String).replace("::", ".");
			} else if (cls is Class) {
				classString = ClassUtils.getFullyQualifiedName(cls, true);
			} else {
				classString = ObjectUtils.getFullyQualifiedClassName(cls, true);
			}

			var packageParts:Array = pkg.split('.');
			var classParts:Array = classString.split('.');

			for (var i:uint = 0; i < packageParts.length && i < classParts.length; i++) {
				if (packageParts[i] == '*') {
					return true;
				}

				if (packageParts[i] != classParts[i]) {
					return false;
				}
			}

			return (packageParts.length == classParts.length);
		}
	}
}