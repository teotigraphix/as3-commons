package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.setter.ISetterAroundAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceSetterAroundAdvice implements ISetterAroundAdvice {

		public function TraceSetterAroundAdvice() {
		}

		public function beforeSetter(setter:Accessor, target:*, value:*):void {
			trace("* TraceSetterAroundAdvice before setter '" + setter.name + "' with value '" + value + "'");
		}

		public function afterSetter(setter:Accessor):void {
			trace("* TraceSetterAroundAdvice after setter '" + setter.name + "'");
		}

		public function afterSetterThrows(setter:Accessor, value:*, target:*, error:Error):void {
			trace("* TraceSetterAroundAdvice after setter '" + setter.name + "' throws");
		}
	}
}
