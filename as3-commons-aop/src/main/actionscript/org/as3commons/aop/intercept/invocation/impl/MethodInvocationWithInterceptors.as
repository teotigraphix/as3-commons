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
package org.as3commons.aop.intercept.invocation.impl {
	import org.as3commons.aop.intercept.*;
	import org.as3commons.aop.intercept.IMethodInterceptor;
	import org.as3commons.aop.intercept.invocation.IMethodInvocation;
	import org.as3commons.reflect.Method;

	/**
	 * Method invocation that applies a set of interceptors recursively.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class MethodInvocationWithInterceptors implements IMethodInvocation {

		private var _target:*;
		private var _method:Method;
		private var _targetMethod:Function;
		private var _args:Array;
		private var _interceptors:Vector.<IInterceptor>;
		private var _currentInterceptorIndex:int = 0;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MethodInvocationWithInterceptors(target:*, method:Method, targetMethod:Function, args:Array, interceptors:Vector.<IInterceptor>) {
			_target = target;
			_method = method;
			_targetMethod = targetMethod;
			_args = args;
			_interceptors = interceptors;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get method():Method {
			return _method;
		}

		public function get args():Array {
			return _args;
		}

		public function get target():* {
			return _target;
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

			var interceptor:IMethodInterceptor = IMethodInterceptor(_interceptors[_currentInterceptorIndex]);
			_currentInterceptorIndex++;

			return interceptor.interceptMethod(this);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function invokeJoinpoint():* {
			return _targetMethod.apply(_target, _args);
		}
	}
}
