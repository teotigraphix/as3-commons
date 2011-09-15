package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.getter.IGetterBeforeAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceGetterBeforeAdvice implements IGetterBeforeAdvice {
		public function TraceGetterBeforeAdvice() {
		}

		public function beforeGetter(getter:Accessor, target:*):void {
			trace("*** before getter");
		}
	}
}
