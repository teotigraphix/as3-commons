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
package org.as3commons.aop.intercept {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorAfterAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorAfterThrowingAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorBeforeAdvice;
	import org.as3commons.aop.advice.getter.IGetterAfterAdvice;
	import org.as3commons.aop.advice.getter.IGetterBeforeAdvice;
	import org.as3commons.aop.advice.method.IMethodAfterAdvice;
	import org.as3commons.aop.advice.method.IMethodAfterReturningAdvice;
	import org.as3commons.aop.advice.method.IMethodBeforeAdvice;
	import org.as3commons.aop.advice.method.IMethodThrowingAdvice;
	import org.as3commons.aop.advice.setter.ISetterAfterAdvice;
	import org.as3commons.aop.advice.setter.ISetterBeforeAdvice;
	import org.as3commons.aop.advice.util.AdviceUtil;
	import org.as3commons.aop.advisor.IAdvisor;
	import org.as3commons.aop.advisor.IPointcutAdvisor;
	import org.as3commons.aop.advisor.util.AdvisorUtil;
	import org.as3commons.aop.as3commons_aop;
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
		
		private var _currentSetterInvocation:IMethodInvocation;
		private var _advisors:Vector.<IAdvisor> = new Vector.<IAdvisor>();

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AdvisorInterceptor(advisors:Vector.<IAdvisor>){
			_advisors = advisors;
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
					applyGetterAdvice(invocation);
					break;
				case InvocationKind.SETTER:
					applySetterAdvice(invocation);
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
				var advice:Vector.<IAdvice> = AdvisorUtil.getAdvice(advisors);
				applyConstructorBeforeAdvice(constructor, invocation, advice);
				// Note: constructor "throws" and "after" advice is executed
				// by the factory that creates the proxy
			}
		}

		private function applyConstructorBeforeAdvice(constructor:Constructor, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var constructorBeforeAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IConstructorBeforeAdvice, advice);
			for each (var a:IConstructorBeforeAdvice in constructorBeforeAdvice) {
				a.beforeConstructor(constructor, invocation.arguments);
			}
		}
		
		private function applyMethodAdvice(invocation:IMethodInvocation):void {
			var type:Type = Type.forInstance(invocation.targetInstance);
			var method:Method = type.getMethod(invocation.targetMember.localName);
			var advisors:Vector.<IAdvisor> = AdvisorUtil.getAdvisorsWithMatchingMethodPointcut(_advisors, method);

			if (advisors.length > 0) {
				var advice:Vector.<IAdvice> = AdvisorUtil.getAdvice(advisors);
				applyMethodBeforeAdvice(method, invocation, advice);
				invokeMethod(method, invocation, advice);
			}
		}

		private function applyMethodBeforeAdvice(method:Method, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var methodBeforeAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodBeforeAdvice, advice);
			for each (var mba:IMethodBeforeAdvice in methodBeforeAdvice) {
				mba.beforeMethod(method, invocation.arguments, invocation.targetInstance);
			}
		}

		private function invokeMethod(method:Method, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			try {
				invocation.proceed = false;
				invocation.returnValue = invocation.targetMethod.apply(invocation.targetInstance, invocation.arguments);
				applyMethodAfterReturningAdvice(method, invocation, advice);
			} catch (e:Error) {
				applyMethodThrowsAdvice(method, invocation, e, advice);
				throw e;
			} finally {
				applyMethodAfterAdvice(method, invocation, advice);
			}
		}

		private function applyMethodAfterReturningAdvice(method:Method, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var methodAfterReturningAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodAfterReturningAdvice, advice);
			for each (var a:IMethodAfterReturningAdvice in methodAfterReturningAdvice) {
				a.afterMethodReturning(invocation.returnValue, method, invocation.arguments, invocation.targetInstance);
			}
		}

		private function applyMethodThrowsAdvice(method:Method, invocation:IMethodInvocation, error:Error, advice:Vector.<IAdvice>):void {
			var methodThrowsAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodThrowingAdvice, advice);
			for each (var a:IMethodThrowingAdvice in methodThrowsAdvice) {
				a.afterMethodThrowing(method, invocation.arguments, invocation.targetInstance, error);
			}
		}

		private function applyMethodAfterAdvice(method:Method, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var methodAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodAfterAdvice, advice);
			for each (var maa:IMethodAfterAdvice in methodAfterAdvice) {
				maa.afterMethod(invocation.returnValue, method, invocation.arguments, invocation.targetInstance);
			}
		}
		
		private function applyGetterAdvice(invocation:IMethodInvocation):void {
			var type:Type = Type.forInstance(invocation.targetInstance);
			var getter:Accessor = Accessor(type.getField(invocation.targetMember.localName));
			var advisors:Vector.<IAdvisor> = getAccessorAdvisors(getter);

			if (advisors.length > 0) {
				var advice:Vector.<IAdvice> = AdvisorUtil.getAdvice(advisors);
				applyGetterBeforeAdvice(getter, invocation, advice);
				invokeGetter(getter, invocation);
				applyGetterAfterAdvice(getter, invocation, advice);
			}
		}

		private function getAccessorAdvisors(accessor:Accessor):Vector.<IAdvisor> {
			var result:Vector.<IAdvisor> = new Vector.<IAdvisor>();
			for each (var advisor:IPointcutAdvisor in _advisors) {
				if (advisor.pointcut is IAccessorPointcut) {
					var pointcut:IAccessorPointcut = IAccessorPointcut(advisor.pointcut);
					if (pointcut.matchesAccessor(accessor)) {
						result.push(advisor);
					}
				}
			}
			return result;
		}

		private function applyGetterBeforeAdvice(getter:Accessor, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var getterBeforeAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IGetterBeforeAdvice, advice);
			for each (var a:IGetterBeforeAdvice in getterBeforeAdvice) {
				a.beforeGetter(getter);
			}
		}

		private function invokeGetter(getter:Accessor, invocation:IMethodInvocation):void {
			//invocation.proceed = false;
			//invocation.returnValue = invocation.targetInstance[getter.name];
		}

		private function applyGetterAfterAdvice(getter:Accessor, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var getterAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IGetterAfterAdvice, advice);
			for each (var a:IGetterAfterAdvice in getterAfterAdvice) {
				a.afterGetter(getter);
			}
		}
		
		private function applySetterAdvice(invocation:IMethodInvocation):void {
			if (_currentSetterInvocation) {
				_currentSetterInvocation = null;
			} else {
				var type:Type = Type.forInstance(invocation.targetInstance);
				var setter:Accessor = Accessor(type.getField(invocation.targetMember.localName));
				var advisors:Vector.<IAdvisor> = getAccessorAdvisors(setter);

				if (advisors.length > 0) {
					var advice:Vector.<IAdvice> = AdvisorUtil.getAdvice(advisors);
					applySetterBeforeAdvice(setter, invocation, advice);
					invokeSetter(setter, invocation);
					applySetterAfterAdvice(setter, invocation, advice);
				}
			}
		}

		private function applySetterBeforeAdvice(getter:Accessor, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var setterBeforeAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(ISetterBeforeAdvice, advice);
			for each (var a:ISetterBeforeAdvice in setterBeforeAdvice) {
				a.beforeSetter(getter);
			}
		}

		private function invokeSetter(setter:Accessor, invocation:IMethodInvocation):void {
			_currentSetterInvocation = invocation;
			invocation.proceed = false;
			invocation.targetInstance[setter.name] = invocation.arguments[0];
			invocation.returnValue = invocation.arguments[0];
		}

		private function applySetterAfterAdvice(setter:Accessor, invocation:IMethodInvocation, advice:Vector.<IAdvice>):void {
			var setterAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(ISetterAfterAdvice, advice);
			for each (var a:ISetterAfterAdvice in setterAfterAdvice) {
				a.afterSetter(setter);
			}
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
				var advice:Vector.<IAdvice> = AdvisorUtil.getAdvice(advisors);
				var constructorThrowsAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IConstructorAfterThrowingAdvice, advice);
				for each (var a:IConstructorAfterThrowingAdvice in constructorThrowsAdvice) {
					a.afterConstructorThrowing(constructor, args, error);
				}
			}
		}
		
		as3commons_aop function applyConstructorAfterAdvice(clazz:Class, proxy:*, args:Array = null):void {
			var constructor:Constructor = Type.forClass(clazz).constructor;
			var advisors:Vector.<IAdvisor> = AdvisorUtil.getAdvisorsWithMatchingConstructorPointcut(_advisors, constructor);

			if (advisors.length > 0) {
				var advice:Vector.<IAdvice> = AdvisorUtil.getAdvice(advisors);
				var constructorAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IConstructorAfterAdvice, advice);
				for each (var a:IConstructorAfterAdvice in constructorAfterAdvice) {
					a.afterConstructor(constructor, args, proxy);
				}
			}
		}
	}
}
