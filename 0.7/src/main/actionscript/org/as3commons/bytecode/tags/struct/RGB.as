/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.tags.struct {

	public class RGB {

		private var _red:uint;
		private var _green:uint;
		private var _blue:uint;

		public function RGB() {
			super();
		}

		public function get red():uint {
			return _red;
		}

		public function set red(value:uint):void {
			_red = value;
		}

		public function get green():uint {
			return _green;
		}

		public function set green(value:uint):void {
			_green = value;
		}

		public function get blue():uint {
			return _blue;
		}

		public function set blue(value:uint):void {
			_blue = value;
		}

	}
}