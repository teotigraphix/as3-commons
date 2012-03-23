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
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Method;

	/**
	 * Getter invocation that applies a set of interceptors recursively.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class GetterInvocationWithInterceptors implements IGetterInvocation {

		private var _proxy:*;
		private var _getter:Accessor;
		private var _targetMethod:Function;
		private var _interceptors:Vector.<IInterceptor>;
		private var _currentInterceptorIndex:int = 0;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function GetterInvocationWithInterceptors(proxy:*, getter:Accessor, targetMethod:Function, interceptors:Vector.<IInterceptor>) {
			_proxy = proxy;
			_getter = getter;
			_targetMethod = targetMethod;
			_interceptors = interceptors;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get getter():Accessor {
			return _getter;
		}

		public function get args():Array {
			return null;
		}

		public function get target():* {
			return _proxy;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function proceed():* {
			var atEnd:Boolean = (_currentInterceptorIndex == _interceptors.length);
			if (atEnd) {
				return invokeJoinpoint();
			}

			var interceptor:IGetterInterceptor = IGetterInterceptor(_interceptors[_currentInterceptorIndex]);
			_currentInterceptorIndex++;

			return interceptor.interceptGetter(this);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function invokeJoinpoint():* {
			return _targetMethod.apply(_proxy);
		}

	}
}
