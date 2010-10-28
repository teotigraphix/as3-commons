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
package org.as3commons.bytecode.tags {

	public class ScriptLimitsTag extends AbstractTag {
		public static const TAG_ID:uint = 65;
		private static const TAG_NAME:String = "ScriptLimits";

		private var _maxRecursionDepth:uint;
		private var _scriptTimeoutSeconds:uint;

		public function ScriptLimitsTag() {
			super(TAG_ID, TAG_NAME);
		}

		public function get maxRecursionDepth():uint {
			return _maxRecursionDepth;
		}

		public function set maxRecursionDepth(value:uint):void {
			_maxRecursionDepth = value;
		}

		public function get scriptTimeoutSeconds():uint {
			return _scriptTimeoutSeconds;
		}

		public function set scriptTimeoutSeconds(value:uint):void {
			_scriptTimeoutSeconds = value;
		}

	}
}