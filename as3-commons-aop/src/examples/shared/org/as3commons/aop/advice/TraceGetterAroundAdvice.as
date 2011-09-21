package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.getter.IGetterAroundAdvice;
	import org.as3commons.reflect.Accessor;

	public class TraceGetterAroundAdvice implements IGetterAroundAdvice {

		public function TraceGetterAroundAdvice() {
		}

		public function beforeGetter(getter:Accessor, target:*):void {
			trace("* TraceGetterAroundAdvice before getter");
		}

		public function afterGetter(result:*, getter:Accessor, target:*):void {
			trace("* TraceGetterAroundAdvice after getter");
		}

		public function afterGetterThrows(setter:Accessor, target:*, error:Error):void {
			trace("* TraceGetterAroundAdvice after getter throws");
		}
	}
}
