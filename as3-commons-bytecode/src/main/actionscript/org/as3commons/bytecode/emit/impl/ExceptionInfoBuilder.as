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
package org.as3commons.bytecode.emit.impl {
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.emit.IExceptionInfoBuilder;

	public class ExceptionInfoBuilder implements IExceptionInfoBuilder {

		public function ExceptionInfoBuilder(exceptionInfo:ExceptionInfo=null) {
			super();
			_exceptionInfo = exceptionInfo ||= new ExceptionInfo();
		}

		private var _exceptionInfo:ExceptionInfo;

		public function get codePositionToJumpToOnException():int {
			return _exceptionInfo.codePositionToJumpToOnException;
		}

		public function set codePositionToJumpToOnException(value:int):void {
			_exceptionInfo.codePositionToJumpToOnException = value;
		}

		public function get exceptionEnabledFromCodePosition():int {
			return _exceptionInfo.exceptionEnabledFromCodePosition;
		}

		public function set exceptionEnabledFromCodePosition(value:int):void {
			_exceptionInfo.exceptionEnabledFromCodePosition = value;
		}

		public function get exceptionEnabledFromOpcode():Op {
			return _exceptionInfo.exceptionEnabledFromOpcode;
		}

		public function set exceptionEnabledFromOpcode(value:Op):void {
			_exceptionInfo.exceptionEnabledFromOpcode = value;
		}

		public function get exceptionEnabledToCodePosition():int {
			return _exceptionInfo.exceptionEnabledToCodePosition;
		}

		public function set exceptionEnabledToCodePosition(value:int):void {
			_exceptionInfo.exceptionEnabledToCodePosition = value;
		}

		public function get exceptionEnabledToOpcode():Op {
			return _exceptionInfo.exceptionEnabledToOpcode;
		}

		public function set exceptionEnabledToOpcode(value:Op):void {
			_exceptionInfo.exceptionEnabledToOpcode = value;
		}

		public function get exceptionType():QualifiedName {
			return _exceptionInfo.exceptionType;
		}

		public function set exceptionType(value:QualifiedName):void {
			_exceptionInfo.exceptionType = value;
		}

		public function get opcodeToJumpToOnException():Op {
			return _exceptionInfo.opcodeToJumpToOnException;
		}

		public function set opcodeToJumpToOnException(value:Op):void {
			_exceptionInfo.opcodeToJumpToOnException = value;
		}

		public function get variableReceivingException():QualifiedName {
			return _exceptionInfo.variableReceivingException;
		}

		public function set variableReceivingException(value:QualifiedName):void {
			_exceptionInfo.variableReceivingException = value;
		}

		public function build():ExceptionInfo {
			return _exceptionInfo;
		}
	}
}
