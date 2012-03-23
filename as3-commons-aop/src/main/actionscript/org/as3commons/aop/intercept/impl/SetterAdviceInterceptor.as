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
	import org.as3commons.aop.advice.setter.ISetterAdvice;
	import org.as3commons.aop.advice.setter.ISetterAfterAdvice;
	import org.as3commons.aop.advice.setter.ISetterBeforeAdvice;
	import org.as3commons.aop.advice.setter.ISetterThrowsAdvice;
	import org.as3commons.aop.intercept.ISetterInterceptor;
	import org.as3commons.aop.intercept.invocation.ISetterInvocation;

	/**
	 * Interceptor that applies setter advice.
	 *
	 * @author Christophe Herreman
	 */
	public class SetterAdviceInterceptor implements ISetterInterceptor {

		private var _advice:ISetterAdvice;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SetterAdviceInterceptor(advice:ISetterAdvice) {
			_advice = advice;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function interceptSetter(invocation:ISetterInvocation):void {
			invokeBeforeAdvice(invocation);

			try {
				invocation.proceed();
				//invokeAfterReturningAdvice(invocation, result);
			} catch (e:Error) {
				invokeThrowsAdvice(invocation, e);
				throw e;
			} finally {
				invokeAfterAdvice(invocation);
			}
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

		private function invokeBeforeAdvice(invocation:ISetterInvocation):void {
			if (_advice is ISetterBeforeAdvice) {
				ISetterBeforeAdvice(_advice).beforeSetter(invocation.setter, invocation.target, invocation.args[0]);
			}
		}

		private function invokeThrowsAdvice(invocation:ISetterInvocation, error:Error):void {
			if (_advice is ISetterThrowsAdvice) {
				ISetterThrowsAdvice(_advice).afterSetterThrows(invocation.setter, invocation.args[0], invocation.target, error);
			}
		}

		private function invokeAfterAdvice(invocation:ISetterInvocation):void {
			if (_advice is ISetterAfterAdvice) {
				ISetterAfterAdvice(_advice).afterSetter(invocation.setter);
			}
		}
	}
}
