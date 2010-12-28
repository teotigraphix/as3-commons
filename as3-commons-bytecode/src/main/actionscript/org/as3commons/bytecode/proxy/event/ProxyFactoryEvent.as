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
package org.as3commons.bytecode.proxy.event {
	import flash.events.Event;

	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class ProxyFactoryEvent extends Event {

		public static const GET_METHOD_INVOCATION_INTERCEPTOR:String = "getMethodInvocationInterceptor";

		private var _methodInvocationInterceptor:IMethodInvocationInterceptor;
		private var _methodInvocationInterceptorClass:Class;
		private var _proxiedClass:Class;
		private var _constructorArguments:Array;

		/**
		 * Creates a new <code>ProxyFactoryEvent</code> instance.
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function ProxyFactoryEvent(type:String, proxiedClass:Class, constructorArguments:Array = null, methodInvocationInterceptorClass:Class = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_proxiedClass = proxiedClass;
			_constructorArguments = constructorArguments;
			_methodInvocationInterceptorClass = methodInvocationInterceptorClass;
		}

		public function get methodInvocationInterceptorClass():Class {
			return _methodInvocationInterceptorClass;
		}

		public function get proxiedClass():Class {
			return _proxiedClass;
		}

		public function get constructorArguments():Array {
			return _constructorArguments;
		}

		/**
		 *
		 */
		public function get methodInvocationInterceptor():IMethodInvocationInterceptor {
			return _methodInvocationInterceptor;
		}

		/**
		 * @private
		 */
		public function set methodInvocationInterceptor(value:IMethodInvocationInterceptor):void {
			_methodInvocationInterceptor = value;
		}

		override public function clone():Event {
			var event:ProxyFactoryEvent = new ProxyFactoryEvent(this.type, this.proxiedClass, this.constructorArguments, this.methodInvocationInterceptorClass, this.bubbles, this.cancelable);
			event.methodInvocationInterceptor = this.methodInvocationInterceptor;
			return event;
		}

	}
}