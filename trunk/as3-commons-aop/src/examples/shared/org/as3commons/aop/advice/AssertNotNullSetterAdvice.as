package org.as3commons.aop.advice {
	import org.as3commons.aop.advice.setter.ISetterBeforeAdvice;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Accessor;

	public class AssertNotNullSetterAdvice implements ISetterBeforeAdvice {

		public function AssertNotNullSetterAdvice() {
		}

		public function beforeSetter(setter:Accessor, target:*, value:*):void {
			Assert.notNull(value);
		}
	}
}
