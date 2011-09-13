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
package org.as3commons.aop.pointcut.impl.regexp {

	/**
	 * Abstract base class for regular expression pointcuts.
	 *
	 * @author Christophe Herreman
	 */
	public class AbstractRegExpPointcut {

		private var _patterns:Vector.<String>;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractRegExpPointcut() {
			_patterns = new Vector.<String>();
		}

		public function set pattern(value:String):void {
			_patterns = new Vector.<String>();
			addPattern(value);
		}

		public function set patterns(value:Vector.<String>):void {
			_patterns = value.concat();
		}

		public function addPattern(pattern:String):void {
			_patterns.push(pattern);
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function match(value:String):Boolean {
			for each (var pattern:String in _patterns) {
				var regExp:RegExp = new RegExp(pattern);
				if (regExp.test(value)) {
					return true;
				}
			}
			return false;
		}
	}
}
