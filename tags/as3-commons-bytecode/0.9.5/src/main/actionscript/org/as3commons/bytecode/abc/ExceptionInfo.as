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

	/**
	 * as3commons-bytecode representation of <code>exception_info</code> in the ABC file format.
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Exception" in the AVM Spec (page 34)
	 */
	public class ExceptionInfo implements ICloneable {

		public var exceptionEnabledFromCodePosition:int;
		public var exceptionEnabledToCodePosition:int;
		public var codePositionToJumpToOnException:int;
		public var exceptionType:QualifiedName;
		public var variableReceivingException:QualifiedName;

		public function ExceptionInfo() {
			super();
		}

		public function clone():* {
			var clone:ExceptionInfo = new ExceptionInfo();
			clone.exceptionEnabledFromCodePosition = exceptionEnabledFromCodePosition;
			clone.exceptionEnabledToCodePosition = exceptionEnabledToCodePosition;
			clone.codePositionToJumpToOnException = codePositionToJumpToOnException;
			clone.exceptionType = exceptionType;
			clone.variableReceivingException = variableReceivingException;
			return clone;
		}

		public function toString():String {
			return "ExceptionInfo{exceptionEnabledFromCodePosition:" + exceptionEnabledFromCodePosition + ", exceptionEnabledToCodePosition:" + exceptionEnabledToCodePosition + ", codePositionToJumpToOnException:" + codePositionToJumpToOnException + ", exceptionTypeName:\"" + exceptionType + "\", nameOfVariableReceivingException:\"" + variableReceivingException + "\"}";
		}


	}
}