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
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;

	/**
	 * Represents an argument to a method, including its type, name, optional status, default value (if optional), and kind.
	 */
	//TODO: Set this up so that the user does not need to worry about the ConstantKind. You should be able to determine this from the default value 
	public final class Argument implements ICloneable, IEquals {

		public var name:String;
		public var defaultValue:*;
		public var isOptional:Boolean;
		public var kind:ConstantKind;
		public var type:BaseMultiname;

		public function Argument(typeValue:BaseMultiname=null, hasOptionalValue:Boolean=false, defaultVal:*=null, defaultValueKind:ConstantKind=null) {
			super();
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

		public function equals(other:Object):Boolean {
			var otherArg:Argument = other as Argument;
			if (otherArg != null) {
				if (name != otherArg.name) {
					return false;
				}
				if (!isNaN(defaultValue)) {
					if (defaultValue !== otherArg.defaultValue) {
						return false;
					}
				} else if (isNaN(defaultValue) && isNaN(otherArg.defaultValue) == false) {
					return false;
				}
				if (isOptional != otherArg.isOptional) {
					return false;
				}
				if (kind !== otherArg.kind) {
					return false;
				}
				if (!type.equals(otherArg.type)) {
					return false;
				}
				return true;
			}
			return false;
		}
	}
}
