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
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.lang.StringUtils;

	/**
	 * Represents a method, along with its return type, arguments, instruction body, and flags
	 * (<code>override</code>, <code>final</code>, etc).
	 *
	 * <p>
	 * If you are creating a getter or setter, please use the appropriate subtypes instead of
	 * this class.
	 * </p>
	 */
	public class Method extends Annotatable {
		private var _methodName:QualifiedName;
		private var _arguments:Array;
		private var _returnType:BaseMultiname;
		private var _isStatic:Boolean;
		private var _isFinal:Boolean;
		private var _isOverride:Boolean;
		private var _methodBody:MethodBody;

		public function Method(methodName:QualifiedName, returnType:BaseMultiname, isStatic:Boolean = false, isOverride:Boolean = false, isFinal:Boolean = false) {
			_methodName = methodName;
			_returnType = returnType;

			_arguments = [];

			_isStatic = isStatic;
			_isOverride = isOverride;
			_isFinal = isFinal;
		}

		public function get methodArguments():Array {
			return _arguments;
		}

		public function get returnType():BaseMultiname {
			return _returnType;
		}

		public function addArgument(argument:Argument):void {
			_arguments.push(argument);
		}

		//TODO: Is it possible to derive the scope/stack depth based upon the bytecodes? This would be bad ass
		public function setMethodBody(body:MethodBody):void {
			_methodBody = body;
		}

		public function get methodName():QualifiedName {
			return _methodName;
		}

		public function get isStatic():Boolean {
			return _isStatic;
		}

		public function get isOverride():Boolean {
			return _isOverride;
		}

		public function get isFinal():Boolean {
			return _isFinal;
		}

		public function toString():String {
			var methodType:String = "";
			if (this is Getter) {
				methodType = " get";
			}
			if (this is Setter) {
				methodType = " set";
			}

			var argumentsArray:Array = [];
			methodArguments.every(function(item:Argument, index:int, array:Array):Boolean {
					argumentsArray.push(item.type.name);
					return true;
				});

			return StringUtils.substitute("{0}{1}{2} function {3}{4} ({5}) : {6}\n\t{\n\t\topcode count: {7}\n\t}", methodName.nameSpace.kind.description, (isStatic) ? " static" : "", (isOverride) ? " override" : "", methodName.name, methodType, argumentsArray.join(", "), returnType, (_methodBody) ? _methodBody.opcodes.length : "[nyi]");
		}
	}
}