/*
* Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.testclasses {
	import flash.events.IEventDispatcher;

	import org.as3commons.bytecode.as3commons_bytecode_proxy;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.InvocationKind;

	public class ProxySubClass extends TestProxiedClass {

		as3commons_bytecode_proxy var methodInvocationInterceptor:IMethodInvocationInterceptor;

		public function ProxySubClass(interceptor:IMethodInvocationInterceptor, target:IEventDispatcher = null, somethingElse:Object = null) {
			as3commons_bytecode_proxy::methodInvocationInterceptor = interceptor;
			var params:Array = [target, somethingElse];
			interceptor.intercept(this, InvocationKind.CONSTRUCTOR, "constructor", params);
			super(params[0], params[1]);
		}

		override public function returnString():String {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, "returnString", null, super.returnString);
		}

		override public function returnStringWithParameters(param:String):String {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, "returnStringWithParameters", [param], super.returnStringWithParameters);
		}

		override public function voidWithParameters(param:String):void {
			as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, "voidWithParameters", [param], super.voidWithParameters);
		}

		override public function get getterSetter():uint {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.GETTER, "getterSetter/get");
		}

		override public function set getterSetter(value:uint):void {
			as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.SETTER, "getterSetter/set", [value]);
		}

		override public function voidWithRestParameters(... params):void {
			as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, "voidWithRestParameters", params, super.voidWithRestParameters);
		}

	}
}