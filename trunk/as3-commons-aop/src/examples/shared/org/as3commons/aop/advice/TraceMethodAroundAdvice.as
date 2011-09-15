package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.method.IMethodAroundAdvice;
	import org.as3commons.reflect.Method;

	public class TraceMethodAroundAdvice implements IMethodAroundAdvice {

		public function TraceMethodAroundAdvice() {
		}

		public function beforeMethod(method:Method, args:Array, target:*):void {
			trace("* TraceMethodAroundAdvice before method '" + method.name + "' in around advice");
		}

		public function afterMethod(returnValue:*, method:Method, args:Array, target:*):void {
			trace("* TraceMethodAroundAdvice after method '" + method.name + "' in around advice");
		}

		public function afterMethodReturning(returnValue:*, method:Method, args:Array, target:*):void {
			trace("* TraceMethodAroundAdvice after method returning '" + method.name + "' in around advice");
		}

		public function afterMethodThrowing(method:Method, args:Array, target:*, error:Error):void {
			trace("* TraceMethodAroundAdvice after method throwing '" + method.name + "' in around advice.");
		}
	}
}
