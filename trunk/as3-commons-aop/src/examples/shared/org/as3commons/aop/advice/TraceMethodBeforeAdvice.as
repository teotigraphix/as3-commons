package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.method.IMethodBeforeAdvice;
	import org.as3commons.reflect.Method;

	public class TraceMethodBeforeAdvice implements IMethodBeforeAdvice {

		public function TraceMethodBeforeAdvice() {
		}

		public function beforeMethod(method:Method, args:Array, target:*):void {
			trace("* TraceMethodBeforeAdvice before '" + method.name + "'");
		}
	}
}
