package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.constructor.IConstructorBeforeAdvice;
	import org.as3commons.reflect.Constructor;

	public class TraceConstructorBeforeAdvice implements IConstructorBeforeAdvice {
		
		public function TraceConstructorBeforeAdvice() {
		}

		public function beforeConstructor(constructor:Constructor, args:Array):void {
			trace("*** before constructor");
		}
	}
}
