package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.getter.IGetterAfterAdvice;
	import org.as3commons.aop.advice.getter.IGetterBeforeAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceGetterAfterAdvice implements IGetterAfterAdvice {
		public function TraceGetterAfterAdvice() {
		}

		public function afterGetter(getter:Accessor):void {
			trace("*** after getter");
		}
	}
}
