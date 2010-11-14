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
package org.as3commons.eventbus.impl {
	import flash.events.Event;

	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.MethodInvoker;

	public class InterceptorProxy implements IEventInterceptor {

		private var _methodInvoker:MethodInvoker;

		public function InterceptorProxy(target:Object, methodName:String) {
			super();
			initInterceptorProxy(target, methodName);
		}

		protected function initInterceptorProxy(target:Object, methodName:String):void {
			Assert.notNull(target, "target argument must not be null");
			Assert.hasText(methodName, "methodName argument must not be empty or null");
			_methodInvoker = new MethodInvoker();
			_methodInvoker.target = target;
			_methodInvoker.method = methodName;
		}

		public function intercept(event:Event):Boolean {
			_methodInvoker.arguments = [event];
			return _methodInvoker.invoke();
		}
	}
}