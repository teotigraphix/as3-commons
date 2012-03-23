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
package org.as3commons.aop.intercept.impl {
	import org.as3commons.aop.advice.constructor.IConstructorAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorBeforeAdvice;
	import org.as3commons.aop.intercept.IConstructorInterceptor;
	import org.as3commons.aop.intercept.invocation.IConstructorInvocation;

	/**
	 * Interceptor that applies constructor advice.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class ConstructorAdviceInterceptor implements IConstructorInterceptor {

		private var _advice:IConstructorAdvice;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ConstructorAdviceInterceptor(advice:IConstructorAdvice) {
			_advice = advice;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function interceptConstructor(invocation:IConstructorInvocation):* {
			invokeBeforeAdvice(invocation);
			return invocation.proceed();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------


		private function invokeBeforeAdvice(invocation:IConstructorInvocation):void {
			if (_advice is IConstructorBeforeAdvice) {
				IConstructorBeforeAdvice(_advice).beforeConstructor(invocation.constructor, invocation.args);
			}
		}

	}
}
