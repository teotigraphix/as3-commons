package org.as3commons.bytecode.testclasses.interceptors {
	import org.as3commons.bytecode.interception.IInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocation;

	public class TestProtectedInterceptor implements IInterceptor {
		public function TestProtectedInterceptor() {
			super();
		}

		public function intercept(invocation:IMethodInvocation):void {
			invocation.arguments[0] = 100;
		}
	}
}