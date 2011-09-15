package org.as3commons.aop.intercept.impl {
	import org.as3commons.aop.advice.method.IMethodAdvice;
	import org.as3commons.aop.advice.method.IMethodAfterAdvice;
	import org.as3commons.aop.advice.method.IMethodAfterReturningAdvice;
	import org.as3commons.aop.advice.method.IMethodBeforeAdvice;
	import org.as3commons.aop.advice.method.IMethodThrowsAdvice;
	import org.as3commons.aop.intercept.IMethodInterceptor;
	import org.as3commons.aop.intercept.invocation.IMethodInvocation;

	/**
	 * Interceptor that applies method advice.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class MethodAdviceInterceptor implements IMethodInterceptor {

		private var _advice:IMethodAdvice;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MethodAdviceInterceptor(advice:IMethodAdvice) {
			_advice = advice;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function interceptMethod(invocation:IMethodInvocation):* {
			invokeBeforeAdvice(invocation);

			try {
				var result:* = invocation.proceed();
				invokeAfterReturningAdvice(invocation, result);
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

		private function invokeAfterReturningAdvice(invocation:IMethodInvocation, result:*):void {
			if (_advice is IMethodAfterReturningAdvice) {
				IMethodAfterReturningAdvice(_advice).afterMethodReturning(result, invocation.method, invocation.args, invocation.target);
			}
		}

		private function invokeBeforeAdvice(invocation:IMethodInvocation):void {
			if (_advice is IMethodBeforeAdvice) {
				IMethodBeforeAdvice(_advice).beforeMethod(invocation.method, invocation.args, invocation.target);
			}
		}

		private function invokeThrowsAdvice(invocation:IMethodInvocation, error:Error):void {
			if (_advice is IMethodThrowsAdvice) {
				IMethodThrowsAdvice(_advice).afterMethodThrowing(invocation.method, invocation.args, invocation.target, error);
			}
		}

		private function invokeAfterAdvice(invocation:IMethodInvocation, result:*):void {
			if (_advice is IMethodAfterAdvice) {
				IMethodAfterAdvice(_advice).afterMethod(result, invocation.method, invocation.args, invocation.target);
			}
		}
	}
}
