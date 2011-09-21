package org.as3commons.aop.intercept {
	import org.as3commons.aop.intercept.invocation.ISetterInvocation;

	public class StringToUppercaseSetterInterceptor implements ISetterInterceptor {

		public function StringToUppercaseSetterInterceptor() {
		}

		public function interceptSetter(invocation:ISetterInvocation):void {
			trace("* StringToUppercaseSetterInterceptor before");
			if (invocation.value is String) {
				invocation.value = String(invocation.value).toUpperCase();
			}
			invocation.proceed();
			trace("* StringToUppercaseSetterInterceptor after");
		}
	}
}
