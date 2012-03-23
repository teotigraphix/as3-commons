/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.aop.intercept.invocation.impl {
	import org.as3commons.aop.intercept.*;
	import org.as3commons.aop.intercept.IMethodInterceptor;
	import org.as3commons.aop.intercept.invocation.IGetterInvocation;
	import org.as3commons.aop.intercept.invocation.IMethodInvocation;
	import org.as3commons.aop.intercept.invocation.ISetterInvocation;
	import org.as3commons.aop.intercept.util.InterceptorUtil;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Method;

	/**
	 * Setter invocation that applies a set of interceptors recursively.
	 *
	 * @author Christophe Herreman
	 */
	public class SetterInvocationWithInterceptors implements ISetterInvocation {

		private var _proxy:*;
		private var _setter:Accessor;
		private var _targetMethod:Function;
		private var _args:Array;
		private var _interceptors:Vector.<IInterceptor>;
		private var _currentInterceptorIndex:int = 0;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SetterInvocationWithInterceptors(proxy:*, setter:Accessor, targetMethod:Function, args:Array, interceptors:Vector.<IInterceptor>) {
			_proxy = proxy;
			_setter = setter;
			_targetMethod = targetMethod;
			_args = args;
			_interceptors = interceptors;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get setter():Accessor {
			return _setter;
		}

		public function get args():Array {
			return _args;
		}

		public function get target():* {
			return _proxy;
		}

		public function get value():* {
			return _args[0];
		}

		public function set value(v:*):void {
			_args[0] = v;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function proceed():* {
			var atEnd:Boolean = (_currentInterceptorIndex == _interceptors.length);
			if (atEnd) {
				invokeJoinpoint();
				return;
			}

			var interceptor:ISetterInterceptor = ISetterInterceptor(_interceptors[_currentInterceptorIndex]);
			_currentInterceptorIndex++;

			interceptor.interceptSetter(this);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function invokeJoinpoint():* {
			_targetMethod.apply(null, _args);
		}

	}
}
