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
package org.as3commons.aop.intercept.impl {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advice.util.AdviceUtil;
	import org.as3commons.aop.advisor.IAdvisor;
	import org.as3commons.aop.advisor.IPointcutAdvisor;
	import org.as3commons.aop.advisor.util.AdvisorUtil;
	import org.as3commons.aop.as3commons_aop;
	import org.as3commons.aop.intercept.ISetterInterceptor;
	import org.as3commons.aop.intercept.factory.IInterceptorChainFactory;
	import org.as3commons.aop.intercept.factory.impl.InterceptorChainFactory;
	import org.as3commons.aop.intercept.invocation.ISetterInvocation;
	import org.as3commons.aop.intercept.invocation.impl.ConstructorInvocationWithInterceptors;
	import org.as3commons.aop.intercept.invocation.impl.GetterInvocationWithInterceptors;
	import org.as3commons.aop.intercept.invocation.impl.MethodInvocationWithInterceptors;
	import org.as3commons.aop.pointcut.IAccessorPointcut;
	import org.as3commons.bytecode.interception.IInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocation;
	import org.as3commons.bytecode.interception.impl.InvocationKind;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;

	use namespace as3commons_aop;

	/**
	 * Interceptor that executes a set of advisors on a proxy.
	 *
	 * @author Christophe Herreman
	 */
	public class AdvisorInterceptor implements IInterceptor {

		private var _currentGetterInvocation:IMethodInvocation;
		private var _currentSetterInvocation:IMethodInvocation;
		private var _advisors:Vector.<IAdvisor> = new Vector.<IAdvisor>();
		private var _interceptorChainFactory:IInterceptorChainFactory;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AdvisorInterceptor(advisors:Vector.<IAdvisor>) {
			_advisors = advisors;
			_interceptorChainFactory = new InterceptorChainFactory();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function intercept(invocation:IMethodInvocation):void {
			switch (invocation.kind) {
				case InvocationKind.CONSTRUCTOR:
					applyConstructorAdvice(invocation);
					break;
				case InvocationKind.METHOD:
					applyMethodAdvice(invocation);
					break;
				case InvocationKind.GETTER:
					//applyGetterAdvice(invocation);
					break;
				case InvocationKind.SETTER:
					//applySetterAdvice(invocation);
					break;
			}
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function applyConstructorAdvice(invocation:IMethodInvocation):void {
			var constructor:Constructor = Type.forInstance(invocation.targetInstance).constructor;
			var advisors:Vector.<IAdvisor> = AdvisorUtil.getAdvisorsWithMatchingConstructorPointcut(_advisors, constructor);

			if (advisors.length > 0) {
				// Note: constructor "throws" and "after" advice is executed
				// by the factory that creates the proxy
				var interceptors:Vector.<org.as3commons.aop.intercept.IInterceptor> = _interceptorChainFactory.getChain(advisors);
				var inv:ConstructorInvocationWithInterceptors = new ConstructorInvocationWithInterceptors(constructor, invocation.arguments, interceptors);
				inv.proceed();
			}
		}

		private function applyMethodAdvice(invocation:IMethodInvocation):void {
			var type:Type = Type.forInstance(invocation.targetInstance);
			var method:Method = type.getMethod(invocation.targetMember.localName);
			var advisors:Vector.<IAdvisor> = AdvisorUtil.getAdvisorsWithMatchingMethodPointcut(_advisors, method);

			if (advisors.length > 0) {
				invocation.proceed = false;
				invocation.returnValue = invokeMethod(invocation, method, advisors);
			}
		}

		private function invokeMethod(invocation:IMethodInvocation, method:Method, advisors:Vector.<IAdvisor>):* {
			var interceptors:Vector.<org.as3commons.aop.intercept.IInterceptor> = _interceptorChainFactory.getChain(advisors);
			var inv:MethodInvocationWithInterceptors = new MethodInvocationWithInterceptors(invocation.targetInstance, method, invocation.targetMethod, invocation.arguments, interceptors);
			return inv.proceed();
		}

		private function applyGetterAdvice(invocation:IMethodInvocation):void {
			if (_currentGetterInvocation) {
				_currentGetterInvocation = null;
			} else {
				var type:Type = Type.forInstance(invocation.targetInstance);
				var getter:Accessor = Accessor(type.getField(invocation.targetMember.localName));
				var advisors:Vector.<IAdvisor> = AdvisorUtil.getAccessorAdvisors(_advisors, getter);

				if (advisors.length > 0) {
					invocation.proceed = false;
					invocation.returnValue = invokeGetter(invocation, getter, advisors);
				}
			}
		}

		private function invokeGetter(invocation:IMethodInvocation, getter:Accessor, advisors:Vector.<IAdvisor>):* {
			_currentGetterInvocation = invocation;
			var interceptors:Vector.<org.as3commons.aop.intercept.IInterceptor> = _interceptorChainFactory.getChain(advisors);
			var inv:GetterInvocationWithInterceptors = new GetterInvocationWithInterceptors(invocation.targetInstance, getter, invocation.arguments, interceptors);
			return inv.proceed();
		}

		private function applySetterAdvice(invocation:IMethodInvocation):void {
			if (_currentSetterInvocation) {
				_currentSetterInvocation = null;
			} else {
				var type:Type = Type.forInstance(invocation.targetInstance);
				var setter:Accessor = Accessor(type.getField(invocation.targetMember.localName));
				var advisors:Vector.<IAdvisor> = AdvisorUtil.getAccessorAdvisors(_advisors, setter);

				if (advisors.length > 0) {
					var advice:Vector.<IAdvice> = AdvisorUtil.getAdvice(advisors);
					AdviceUtil.applySetterBeforeAdvice(advice, setter, invocation);
					invokeSetter(advice, setter, invocation);
					AdviceUtil.applySetterAfterAdvice(advice, setter, invocation);
				}
			}
		}

		private var _currentSetterInterceptor:ISetterInterceptor;

		private function interceptSetter(interceptor:ISetterInterceptor, invocation:IMethodInvocation):void {
			/*if (_currentSetterInterceptor) {
			 _currentSetterInterceptor = null;
			 } else {
			_currentSetterInterceptor = interceptor;
			var setterInvocation:ISetterInvocation = new SetterInvocation(invocation);
			interceptor.interceptSetter(setterInvocation);
			}*/
		}

		private function invokeSetter(advice:Vector.<IAdvice>, setter:Accessor, invocation:IMethodInvocation):void {
			_currentSetterInvocation = invocation;

			for each (var a:IAdvice in advice) {
				if (a is ISetterInterceptor) {
					interceptSetter(ISetterInterceptor(a), invocation);
				}
			}

			invocation.proceed = false;
			invocation.targetInstance[setter.name] = invocation.arguments[0];
			invocation.returnValue = invocation.arguments[0];
		}

		// --------------------------------------------------------------------
		//
		// Internal (as3commons_aop scope) methods
		//
		// --------------------------------------------------------------------

		as3commons_aop function applyConstructorThrowsAdvice(clazz:Class, error:Error, args:Array = null):void {
			var constructor:Constructor = Type.forClass(clazz).constructor;
			var advisors:Vector.<IAdvisor> = AdvisorUtil.getAdvisorsWithMatchingConstructorPointcut(_advisors, constructor);
			if (advisors.length > 0) {
				AdviceUtil.applyConstructorThrowsAdvice(AdvisorUtil.getAdvice(advisors), constructor, error, args);
			}
		}

		as3commons_aop function applyConstructorAfterAdvice(clazz:Class, proxy:*, args:Array = null):void {
			var constructor:Constructor = Type.forClass(clazz).constructor;
			var advisors:Vector.<IAdvisor> = AdvisorUtil.getAdvisorsWithMatchingConstructorPointcut(_advisors, constructor);
			if (advisors.length > 0) {
				AdviceUtil.applyConstructorAfterAdvice(AdvisorUtil.getAdvice(advisors), constructor, proxy, args);
			}
		}
	}
}
