package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.setter.ISetterAroundAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceSetterAroundAdvice implements ISetterAroundAdvice {

		public function TraceSetterAroundAdvice() {
		}

		public function beforeSetter(setter:Accessor):void {
			trace("*** before setter");
		}

		public function afterSetter(setter:Accessor):void {
			trace("*** after setter");
		}
	}
}
