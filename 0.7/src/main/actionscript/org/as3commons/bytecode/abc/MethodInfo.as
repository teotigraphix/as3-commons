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
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of <code>method_info</code> in the ABC file format. This is actually the method's signature, and combined
	 * with the method traits provides you everything you need to know about a method declaration.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Method signature" in the AVM Spec (page 24)
	 * @see MethodTrait
	 */
	public class MethodInfo {
		public var argumentCollection:Array;
		public var optionalParameters:Array;
		public var returnType:BaseMultiname;
		public var methodName:String;

		/**
		 * The <code>method_info</code> entries written by the compiler have never had a name when I have parsed them, so
		 * this variable holds a convenience name assigned by org.as3commons.bytecode.abc. This value is never written to or read from the ABC file
		 * itself; it is inferred by the traits associated with the method during deserialization.
		 *
		 * <p>
		 * This value is always assigned one of the following values: <code>null<code>, a <code>QualifiedName</code>, or
		 * a <code>String</code>
		 * </p>
		 *
		 * @see QualifiedName
		 */
		public var as3commonsBytecodeName:*;

		/**
		 * Association of this instance with its <code>MethodTrait</code>. The ABC file format never directly links these elements,
		 * but as3commons-bytecode classes do so for convenience when accessing related information about a method.
		 */
		public var as3commonsByteCodeAssignedMethodTrait:MethodTrait;
		public var flags:uint;
		public var methodBody:MethodBody;

		public function MethodInfo() {
			super();
			initMethodInfo();
		}

		protected function initMethodInfo():void {
			argumentCollection = [];
			optionalParameters = [];
		}


		/**
		 * Returns the total number of parameters to this method, both formal and informal
		 */
		public function get paramCount():int {
			return arguments.length;
		}

		/**
		 * Returns an array of the formal parameters (i.e. this required parameters for this method).
		 */
		public function get formalParameters():Array {
			var formalParams:Array = [];
			for each (var argument:Argument in argumentCollection) {
				if (!argument.isOptional) {
					formalParams[formalParams.length] = argument;
				}
			}
			return formalParams;
		}

		public function toString():String {
			var nameString:String;
			var namespaceString:String;
			if (as3commonsBytecodeName != null) {
				if (as3commonsBytecodeName is QualifiedName) {
					namespaceString = as3commonsBytecodeName.nameSpace.kind.description;
					nameString = as3commonsBytecodeName.name;
					if (as3commonsBytecodeName.nameSpace.kind == NamespaceKind.NAMESPACE) {
						namespaceString = as3commonsBytecodeName.nameSpace.name;
					}
				}

				if (as3commonsBytecodeName is String) {
					nameString = as3commonsBytecodeName;
				}
			}

			return StringUtils.substitute("{0} function {1}({2}) : {3}", (namespaceString) ? namespaceString : "(no namespace)", as3commonsBytecodeName, argumentCollection.join(", "), returnType);
		}
	}
}