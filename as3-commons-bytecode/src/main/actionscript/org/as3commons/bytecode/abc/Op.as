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
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.StringUtils;

	/**
	 * Represents an individual opcode operation with parameters.
	 */
	public final class Op implements ICloneable, IEquals {

		private static const ARGUMENT_TYPE_ERROR:String = "Wrong opcode argument type for opcode {0}, expected {1}, but got {2}";
		private static const OBJECT_TYPE_NAME:String = "object";

		private var _parameters:Array;
		private var _opcode:Opcode;

		public function Op(opcode:Opcode, parameters:Array=null) {
			super();
			_opcode = opcode;
			_parameters = parameters ||= [];
		}

		public function clone():* {
			var params:Array = [];
			for each (var obj:* in _parameters) {
				if (obj is ICloneable) {
					params[params.length] = ICloneable(obj).clone();
				} else {
					params[params.length] = obj;
				}
			}
			var clone:Op = _opcode.op(params);
			clone.baseLocation = baseLocation;
			return clone;
		}

		public static function checkParameters(parameters:Array, opcode:Opcode):void {
			if (parameters.length > 0) {
				var len:uint = parameters.length;
				for (var i:uint = 0; i < len; i++) {
					if (!compareTypes(parameters[i], opcode.argumentTypes[i][0])) {
						throw new IllegalOperationError(StringUtils.substitute(ARGUMENT_TYPE_ERROR, opcode, opcode.argumentTypes[i][0], parameters[i]));
					}
				}
			}
		}

		private static function compareTypes(instance:*, type:*):Boolean {
			if ((type === int) || (type === Integer)) {
				return (instance is int);
			} else if ((type === uint) || (type === UnsignedInteger)) {
				return (instance is uint);
			} else if (type === Number) {
				return (instance is Number);
			} else if (type === String) {
				return (instance is String);
			} else if (type === Array) {
				return (instance is Array);
			} else {
				if (type !== ExceptionInfo) {
					return (instance is type);
				} else {
					return true;
				}
			}
		}

		/**
		 * Byte array position right before the opcode
		 */
		public var baseLocation:uint;
		/**
		 * Byte array position right after the opcode and its parameters (also the base location of the next opcode)
		 */
		public var endLocation:uint;

		public function get parameters():Array {
			return _parameters;
		}

		public function get opcode():Opcode {
			return _opcode;
		}

		public function toString():String {
			return baseLocation + ":" + _opcode.opcodeName + "\t\t" + ((_parameters.length > 0) ? "[" + _parameters.join(", ") + "]:" : ":") + endLocation;
		}

		public function equals(other:Object):Boolean {
			var otherOp:Op = other as Op;
			if (otherOp != null) {
				if (_opcode.opcodeName != otherOp.opcode.opcodeName) {
					return false;
				}
				if (parameters.length != otherOp.parameters.length) {
					return false;
				}
				var len:int = parameters.length;
				var len2:int;
				var i:int;
				var j:int;
				var param:*;
				var otherParam:*;
				for (i = 0; i < len; ++i) {
					param = parameters[i];
					otherParam = otherOp.parameters[i];
					if (param is IEquals) {
						if (!IEquals(param).equals(otherParam)) {
							return false;
						}
					} else if (param is Array) {
						len2 = param.length;
						if (len2 != otherParam.length) {
							return false;
						}
						for (j = 0; j < len2; ++j) {
							if (param[j] != otherParam[j]) {
								return false;
							}
						}
					} else {
						if (param != otherParam) {
							return false;
						}
					}
				}
				return true;
			}
			return false;
		}
	}
}
