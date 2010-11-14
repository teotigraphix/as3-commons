/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.typeinfo {
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.StringUtils;

	/**
	 * Represents the definition for a field within a class (Slots or Constants).
	 */
	public class Field extends Annotatable {
		public var fieldName:QualifiedName;
		public var type:QualifiedName;

		public function Field(fieldNameValue:QualifiedName, typeValue:QualifiedName) {
			fieldName = fieldNameValue;
			type = typeValue;
		}

		public function toString():String {
			return StringUtils.substitute("{0} var {1} : {2}:{3};", fieldName.nameSpace.kind.description, fieldName.name, type.nameSpace.name, type.name);
		}
	}
}