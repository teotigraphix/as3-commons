package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.method.IMethodThrowsAdvice;
	import org.as3commons.reflect.Method;

	public class TraceMethodThrowingAdvice implements IMethodThrowsAdvice {

		public function TraceMethodThrowingAdvice() {
		}

		public function afterMethodThrowing(method:Method, args:Array, target:*, error:Error):void {
			trace("* TraceMethodThrowingAdvice after method throwing: '" + error.message + "'");
		}
	}
}
