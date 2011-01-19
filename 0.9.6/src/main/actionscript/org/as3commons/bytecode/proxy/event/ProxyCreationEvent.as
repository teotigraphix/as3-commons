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
package org.as3commons.bytecode.proxy.event {
	import flash.events.Event;

	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class ProxyCreationEvent extends Event {

		public static const PROXY_CREATED:String = "proxyCreated";

		public var proxyInstance:Object;
		public var methodInvocationInterceptor:IMethodInvocationInterceptor;

		public function ProxyCreationEvent(type:String, instance:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			proxyInstance = instance;
		}

		public override function clone():Event {
			var evt:ProxyCreationEvent = new ProxyCreationEvent(this.type, this.proxyInstance, this.bubbles, this.cancelable);
			evt.methodInvocationInterceptor = this.methodInvocationInterceptor;
			return evt;
		}

	}
}