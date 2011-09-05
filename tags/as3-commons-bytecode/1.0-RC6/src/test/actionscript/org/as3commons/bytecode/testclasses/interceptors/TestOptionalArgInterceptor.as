package org.as3commons.bytecode.testclasses.interceptors {
	import org.as3commons.bytecode.interception.IMethodInvocation;
	import org.as3commons.bytecode.interception.impl.InvocationKind;
	import org.as3commons.lang.Assert;

	public class TestOptionalArgInterceptor extends AssertingInterceptor {
		public function TestOptionalArgInterceptor() {
			super();
		}

		override public function intercept(invocation:IMethodInvocation):void {
			super.intercept(invocation);
			if (invocation.kind === InvocationKind.METHOD) {
				Assert.state(invocation.arguments.length == 2);
				Assert.state(invocation.arguments[0] == "test");
				Assert.state(invocation.arguments[1] == true);
			}
		}
	}
}