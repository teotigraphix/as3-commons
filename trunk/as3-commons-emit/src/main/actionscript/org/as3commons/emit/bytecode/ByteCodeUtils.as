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
		
		if(cls is String) {
			classString = (cls as String).replace("::", ".");
		} else if(cls is Class) {
			classString = ClassUtils.getFullyQualifiedName(cls, true);
		} else {
			classString = ObjectUtils.getFullyQualifiedClassName(cls, true);
		}
		
		var packageParts:Array = pkg.split('.');
		var classParts:Array = classString.split('.');
		
		for(var i:uint = 0; i < packageParts.length && i < classParts.length; i++) {
			if(packageParts[i] == '*') {
				return true;
			}
			
			if(packageParts[i] != classParts[i]) {
				return false;
			}
		}
		
		return (packageParts.length == classParts.length);
	}
}
}