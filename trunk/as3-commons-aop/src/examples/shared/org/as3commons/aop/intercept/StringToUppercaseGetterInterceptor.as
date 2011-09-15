package org.as3commons.aop.intercept {
	import org.as3commons.aop.intercept.invocation.IGetterInvocation;
	import org.as3commons.aop.intercept.invocation.ISetterInvocation;

	public class StringToUppercaseGetterInterceptor implements IGetterInterceptor {

		public function StringToUppercaseGetterInterceptor() {
		}

		public function interceptGetter(invocation:IGetterInvocation):* {
			var result:* = invocation.proceed();

			if (result is String) {
				result = String(result).toUpperCase();
			}

			return result;
		}
	}
}
