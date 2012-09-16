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
package org.as3commons.reflect {

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class Parameter {

		private var _base:BaseParameter;
		private var _index:int;

		/**
		 * Creates a new <code>Parameter</code> instance.
		 */
		public function Parameter(base:BaseParameter, index:int) {
			super();
			_base = base;
			_index = index;
		}

		public function get isOptional():Boolean {
			return _base.isOptional;
		}

		public function get type():Type {
			return _base.type;
		}

		public function get index():int {
			return _index;
		}

	}
}
