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
// Compile with: asc -import BaseClass.abc -import MethodInvocation.abc -import loom_namespace.abc DynamicSubClass.as 
package org.as3commons.bytecode.template {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.as3commons_bytecode;

	public class DynamicSubClass extends BaseClass {

		as3commons_bytecode var handlerMappings:Dictionary;

		public function DynamicSubClass(constructorArg1:String, constructorArg2:String) {
			super(constructorArg1, constructorArg2);

			as3commons_bytecode::handlerMappings = new Dictionary();
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

		override public function methodCallOne(arg1:String, arg2:Number):int {
			return as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "methodCallOne", arguments, super.methodCallOne));
		}

		override public function methodCallTwo(arg1:String, arg2:Number, arg3:Object):void {
			as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "methodCallTwo", arguments, super.methodCallTwo));
		}

		override public function methodCallThree(arg1:String, arg2:Number):String {
			return as3commons_bytecode::proxyInvocation(new MethodInvocation(this, "methodCallThree", arguments, super.methodCallThree));
		}
	}
}