/*
* Copyright 2007-2011 the original author or authors.
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
	 * Default implementation of INameRegistry.
	 *
	 * @author Christophe Herreman
	 */
	public class NameRegistry implements INameRegistry {

		private var _names:Vector.<String> = new Vector.<String>();

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function NameRegistry(nameOrNames:* = null) {
			if (nameOrNames is String) {
				addName(nameOrNames);
			} else if (nameOrNames is Vector.<String>) {
				addNames(nameOrNames);
			} else if (nameOrNames is Array) {
				addNamesFromArray(nameOrNames as Array);
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		public function get numNames():uint {
			return _names.length;
		}

		public function get names():Vector.<String> {
			return _names.concat();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function addName(name:String):void {
			_names.push(name);
		}

		public function addNames(names:Vector.<String>):void {
			for each (var name:String in names) {
				addName(name);
			}
		}

		public function removeName(name:String):void {
			//TODO
		}

		public function containsName(name:String):Boolean {
			return (_names.indexOf(name) > -1);
		}
		
		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------
		
		private function addNamesFromArray(names:Array):void {
			for each (var name:String in names) {
				addName(name);
			}
		}
		
	}
}
