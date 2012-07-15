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
package org.as3commons.bytecode.testclasses {

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class ClassWithVectorTypedProperty {

		/**
		 * Creates a new <code>ClassWithVectorTypedProperty</code> instance.
		 */
		public function ClassWithVectorTypedProperty() {
			super();
		}

		private var _integers:Vector.<int>;
		private var _stuff:Vector.<IntroductionImpl>;

		public function get stuff():Vector.<IntroductionImpl> {
			return _stuff;
		}

		public function set stuff(value:Vector.<IntroductionImpl>):void {
			_stuff = value;
		}

		public function get integers():Vector.<int> {
			return _integers;
		}

		public function set integers(value:Vector.<int>):void {
			_integers = value;
		}
	}
}
