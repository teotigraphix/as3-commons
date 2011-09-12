package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.constructor.IConstructorAfterAdvice;
	import org.as3commons.reflect.Constructor;

	public class TraceConstructorAfterAdvice implements IConstructorAfterAdvice {
		public function TraceConstructorAfterAdvice() {
		}

		public function afterConstructor(constructor:Constructor, arguments:Array, target:*):void {
			trace("*** after constructor");
		}
	}
}
