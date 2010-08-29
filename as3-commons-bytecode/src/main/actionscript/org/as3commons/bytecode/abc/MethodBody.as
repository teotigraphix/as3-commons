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
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of <code>method_body_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Method body" in the AVM Spec (page 32)
	 */
	public class MethodBody {
		/**
		 * Containes <code>Opcode</code> instances with appropriate arguments, representing the body of this method.
		 *
		 * @see Opcode
		 * @see Opcode@op()
		 */
		public var opcodes:Array;
		public var methodSignature:MethodInfo;
		public var maxStack:int;
		public var localCount:int;
		public var initScopeDepth:int;
		public var maxScopeDepth:int;
		public var exceptionInfos:Array;
		public var traits:Array;

		public function MethodBody() {
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
				idx = exceptionInfos.push(exceptionInfo);
			}
			return idx;
		}

		public function toString():String {
			return StringUtils.substitute("\n\t{0}\n\t{\t\n\t\t//maxStack={1}, localCount={2}, initScopeDepth={3}, maxScopeDepth={4}\n\t\t{5}\n\t}\ntraits={6}", methodSignature, maxStack, localCount, initScopeDepth, maxScopeDepth, opcodes.join("\n\t\t"), (traits.length == 0) ? "(no traits)" : ("[\n\t" + traits + "]\n"));
		}
	}
}