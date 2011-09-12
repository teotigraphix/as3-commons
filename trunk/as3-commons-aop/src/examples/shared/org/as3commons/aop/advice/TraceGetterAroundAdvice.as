package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.getter.IGetterAroundAdvice;
	import org.as3commons.aop.advice.method.IMethodAroundAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceGetterAroundAdvice implements IGetterAroundAdvice {

		public function TraceGetterAroundAdvice() {
		}

		public function beforeGetter(getter:Accessor):void {
			trace("*** before getter");
		}

		public function afterGetter(getter:Accessor):void {
			trace("*** after getter");
		}
	}
}
