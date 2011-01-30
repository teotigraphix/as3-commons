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
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.util.CloneUtils;

	/**
	 * as3commons-bytecode representation of <code>method_body_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Method body" in the AVM Spec (page 32)
	 */
	public class MethodBody implements ICloneable {
		/**
		 * Containes <code>Opcode</code> instances with appropriate arguments, representing the body of this method.
		 *
		 * @see Opcode
		 * @see Opcode#op()
		 */
		public var opcodes:Array;
		public var rawOpcodes:ByteArray;
		public var methodSignature:MethodInfo;
		public var maxStack:int = 1;
		public var localCount:int = 1;
		public var initScopeDepth:int = 1;
		public var maxScopeDepth:int = 1;
		public var exceptionInfos:Array;
		public var traits:Array;
		public var backPatches:Array;

		public function MethodBody() {
			super();
			initMethodBody();
		}

		protected function initMethodBody():void {
			opcodes = [];
			exceptionInfos = [];
			traits = [];
		}

		public function addExceptionInfo(exceptionInfo:ExceptionInfo):uint {
			var idx:int = exceptionInfos.indexOf(exceptionInfo);
			if (idx < 0) {
				idx = (exceptionInfos.push(exceptionInfo) - 1);
			}
			return (idx);
		}

		public function toString():String {
			return StringUtils.substitute("\n\t{0}\n\t{\t\n\t\t//maxStack={1}, localCount={2}, initScopeDepth={3}, maxScopeDepth={4}\n\t\t{5}\n\t}\ntraits={6}", methodSignature, maxStack, localCount, initScopeDepth, maxScopeDepth, opcodes.join("\n\t\t"), (traits.length == 0) ? "(no traits)" : ("[\n\t" + traits + "]\n"));
		}

		public function clone():* {
			var clone:MethodBody = new MethodBody();
			clone.opcodes = CloneUtils.cloneList(opcodes);
			if (rawOpcodes != null) {
				clone.rawOpcodes = AbcSpec.byteArray();
				clone.rawOpcodes.writeBytes(rawOpcodes);
				clone.rawOpcodes.position = 0;
			}
			clone.maxStack = maxStack;
			clone.localCount = localCount;
			clone.initScopeDepth = initScopeDepth;
			clone.maxScopeDepth = maxScopeDepth;
			for each (var op:Op in clone.opcodes) {
				if (op.opcode === Opcode.newcatch) {
					clone.exceptionInfos[clone.exceptionInfos.length] = op.parameters[0];
				}
			}
			clone.traits = CloneUtils.cloneList(traits);
			return clone;
		}
	}
}