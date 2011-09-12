package org.as3commons.aop.advisor.impl {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advisor.IPointcutAdvisor;
	import org.as3commons.aop.pointcut.IPointcut;

	public class PointcutAdvisor implements IPointcutAdvisor {

		private var _pointcut:IPointcut;
		private var _advice:IAdvice;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function PointcutAdvisor(pointcut:IPointcut, advice:IAdvice) {
			_pointcut = pointcut;
			_advice = advice;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get pointcut():IPointcut {
			return _pointcut;
		}

		public function get advice():IAdvice {
			return _advice;
		}
	}
}
