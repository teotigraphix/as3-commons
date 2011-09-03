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
package org.as3commons.bytecode.abc {
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.enum.Opcode;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public final class JumpTargetData {

		private var _jumpOpcode:Op;
		private var _targetOpcode:Op;
		private var _extraOpcodes:Array;

		public function get extraOpcodes():Array {
			return _extraOpcodes;
		}

		/**
		 * The <code>Opcode</code> that will be jumped to if the <code>jumpOpcode</code> is executed.
		 */
		public function get targetOpcode():Op {
			return _targetOpcode;
		}

		/**
		 * @private
		 */
		public function set targetOpcode(op:Op):void {
			_targetOpcode = op;
		}

		public function JumpTargetData(jumpOp:Op=null, targetOp:Op=null) {
			super();
			_jumpOpcode = jumpOp;
			_targetOpcode = targetOp;
		}

		public function addTarget(targetOp:Op):void {
			if (targetOp == null) {
				return;
			}
			if (_targetOpcode != null) {
				_extraOpcodes ||= [];
				_extraOpcodes[_extraOpcodes.length] = targetOp;
			} else {
				_targetOpcode = targetOp;
			}
		}

		/**
		 * The <code>Opcode</code> triggering the jump.
		 */
		public function get jumpOpcode():Op {
			return _jumpOpcode;
		}

		/**
		 * @private
		 */
		public function set jumpOpcode(value:Op):void {
			_jumpOpcode = value;
			if ((_jumpOpcode != null) && (Opcode.jumpOpcodes[_jumpOpcode.opcode] == null)) {
				throw new IllegalOperationError("Opcode " + _jumpOpcode.opcode.opcodeName + " is not a jump code");
			}
		}

	}
}
