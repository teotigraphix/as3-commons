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
	import org.as3commons.bytecode.interception.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.InvocationKind;
	import org.as3commons.bytecode.testclasses.interceptors.TestProtectedInterceptor;

	public class ProxySubClass extends TestProxiedClass {

		as3commons_bytecode_proxy var methodInvocationInterceptor:IMethodInvocationInterceptor;

		public function ProxySubClass(interceptor:IMethodInvocationInterceptor, target:IEventDispatcher = null, somethingElse:Object = null) {
			as3commons_bytecode_proxy::methodInvocationInterceptor = interceptor;
			var params:Array = [target, somethingElse];
			interceptor.intercept(this, InvocationKind.CONSTRUCTOR, null, params);
			super(params[0], params[1]);
		}

		override public function returnString():String {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "returnString"), null, super.returnString);
		}

		override public function returnStringWithParameters(param:String):String {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "returnStringWithParameters"), [param], super.returnStringWithParameters);
		}

		override public function voidWithParameters(param:String):void {
			as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "voidWithParameters"), [param], super.voidWithParameters);
		}

		override public function get getterSetter():uint {
			return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.GETTER, new QName("", "getterSetter"), [super.getterSetter]);
		}

		override public function set getterSetter(value:uint):void {
			super.getterSetter = as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.SETTER, new QName("", "getterSetter"), [value]);
		}

		override public function voidWithRestParameters(... params):void {
			as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "voidWithRestParameters"), params, super.voidWithRestParameters);
		}

		override protected function doSomething(value:int):void {
			as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "doSomething"), [value], super.doSomething);
		}

	}
}