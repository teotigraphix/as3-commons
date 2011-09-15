package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.setter.ISetterBeforeAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceSetterBeforeAdvice implements ISetterBeforeAdvice {
		public function TraceSetterBeforeAdvice() {
		}

		public function beforeSetter(setter:Accessor, target:*, value:*):void {
			trace("*** before setter");
		}
	}
}
