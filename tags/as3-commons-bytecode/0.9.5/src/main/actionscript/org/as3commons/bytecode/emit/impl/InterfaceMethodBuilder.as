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
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.lang.StringUtils;

	public class InterfaceMethodBuilder extends MethodBuilder {

		private static const INTERFACE_METHOD_NAME:String = "{0}:{1}/{0}:{1}:{2}";
		private static const INTERFACE_NAMESPACE:String = "{0}:{1}";
		private static const INTERFACE_METHODS_BODY_ERROR:String = "Interface methods cannot have method bodies";

		public var interfaceName:String;

		public function InterfaceMethodBuilder(name:String = null, visibility:MemberVisibility = null, nameSpace:String = null) {
			super(name, visibility, nameSpace);
		}

		override protected function createMethodName(methodInfo:MethodInfo):String {
			return StringUtils.substitute(INTERFACE_METHOD_NAME, packageName, name, methodInfo.as3commonsBytecodeName);
		}

		override public function addOpcode(opcode:Opcode, params:Array = null):IMethodBodyBuilder {
			throw new IllegalOperationError(INTERFACE_METHODS_BODY_ERROR);
		}

		override public function addOpcodes(newOpcodes:Array):IMethodBodyBuilder {
			throw new IllegalOperationError(INTERFACE_METHODS_BODY_ERROR);
		}

		override protected function createTraitNamespace():LNamespace {
			return new LNamespace(NamespaceKind.NAMESPACE, StringUtils.substitute(INTERFACE_NAMESPACE, packageName, interfaceName));
		}

	}
}