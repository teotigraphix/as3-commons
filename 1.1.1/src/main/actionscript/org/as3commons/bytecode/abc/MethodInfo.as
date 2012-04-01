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
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.util.CloneUtils;

	/**
	 * as3commons-bytecode representation of <code>method_info</code> in the ABC file format. This is actually the method's signature, and combined
	 * with the method traits provides you everything you need to know about a method declaration.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Method signature" in the AVM Spec (page 24)
	 * @see MethodTrait
	 */
	public final class MethodInfo implements ICloneable, IEquals {

		private static const ILLEGAL_TRAITINFO_TYPE:String = "Argument must be of type FunctionTrait or MethodTrait";

		public function MethodInfo() {
			super();
			argumentCollection = new Vector.<Argument>();
		}

		public var argumentCollection:Vector.<Argument>;

		/**
		 * The <code>method_info</code> entries written by the compiler have never had a name when I have parsed them, so
		 * this variable holds a convenience name assigned by org.as3commons.bytecode.abc. This value is never written to or read from the ABC file
		 * itself; it is inferred by the traits associated with the method during deserialization.
		 *
		 * <p>
		 * This value is always assigned one of the following values: <code>null</code>, a <code>QualifiedName</code>, or
		 * a <code>String</code>
		 * </p>
		 *
		 * @see QualifiedName
		 */
		public var as3commonsBytecodeName:*;
		public var flags:uint;
		public var methodBody:MethodBody;
		public var methodName:String;
		public var returnType:BaseMultiname;
		public var scopeName:String;
		private var _as3commonsByteCodeAssignedMethodTrait:TraitInfo;

		public function addArgument(argument:Argument):void {
			if (argumentCollection.indexOf(argument) < 0) {
				argumentCollection[argumentCollection.length] = argument;
			}
		}

		/**
		 * Association of this instance with its <code>MethodTrait</code>. The ABC file format never directly links these elements,
		 * but as3commons-bytecode classes do so for convenience when accessing related information about a method.
		 */
		public function get as3commonsByteCodeAssignedMethodTrait():TraitInfo {
			return _as3commonsByteCodeAssignedMethodTrait;
		}

		public function set as3commonsByteCodeAssignedMethodTrait(value:TraitInfo):void {
			if ((value is FunctionTrait) || (value is MethodTrait)) {
				_as3commonsByteCodeAssignedMethodTrait = value;
			} else {
				throw IllegalArgumentError(ILLEGAL_TRAITINFO_TYPE);
			}
		}

		public function clone():* {
			var clone:MethodInfo = new MethodInfo();
			clone.argumentCollection = AbcFileUtil.cloneVector(argumentCollection);
			clone.returnType = returnType;
			clone.methodName = methodName;
			return clone;
		}

		/**
		 * Returns an array of the formal parameters (i.e. this required parameters for this method).
		 */
		public function get formalParameters():Vector.<Argument> {
			var formalParams:Vector.<Argument> = new Vector.<Argument>();
			for each (var argument:Argument in argumentCollection) {
				if (!argument.isOptional) {
					formalParams[formalParams.length] = argument;
				}
			}
			return formalParams;
		}

		public function get optionalParameters():Vector.<Argument> {
			var optionalParams:Vector.<Argument> = new Vector.<Argument>();
			for each (var argument:Argument in argumentCollection) {
				if (argument.isOptional) {
					optionalParams[optionalParams.length] = argument;
				}
			}
			return optionalParams;
		}

		/**
		 * Returns the total number of parameters to this method, both formal and informal
		 */
		public function get paramCount():int {
			return arguments.length;
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

		public function equals(other:Object):Boolean {
			var otherMethod:MethodInfo = other as MethodInfo;
			if (otherMethod != null) {
				if (flags != otherMethod.flags) {
					return false;
				}
				if (methodName != otherMethod.methodName) {
					return false;
				}
				if (!returnType.equals(otherMethod.returnType)) {
					return false;
				}
				if (scopeName != otherMethod.scopeName) {
					return false;
				}
				if (argumentCollection.length != otherMethod.argumentCollection.length) {
					return false;
				}
				var len:int = argumentCollection.length;
				var i:int;
				var arg:Argument;
				var otherArg:Argument;
				for (i = 0; i < len; ++i) {
					arg = argumentCollection[i];
					otherArg = otherMethod.argumentCollection[i];
					if (!arg.equals(otherArg)) {
						return false;
					}
				}
				return true;
			}
			return false;
		}

	}
}
