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
//compile with: asc -import FullClassDefinition.abc -import custom_namespace.abc -import Interface.abc -import ../../loom/template/MethodInvocation.abc -import ../../loom/template/loom_namespace.abc FCDSubClass.as
package assets.abc {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.template.MethodInvocation;

	use namespace as3commons_bytecode;
	use namespace custom_namespace;

	public class FCDSubClass extends FullClassDefinition {
		as3commons_bytecode var handlerMappings:Dictionary;

		public function FCDSubClass() {
			super();
			as3commons_bytecode::handlerMappings = new Dictionary();
		}

		override public function methodWithNoArguments():void {
			as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "methodWithNoArguments", arguments, super.methodWithNoArguments));
		}

		override public function methodWithOptionalArguments(requiredArgument:String, optionalStringArgument:String = null, optionalIntArgument:int = 10):void {
			as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "methodWithOptionalArguments", [requiredArgument, optionalStringArgument, optionalIntArgument], super.methodWithOptionalArguments));
		}

		override public function methodWithRestArguments(requiredArgument:String, ... rest):void {
			as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "methodWithRestArguments", [requiredArgument, rest], super.methodWithRestArguments));
		}

		override public function set setterForInternalValue(value:String):void {
			as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "setterForInternalValue", arguments, null, 2));
		}

		as3commons_bytecode function setProperty(propertyName:String, value:String):void {
			super[propertyName] = value;
		}

		override public function get getterForInternalValue():String {
			return as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "getterForInternalValue", arguments, null, 1));
		}

		as3commons_bytecode function getProperty(propertyName:String):String {
			return super[propertyName];
		}

		// The command-line flex-mojos compiler will complain here unless both this class and its superclass import the namespace
		// and use the "use namespace" declaration. The FB compiler is a little more forgiving for some reason.
		override custom_namespace function customNamespaceFunction():void {
			as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "customNamespaceFunction", arguments, null));
		}

		as3commons_bytecode function setHandler(methodName:String, closure:Function):void {
			as3commons_bytecode::handlerMappings[methodName] = closure;
		}

		as3commons_bytecode function proxyInvocation(invocation:MethodInvocation):* {
			var closure:Function = as3commons_bytecode::handlerMappings[invocation.methodName];
			if (Boolean(closure)) {
				return closure.apply(this, [invocation]);
			} else {
				return invocation.proceed();
			}
		}
	}
}