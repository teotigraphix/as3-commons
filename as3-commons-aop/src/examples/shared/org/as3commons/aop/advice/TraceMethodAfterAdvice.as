package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.method.IMethodAfterAdvice;
	import org.as3commons.reflect.Method;

	public class TraceMethodAfterAdvice implements IMethodAfterAdvice {

		public function TraceMethodAfterAdvice() {
		}

		public function afterMethod(returnValue:*, method:Method, args:Array, target:*):void {
			trace("*** after method");
		}
	}
}
