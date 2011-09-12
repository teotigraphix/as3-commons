package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.method.IMethodThrowingAdvice;
	import org.as3commons.bytecode.interception.IMethodInvocation;
	import org.as3commons.reflect.Method;

	public class TraceMethodThrowingAdvice implements IMethodThrowingAdvice {

		public function TraceMethodThrowingAdvice() {
		}

		public function afterMethodThrowing(method:Method, args:Array, target:*, error:Error):void {
			trace("*** after method throwing: '" + error.message + "'");
		}
	}
}
