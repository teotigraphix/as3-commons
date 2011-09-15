package org.as3commons.aop.intercept.impl {
	import org.as3commons.aop.advice.getter.IGetterAdvice;
	import org.as3commons.aop.advice.getter.IGetterAfterAdvice;
	import org.as3commons.aop.advice.getter.IGetterBeforeAdvice;
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
				//invokeThrowsAdvice(invocation, e);
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

		/*private function invokeThrowsAdvice(invocation:IGetterInvocation, error:Error):void {
		 if (_advice is IGetterThrowsAdvice) {
		 IGetterThrowsAdvice(_advice).afterMethodThrowing(invocation.getter, invocation.args, invocation.target, error);
		 }
		 }*/

		private function invokeAfterAdvice(invocation:IGetterInvocation, result:*):void {
			if (_advice is IGetterAfterAdvice) {
				IGetterAfterAdvice(_advice).afterGetter(result, invocation.getter, invocation.target);
			}
		}
	}
}
