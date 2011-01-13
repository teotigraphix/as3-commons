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
package org.as3commons.bytecode.interception.impl {
	import flash.events.EventDispatcher;

	import org.as3commons.bytecode.interception.IInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocation;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;

	/**
	 * @inheritDoc
	 */
	public class BasicMethodInvocationInterceptor extends EventDispatcher implements IMethodInvocationInterceptor {

		private var _interceptors:Array;
		private var _invocationClass:Class;

		/**
		 * Creates a new <code>BasicMethodInvocationInterceptor</code> instance.
		 * @param target
		 */
		public function BasicMethodInvocationInterceptor() {
			super();
			initBasicMethodInvocationInterceptor();
		}

		/**
		 * Initializes the current <code>BasicMethodInvocationInterceptor</code> instance.
		 */
		protected function initBasicMethodInvocationInterceptor():void {
			_invocationClass = BasicMethodInvocation;
			_interceptors = [];
		}

		/**
		 * @inheritDoc
		 */
		public function intercept(targetInstance:Object, kind:InvocationKind, member:QName, arguments:Array = null, targetMethod:Function = null):* {
			var proceed:Boolean = true;
			var invoc:IMethodInvocation;
			if ((_interceptors != null) && (_interceptors.length > 0)) {
				invoc = new _invocationClass(targetInstance, kind, member, targetMethod, arguments);
				for each (var interceptor:IInterceptor in _interceptors) {
					interceptor.intercept(invoc);
					if (!invoc.proceed) {
						proceed = false;
					}
				}
				arguments = invoc.arguments;
			}
			switch (kind) {
				case InvocationKind.METHOD:
					if (proceed) {
						return targetMethod.apply(targetInstance, arguments);
					} else {
						return invoc.returnValue;
					}
					break;
				case InvocationKind.GETTER:
				case InvocationKind.SETTER:
					if (proceed) {
						return arguments[0];
					} else {
						return invoc.returnValue;
					}
					break;
				default:
					break;
			}
		}

		/**
		 * A reference to the <code>Class</code> (an implementation of <code>IMethodInvocation</code>) that is used
		 * to aggregate the interception data and passed on to the registered <code>IInterceptors</code>.
		 * @default BasicMethodInvocation
		 */
		public function get invocationClass():Class {
			return _invocationClass;
		}

		/**
		 * @private
		 */
		public function set invocationClass(value:Class):void {
			_invocationClass = value;
		}

		/**
		 * An <code>Array</code> of <code>IInterceptor</code> instances that will be invoked for each
		 * <code>intercept()</code> invocation.
		 */
		public function get interceptors():Array {
			return _interceptors;
		}

		/**
		 * @private
		 */
		public function set interceptors(value:Array):void {
			_interceptors = value;
		}
	}
}