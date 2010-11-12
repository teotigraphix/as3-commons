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
package org.as3commons.bytecode.abc {
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.enum.Opcode;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class JumpTargetData {

		private var _jumpOpcodePosition:OpcodePosition;
		private var _targetOpcodePosition:OpcodePosition;
		private var _extraOpcodePositions:Array;

		public function get extraOpcodePositions():Array {
			return _extraOpcodePositions;
		}

		/**
		 * The bytecode position directly after the <code>jumpOpcode<code> and its arguments.
		 */
		public function get jumpOpcodePosition():uint {
			return _jumpOpcodePosition.position;
		}

		/**
		 * The <code>Opcode</code> that will be jumped to if the <code>jumpOpcode</code> is executed.
		 */
		public function get targetOpcode():Op {
			return _targetOpcodePosition.opcode;
		}

		/**
		 * The bytecode position directly before the <code>targetOpcode</code>.
		 */
		public function get targetOpcodePosition():uint {
			return _targetOpcodePosition.position;
		}

		/**
		 * @private
		 */
		public function set targetOpcode(op:Op):void {
			_targetOpcodePosition.opcode = op;
		}

		/**
		 * @private
		 */
		public function set targetOpcodePosition(pos:uint):void {
			_targetOpcodePosition.position = pos;
		}

		public function JumpTargetData(jumpOp:Op = null, jumpOpcodePos:uint = 0, targetOp:Op = null, targetOpcodePos:uint = 0) {
			super();
			_jumpOpcodePosition = new OpcodePosition(jumpOp, jumpOpcodePos);
			_targetOpcodePosition = new OpcodePosition(targetOp, targetOpcodePos);
		}

		public function addTarget(targetOp:Op = null, targetOpcodePos:uint = 0):void {
			if (_extraOpcodePositions == null) {
				_extraOpcodePositions = [];
			}
			var opcodePos:OpcodePosition = new OpcodePosition(targetOp, targetOpcodePos);
			if (_targetOpcodePosition != null) {
				_extraOpcodePositions[_extraOpcodePositions.length] = opcodePos;
			} else {
				_targetOpcodePosition = opcodePos;
			}
		}

		/**
		 * The <code>Opcode</code> triggering the jump.
		 */
		public function get jumpOpcode():Op {
			return _jumpOpcodePosition.opcode;
		}

		/**
		 * @private
		 */
		public function set jumpOpcode(value:Op):void {
			_jumpOpcodePosition.opcode = value;
			if ((_jumpOpcodePosition.opcode != null) && (Opcode.jumpOpcodes[_jumpOpcodePosition.opcode.opcode] == null)) {
				throw new IllegalOperationError("Opcode " + _jumpOpcodePosition.opcode.opcode.opcodeName + " is not a jump code");
			}
		}

		/**
		 * Returns <code>true</code> if the jumplocation defined by the <code>jumpOpcode</code>
		 * matches the location of the <code>targetOpcode</code>.
		 * @return <code>True</code> if the jumplocation defined by the <code>jumpOpcode</code>
		 * matches the location of the <code>targetOpcode</code>.
		 */
		public function validate():Boolean {
			if ((_jumpOpcodePosition != null) && (_targetOpcodePosition != null)) {
				var jumpLocation:int = int(_jumpOpcodePosition.opcode.parameters[0]);
				return (jumpLocation == (_targetOpcodePosition.position - _jumpOpcodePosition.position));
			}
			return false;
		}

	}
}