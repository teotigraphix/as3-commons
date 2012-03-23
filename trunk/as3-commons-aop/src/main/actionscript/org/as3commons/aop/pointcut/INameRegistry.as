/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.aop.pointcut {

	/**
	 * Defines a registry for names (String) and provides methods to query and modify.
	 *
	 * @author Christophe Herreman
	 */
	public interface INameRegistry {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The number of names in this registry.
		 */
		function get numNames():uint;

		/**
		 * Returns a copy of the names in this registry.
		 */
		function get names():Vector.<String>;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds the given name to this registry.
		 * @param name
		 * @throws org.as3commons.lang.IllegalArgumentError if the name is null or empty (after trimming)
		 */
		function addName(name:String):void;

		/**
		 * Adds the given names to this registry.
		 * @param names
		 * @throws org.as3commons.lang.IllegalArgumentError if one fo the names is null or empty (after trimming)
		 */
		function addNames(names:Vector.<String>):void;

		/**
		 * Returns whether or not this registry contains the given name.
		 * @param name
		 * @return true if the registry contains the name; false if not
		 */
		function containsName(name:String):Boolean;

	}
}
