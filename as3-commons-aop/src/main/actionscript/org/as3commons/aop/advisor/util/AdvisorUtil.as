/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.aop.advisor.util {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advisor.IAdvisor;
	import org.as3commons.aop.advisor.IPointcutAdvisor;
	import org.as3commons.aop.pointcut.IAccessorPointcut;
	import org.as3commons.aop.pointcut.IConstructorPointcut;
	import org.as3commons.aop.pointcut.IMethodPointcut;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Method;

	/**
	 * Utilities for working with IAdvisor objects.
	 *
	 * @author Christophe Herreman
	 */
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

		public static function getAccessorAdvisors(advisors:Vector.<IAdvisor>, accessor:Accessor):Vector.<IAdvisor> {
			var result:Vector.<IAdvisor> = new Vector.<IAdvisor>();
			for each (var advisor:IPointcutAdvisor in advisors) {
				if (advisor.pointcut is IAccessorPointcut) {
					var pointcut:IAccessorPointcut = IAccessorPointcut(advisor.pointcut);
					if (pointcut.matchesAccessor(accessor)) {
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
