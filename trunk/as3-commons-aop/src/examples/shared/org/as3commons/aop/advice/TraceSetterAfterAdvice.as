package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.setter.ISetterAfterAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceSetterAfterAdvice implements ISetterAfterAdvice {
		public function TraceSetterAfterAdvice() {
		}

		public function afterSetter(setter:Accessor):void {
			trace("*** after setter");
		}
	}
}
