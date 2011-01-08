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
package org.as3commons.bytecode.tags {
	import org.as3commons.lang.StringUtils;

	public class EndTag extends AbstractTag {

		public static const TAG_ID:uint = 0;
		private static const TAG_NAME:String = "End";

		public function EndTag() {
			super(TAG_ID, TAG_NAME);
		}

		public function toString():String {
			return StringUtils.substitute("[EndTag(id={0},name={1})]", id, name);
		}

	}
}