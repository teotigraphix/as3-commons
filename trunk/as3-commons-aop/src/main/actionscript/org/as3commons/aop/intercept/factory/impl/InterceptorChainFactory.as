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
package org.as3commons.aop.intercept.factory.impl {
	import org.as3commons.aop.advice.constructor.IConstructorAdvice;
	import org.as3commons.aop.advice.getter.IGetterAdvice;
	import org.as3commons.aop.advice.method.IMethodAdvice;
	import org.as3commons.aop.advice.setter.ISetterAdvice;
	import org.as3commons.aop.advisor.IAdvisor;
	import org.as3commons.aop.intercept.IInterceptor;
	import org.as3commons.aop.intercept.impl.ConstructorAdviceInterceptor;
	import org.as3commons.aop.intercept.impl.GetterAdviceInterceptor;
	import org.as3commons.aop.intercept.impl.MethodAdviceInterceptor;
	import org.as3commons.aop.intercept.factory.IInterceptorChainFactory;
	import org.as3commons.aop.intercept.impl.SetterAdviceInterceptor;

	/**
	 * Default implementation of IInterceptorChainFactory.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 */
	public class InterceptorChainFactory implements IInterceptorChainFactory {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function InterceptorChainFactory() {
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function getChain(advisors:Vector.<IAdvisor>):Vector.<IInterceptor> {
			var result:Vector.<IInterceptor> = new Vector.<IInterceptor>();

			for each (var advisor:IAdvisor in advisors) {
				if (advisor.advice is IInterceptor) {
					result.push(advisor.advice);
				} else {
					// TODO there should be an AdviceInterceptor that combines constructor, method and accessor
					// interception. Right now, multiple (unneeded) interceptors will be created for advice
					// that implements several types of advice
					if (advisor.advice is IConstructorAdvice) {
						result.push(new ConstructorAdviceInterceptor(IConstructorAdvice(advisor.advice)))
					}
					if (advisor.advice is IMethodAdvice) {
						result.push(new MethodAdviceInterceptor(IMethodAdvice(advisor.advice)));
					}
					if (advisor.advice is IGetterAdvice) {
						result.push(new GetterAdviceInterceptor(IGetterAdvice(advisor.advice)));
					}
					if (advisor.advice is ISetterAdvice) {
						result.push(new SetterAdviceInterceptor(ISetterAdvice(advisor.advice)));
					}
				}
			}

			return result;
		}
	}
}
