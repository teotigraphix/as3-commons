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
	import org.as3commons.aop.advice.getter.IGetterAdvice;
	import org.as3commons.aop.advice.getter.IGetterAfterAdvice;
	import org.as3commons.aop.advice.getter.IGetterBeforeAdvice;
	import org.as3commons.aop.advice.getter.IGetterThrowsAdvice;
	import org.as3commons.aop.intercept.IGetterInterceptor;
	import org.as3commons.aop.intercept.invocation.IGetterInvocation;

	/**
	 * Interceptor that applies getter advice.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class GetterAdviceInterceptor implements IGetterInterceptor {

		private var _advice:IGetterAdvice;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function GetterAdviceInterceptor(advice:IGetterAdvice) {
			_advice = advice;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function interceptGetter(invocation:IGetterInvocation):* {
			invokeBeforeAdvice(invocation);

			try {
				var result:* = invocation.proceed();
				//invokeAfterReturningAdvice(invocation, result);
			} catch (e:Error) {
				invokeThrowsAdvice(invocation, e);
				throw e;
			} finally {
				invokeAfterAdvice(invocation, result);
			}

			return result;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/*private function invokeAfterReturningAdvice(invocation:IGetterInvocation, result:*):void {
		 if (_advice is IGetterAfterReturning) {
		 IGetterAfterReturning(_advice).afterGetterReturning(result, invocation.getter, invocation.args, invocation.target);
		 }
		 }*/

		private function invokeBeforeAdvice(invocation:IGetterInvocation):void {
			if (_advice is IGetterBeforeAdvice) {
				IGetterBeforeAdvice(_advice).beforeGetter(invocation.getter, invocation.target);
			}
		}

		private function invokeThrowsAdvice(invocation:IGetterInvocation, error:Error):void {
			if (_advice is IGetterThrowsAdvice) {
				IGetterThrowsAdvice(_advice).afterGetterThrows(invocation.getter, invocation.target, error);
			}
		}

		private function invokeAfterAdvice(invocation:IGetterInvocation, result:*):void {
			if (_advice is IGetterAfterAdvice) {
				IGetterAfterAdvice(_advice).afterGetter(result, invocation.getter, invocation.target);
			}
		}
	}
}
