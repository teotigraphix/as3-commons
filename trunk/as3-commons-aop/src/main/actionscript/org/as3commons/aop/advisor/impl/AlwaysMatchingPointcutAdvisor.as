package org.as3commons.aop.advisor.impl {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.pointcut.impl.AlwaysMatchingPointcut;

	public class AlwaysMatchingPointcutAdvisor extends PointcutAdvisor {

		public function AlwaysMatchingPointcutAdvisor(advice:IAdvice) {
			super(new AlwaysMatchingPointcut(), advice);
		}
	}
}
