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
	import org.as3commons.bytecode.abc.enum.Opcode;

	/**
	 * Represents an individual opcode operation with parameters.
	 */
	public class Op {
		private var _parameters:Array;
		private var _opcode:Opcode;

		public function Op(opcode:Opcode, parameters:Array) {
			_opcode = opcode;
			_parameters = parameters;
		}

		public function get parameters():Array {
			return _parameters;
		}

		public function get opcode():Opcode {
			return _opcode;
		}

		public function toString():String {
			return _opcode.opcodeName + "\t\t" + ((_parameters.length != 0) ? "[" + _parameters.join(", ") + "]" : "");
		}
	}
}