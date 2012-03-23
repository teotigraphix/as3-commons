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
	import org.as3commons.aop.intercept.invocation.IConstructorInvocation;
	import org.as3commons.reflect.Constructor;

	/**
	 * Constructor invocation that applies a set of interceptors recursively.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class ConstructorInvocationWithInterceptors implements IConstructorInvocation {

		private var _constructor:Constructor;
		private var _args:Array;
		private var _interceptors:Vector.<IInterceptor>;
		private var _currentInterceptorIndex:int = 0;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ConstructorInvocationWithInterceptors(constructor:Constructor, args:Array, interceptors:Vector.<IInterceptor>) {
			_constructor = constructor;
			_args = args;
			_interceptors = interceptors;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get constructor():Constructor {
			return _constructor;
		}

		public function get args():Array {
			return _args;
		}

		public function get target():* {
			return null;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function proceed():* {
			var atEnd:Boolean = (_currentInterceptorIndex == _interceptors.length);
			if (atEnd) {
				return;
			}

			var interceptor:IConstructorInterceptor = IConstructorInterceptor(_interceptors[_currentInterceptorIndex]);
			_currentInterceptorIndex++;

			interceptor.interceptConstructor(this);
		}

	}
}
