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
package org.as3commons.bytecode.interception {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class BasicMethodInvocationInterceptor extends EventDispatcher implements IMethodInvocationInterceptor {

		private var _interceptors:Array;
		private var _invocationClass:Class;

		public function BasicMethodInvocationInterceptor(target:IEventDispatcher = null) {
			super(target);
			_invocationClass = BasicMethodInvocation;
		}

		public function intercept(targetInstance:Object, methodName:String, targetMethod:Function, arguments:Array = null):* {
			var invoc:IMethodInvocation = new _invocationClass(targetInstance, methodName, targetMethod, arguments);
			var proceed:Boolean = true;
			for each (var interceptor:IInterceptor in _interceptors) {
				interceptor.intercept(invoc);
				proceed = invoc.proceed;
				if (!proceed) {
					break;
				}
			}
			if ((proceed) && (targetMethod != null)) {
				targetMethod.apply(targetInstance, arguments);
			}
		}

		public function get invocationClass():Class {
			return _invocationClass;
		}

		public function set invocationClass(value:Class):void {
			_invocationClass = value;
		}

		public function get interceptors():Array {
			return _interceptors;
		}

		public function set interceptors(value:Array):void {
			_interceptors = value;
		}
	}
}