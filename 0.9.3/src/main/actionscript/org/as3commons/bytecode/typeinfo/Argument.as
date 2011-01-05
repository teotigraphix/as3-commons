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
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.lang.ICloneable;

	/**
	 * Represents an argument to a method, including its type, name, optional status, default value (if optional), and kind.
	 */
	//TODO: Set this up so that the user does not need to worry about the ConstantKind. You should be able to determine this from the default value 
	public class Argument implements ICloneable {

		public var classDefinition:ClassDefinition;
		public var name:String;
		public var defaultValue:Object;
		public var isOptional:Boolean;
		public var kind:ConstantKind;

		public var type:QualifiedName;

		public function Argument(typeValue:QualifiedName = null, hasOptionalValue:Boolean = false, defaultVal:Object = null, defaultValueKind:ConstantKind = null) {
			super();
			initArgument(typeValue, hasOptionalValue, defaultVal, defaultValueKind);
		}

		protected function initArgument(typeValue:QualifiedName, hasOptionalValue:Boolean, defaultVal:Object, defaultValueKind:ConstantKind):void {
			type = typeValue;
			isOptional = hasOptionalValue;
			defaultValue = defaultVal;
			kind = defaultValueKind;
		}

		public function clone():* {
			return new Argument(type, isOptional, defaultValue, kind);
		}

		public function toString():String {
			return type + "";
		}
	}
}