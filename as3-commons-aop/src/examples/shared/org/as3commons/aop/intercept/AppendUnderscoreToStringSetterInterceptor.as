package org.as3commons.aop.intercept {
	import org.as3commons.aop.intercept.invocation.ISetterInvocation;

	public class AppendUnderscoreToStringSetterInterceptor implements ISetterInterceptor {

		public function AppendUnderscoreToStringSetterInterceptor() {
		}

		public function interceptSetter(invocation:ISetterInvocation):void {
			if (invocation.value is String) {
				invocation.value = String(invocation.value) + "_";
			}
			invocation.proceed();
		}
	}
}
