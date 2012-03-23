/*
 * Copyright 2007-2012 the original author or authors.
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

		public static function getAdvisorsThatMatchConstructorPointcut(advisors:Vector.<IAdvisor>, constructor:Constructor):Vector.<IAdvisor> {
			return getAdvisorsThatMatchPointcutCriterion(advisors, constructor);
		}

		public static function getAdvisorsThatMatchMethodPointcut(advisors:Vector.<IAdvisor>, method:Method):Vector.<IAdvisor> {
			return getAdvisorsThatMatchPointcutCriterion(advisors, method);
		}

		public static function getAdvisorsThatMatchAccessorPointcut(advisors:Vector.<IAdvisor>, accessor:Accessor):Vector.<IAdvisor> {
			return getAdvisorsThatMatchPointcutCriterion(advisors, accessor);
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
		// Private Static Methods
		//
		// --------------------------------------------------------------------

		private static function getAdvisorsThatMatchPointcutCriterion(advisors:Vector.<IAdvisor>, criterion:*):Vector.<IAdvisor> {
			var result:Vector.<IAdvisor> = new Vector.<IAdvisor>();
			for each (var advisor:IPointcutAdvisor in advisors) {
				if (advisor.pointcut.matches(criterion)) {
					result.push(advisor);
				}
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
