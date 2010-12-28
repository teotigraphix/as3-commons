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
	 * Dispatched during various stages of proxy instantiation.
	 * @author Roland Zwaga
	 */
	public class ProxyFactoryEvent extends Event {

		/**
		 * Dispatched before a proxy class is instantiated to obtain an optional reference to an <code>IMethodInvocationInterceptor</code> instance.
		 */
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

		/**
		 * A reference to the <code>Class</code> (an <code>IMethodInvocationInterceptor</code> implementation) that has been configured for the specified <code>proxiedClass</code>.
		 */
		public function get methodInvocationInterceptorClass():Class {
			return _methodInvocationInterceptorClass;
		}

		/**
		 * The <code>Class</code> for which a proxy is being instantiated.
		 */
		public function get proxiedClass():Class {
			return _proxiedClass;
		}

		/**
		 * Optional array of constructor arguments for the proxy instance.
		 */
		public function get constructorArguments():Array {
			return _constructorArguments;
		}

		/**
		 * If not null the <code>IMethodInvocationInterceptor</code> instance assigned to this property will be injected
		 * into the proxy instance.
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

		/**
		 * Returns an exact copy of the current <code>ProxyFactoryEvent</code>.
		 * @return An exact copy of the current <code>ProxyFactoryEvent</code>.
		 */
		override public function clone():Event {
			var event:ProxyFactoryEvent = new ProxyFactoryEvent(this.type, this.proxiedClass, this.constructorArguments, this.methodInvocationInterceptorClass, this.bubbles, this.cancelable);
			event.methodInvocationInterceptor = this.methodInvocationInterceptor;
			return event;
		}

	}
}