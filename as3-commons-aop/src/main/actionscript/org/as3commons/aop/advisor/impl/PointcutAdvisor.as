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
package org.as3commons.aop.advisor.impl {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advisor.IPointcutAdvisor;
	import org.as3commons.aop.pointcut.IPointcut;
	import org.as3commons.lang.Assert;

	/**
	 * Default and immutable implementation of IPointcutAdvisor.
	 *
	 * @author Christophe Herreman
	 */
	public class PointcutAdvisor implements IPointcutAdvisor {

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _pointcut:IPointcut;
		private var _advice:IAdvice;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function PointcutAdvisor(pointcut:IPointcut, advice:IAdvice) {
			Assert.notNull(pointcut, "The pointcut must not be null");
			Assert.notNull(advice, "The advice must not be null");
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
