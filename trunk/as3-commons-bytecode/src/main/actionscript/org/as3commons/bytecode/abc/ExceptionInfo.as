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
package org.as3commons.bytecode.abc {
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;

	/**
	 * as3commons-bytecode representation of <code>exception_info</code> in the ABC file format.
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Exception" in the AVM Spec (page 34)
	 */
	public final class ExceptionInfo implements ICloneable, IEquals {

		public var exceptionEnabledFromCodePosition:int;
		public var exceptionEnabledFromOpcode:Op;

		public var exceptionEnabledToCodePosition:int;
		public var exceptionEnabledToOpcode:Op;

		public var codePositionToJumpToOnException:int;
		public var opcodeToJumpToOnException:Op;

		public var exceptionType:QualifiedName;
		public var variableReceivingException:QualifiedName;

		public function ExceptionInfo() {
			super();
		}

		public function clone():* {
			var clone:ExceptionInfo = new ExceptionInfo();
			clone.exceptionEnabledFromCodePosition = exceptionEnabledFromCodePosition;
			clone.exceptionEnabledFromOpcode = exceptionEnabledFromOpcode.clone() as Op;

			clone.exceptionEnabledToCodePosition = exceptionEnabledToCodePosition;
			clone.exceptionEnabledToOpcode = exceptionEnabledToOpcode.clone() as Op;

			clone.codePositionToJumpToOnException = codePositionToJumpToOnException;
			clone.opcodeToJumpToOnException = opcodeToJumpToOnException.clone() as Op;

			clone.exceptionType = exceptionType.clone() as QualifiedName;
			clone.variableReceivingException = variableReceivingException.clone() as QualifiedName;
			return clone;
		}

		public function toString():String {
			return "ExceptionInfo{exceptionEnabledFromCodePosition:" + exceptionEnabledFromCodePosition + ", exceptionEnabledToCodePosition:" + exceptionEnabledToCodePosition + ", codePositionToJumpToOnException:" + codePositionToJumpToOnException + ", exceptionTypeName:\"" + exceptionType + "\", nameOfVariableReceivingException:\"" + variableReceivingException + "\"}";
		}

		public function equals(other:Object):Boolean {
			var otherInfo:ExceptionInfo = other as ExceptionInfo;
			if (otherInfo != null) {
				if (exceptionEnabledFromCodePosition != otherInfo.exceptionEnabledFromCodePosition) {
					return false;
				}
				if (!exceptionEnabledFromOpcode.equals(otherInfo.exceptionEnabledFromOpcode)) {
					return false;
				}
				if (exceptionEnabledToCodePosition != otherInfo.exceptionEnabledToCodePosition) {
					return false;
				}
				if (!exceptionEnabledToOpcode.equals(otherInfo.exceptionEnabledToOpcode)) {
					return false;
				}
				if (codePositionToJumpToOnException != otherInfo.codePositionToJumpToOnException) {
					return false;
				}
				if (!opcodeToJumpToOnException.equals(otherInfo.opcodeToJumpToOnException)) {
					return false;
				}
				if (!exceptionType.equals(otherInfo.exceptionType)) {
					return false;
				}
				if (!variableReceivingException.equals(otherInfo.variableReceivingException)) {
					return false;
				}
				return true;
			}
			return false;
		}


	}
}
