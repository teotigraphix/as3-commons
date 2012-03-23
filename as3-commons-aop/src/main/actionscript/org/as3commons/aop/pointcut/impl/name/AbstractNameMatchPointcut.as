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
package org.as3commons.aop.pointcut.impl.name {
	import org.as3commons.aop.pointcut.INameRegistry;

	/**
	 * Abstract base class for name match pointcuts.
	 *
	 * @author Christophe Herreman
	 */
	public class AbstractNameMatchPointcut implements INameRegistry {

		protected var nameMatcher:NameMatcher;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractNameMatchPointcut(nameOrNames:* = null) {
			nameMatcher = new NameMatcher(nameOrNames);
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		public function get numNames():uint {
			return nameMatcher.numNames;
		}

		public function get names():Vector.<String> {
			return nameMatcher.names;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function addName(name:String):void {
			nameMatcher.addName(name);
		}

		public function addNames(names:Vector.<String>):void {
			nameMatcher.addNames(names);
		}

		public function containsName(name:String):Boolean {
			return nameMatcher.containsName(name);
		}
	}
}
