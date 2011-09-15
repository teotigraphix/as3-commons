package org.as3commons.aop.intercept {
	import org.as3commons.aop.intercept.invocation.IMethodInvocation;

	public class TraceMethodInterceptor implements IMethodInterceptor {

		public function TraceMethodInterceptor() {
		}

		public function interceptMethod(methodInvocation:IMethodInvocation):* {
			trace("* TraceMethodInterceptor before method '" + methodInvocation.method.name + "'");

			try {
				var result:* = methodInvocation.proceed();
				trace("* TraceMethodInterceptor after returning method '" + methodInvocation.method.name + "'");
			} catch (e:Error) {
				trace("* TraceMethodInterceptor after throws '" + methodInvocation.method.name + "' - error '" + e + "'");
				throw e;
			} finally {
				trace("* TraceMethodInterceptor after method '" + methodInvocation.method.name + "'");
			}

			return result;
		}
	}
}
