package org.as3commons.aop.advisor.util {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advisor.IAdvisor;
	import org.as3commons.aop.advisor.IPointcutAdvisor;
	import org.as3commons.aop.pointcut.IConstructorPointcut;
	import org.as3commons.aop.pointcut.IMethodPointcut;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Method;

	public class AdvisorUtil {

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		public static function getAdvisorsWithMatchingConstructorPointcut(advisors:Vector.<IAdvisor>, constructor:Constructor):Vector.<IAdvisor> {
			var result:Vector.<IAdvisor> = new Vector.<IAdvisor>();
			for each (var advisor:IPointcutAdvisor in advisors) {
				if (advisor.pointcut is IConstructorPointcut) {
					var pointcut:IConstructorPointcut = IConstructorPointcut(advisor.pointcut);
					if (pointcut.matchesConstructor(constructor)) {
						result.push(advisor);
					}
				}
			}
			return result;
		}

		public static function getAdvisorsWithMatchingMethodPointcut(advisors:Vector.<IAdvisor>, method:Method):Vector.<IAdvisor> {
			var result:Vector.<IAdvisor> = new Vector.<IAdvisor>();
			for each (var advisor:IPointcutAdvisor in advisors) {
				if (advisor.pointcut is IMethodPointcut) {
					var pointcut:IMethodPointcut = IMethodPointcut(advisor.pointcut);
					if (pointcut.matchesMethod(method)) {
						result.push(advisor);
					}
				}
			}
			return result;
		}

		public static function getAdvice(advisors:Vector.<IAdvisor>):Vector.<IAdvice> {
			var result:Vector.<IAdvice> = new Vector.<IAdvice>();
			for each (var advisor:IAdvisor in advisors) {
				result.push(advisor.advice);
			}
			return result;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AdvisorUtil() {
		}
	}
}
