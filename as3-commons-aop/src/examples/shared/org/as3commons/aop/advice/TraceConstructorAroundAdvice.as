package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.constructor.IConstructorAroundAdvice;
	import org.as3commons.reflect.Constructor;

	public class TraceConstructorAroundAdvice implements IConstructorAroundAdvice {

		public function TraceConstructorAroundAdvice() {
		}

		public function beforeConstructor(constructor:Constructor, args:Array):void {
			trace("*** before constructor in around advice");
			//args[0] = "Constructor argument was replaced by the advice";
		}

		public function afterConstructor(constructor:Constructor, args:Array, target:*):void {
			trace("*** after constructor in around advice");
		}

		public function afterConstructorThrowing(constructor:Constructor, args:Array, error:Error):void {
			trace("*** after constructor throwing in around advice. Error '" + error + "'");
		}
	}
}
