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
package org.as3commons.aop.advice.util {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorAfterAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorAfterThrowingAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorBeforeAdvice;
	import org.as3commons.aop.advice.getter.IGetterAfterAdvice;
	import org.as3commons.aop.advice.getter.IGetterBeforeAdvice;
	import org.as3commons.aop.advice.method.IMethodAfterAdvice;
	import org.as3commons.aop.advice.method.IMethodAfterReturningAdvice;
	import org.as3commons.aop.advice.method.IMethodBeforeAdvice;
	import org.as3commons.aop.advice.method.IMethodThrowsAdvice;
	import org.as3commons.aop.advice.setter.ISetterAfterAdvice;
	import org.as3commons.aop.advice.setter.ISetterBeforeAdvice;
	import org.as3commons.aop.as3commons_aop;
	import org.as3commons.bytecode.interception.IMethodInvocation;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Method;

	/**
	 * Utilities for working with advice objects.
	 *
	 * @author Christophe Herreman
	 */
	public class AdviceUtil {

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		public static function getAdviceByType(adviceClass:Class, advice:Vector.<IAdvice>):Vector.<IAdvice> {
			Assert.notNull(adviceClass, "The advice class must not be null");
			Assert.notNull(advice, "The advice vector must not be null");

			var result:Vector.<IAdvice> = new Vector.<IAdvice>();
			for each (var a:IAdvice in advice) {
				if (a is adviceClass) {
					result.push(a);
				}
			}
			return result;
		}

		// --------------------------------------------------------------------
		//
		// Static Helper Methods
		//
		// --------------------------------------------------------------------

		as3commons_aop static function applyConstructorBeforeAdvice(advice:Vector.<IAdvice>, constructor:Constructor, invocation:IMethodInvocation):void {
			var constructorBeforeAdvice:Vector.<IAdvice> = getAdviceByType(IConstructorBeforeAdvice, advice);
			for each (var a:IConstructorBeforeAdvice in constructorBeforeAdvice) {
				a.beforeConstructor(constructor, invocation.arguments);
			}
		}

		as3commons_aop static function applyConstructorThrowsAdvice(advice:Vector.<IAdvice>, constructor:Constructor, error:Error, args:Array = null):void {
			var constructorThrowsAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IConstructorAfterThrowingAdvice, advice);
			for each (var a:IConstructorAfterThrowingAdvice in constructorThrowsAdvice) {
				a.afterConstructorThrowing(constructor, args, error);
			}
		}

		as3commons_aop static function applyConstructorAfterAdvice(advice:Vector.<IAdvice>, constructor:Constructor, proxy:*, args:Array = null):void {
			var constructorAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IConstructorAfterAdvice, advice);
			for each (var a:IConstructorAfterAdvice in constructorAfterAdvice) {
				a.afterConstructor(constructor, args, proxy);
			}
		}

		as3commons_aop static function applyMethodBeforeAdvice(advice:Vector.<IAdvice>, method:Method, invocation:IMethodInvocation):void {
			var methodBeforeAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodBeforeAdvice, advice);
			for each (var mba:IMethodBeforeAdvice in methodBeforeAdvice) {
				mba.beforeMethod(method, invocation.arguments, invocation.targetInstance);
			}
		}

		as3commons_aop static function invokeMethodAndApplyAdvice(advice:Vector.<IAdvice>, method:Method, invocation:IMethodInvocation):void {
			try {
				as3commons_aop::proceedMethodInvocation(invocation);
				as3commons_aop::applyMethodAfterReturningAdvice(advice, method, invocation);
			} catch (e:Error) {
				as3commons_aop::applyMethodThrowsAdvice(advice, method, invocation, e);
				throw e;
			} finally {
				as3commons_aop::applyMethodAfterAdvice(advice, method, invocation);
			}
		}

		as3commons_aop static function proceedMethodInvocation(invocation:IMethodInvocation):void {
			invocation.proceed = false;
			invocation.returnValue = invocation.targetMethod.apply(invocation.targetInstance, invocation.arguments);
		}

		as3commons_aop static function applyMethodAfterReturningAdvice(advice:Vector.<IAdvice>, method:Method, invocation:IMethodInvocation):void {
			var methodAfterReturningAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodAfterReturningAdvice, advice);
			for each (var a:IMethodAfterReturningAdvice in methodAfterReturningAdvice) {
				a.afterMethodReturning(invocation.returnValue, method, invocation.arguments, invocation.targetInstance);
			}
		}

		as3commons_aop static function applyMethodThrowsAdvice(advice:Vector.<IAdvice>, method:Method, invocation:IMethodInvocation, error:Error):void {
			var methodThrowsAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodThrowsAdvice, advice);
			for each (var a:IMethodThrowsAdvice in methodThrowsAdvice) {
				a.afterMethodThrowing(method, invocation.arguments, invocation.targetInstance, error);
			}
		}

		as3commons_aop static function applyMethodAfterAdvice(advice:Vector.<IAdvice>, method:Method, invocation:IMethodInvocation):void {
			var methodAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IMethodAfterAdvice, advice);
			for each (var maa:IMethodAfterAdvice in methodAfterAdvice) {
				maa.afterMethod(invocation.returnValue, method, invocation.arguments, invocation.targetInstance);
			}
		}

		as3commons_aop static function applyGetterBeforeAdvice(advice:Vector.<IAdvice>, getter:Accessor, invocation:IMethodInvocation):void {
			var getterBeforeAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IGetterBeforeAdvice, advice);
			for each (var a:IGetterBeforeAdvice in getterBeforeAdvice) {
				a.beforeGetter(getter, invocation.targetInstance);
			}
		}

		as3commons_aop static function applyGetterAfterAdvice(advice:Vector.<IAdvice>, getter:Accessor, invocation:IMethodInvocation):void {
			var getterAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IGetterAfterAdvice, advice);
			for each (var a:IGetterAfterAdvice in getterAfterAdvice) {
				a.afterGetter(invocation.returnValue, getter, invocation.targetInstance);
			}
		}

		as3commons_aop static function applySetterBeforeAdvice(advice:Vector.<IAdvice>, getter:Accessor, invocation:IMethodInvocation):void {
			var setterBeforeAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(ISetterBeforeAdvice, advice);
			for each (var a:ISetterBeforeAdvice in setterBeforeAdvice) {
				a.beforeSetter(getter, invocation.targetInstance, invocation.arguments[0]);
			}
		}

		as3commons_aop static function applySetterAfterAdvice(advice:Vector.<IAdvice>, setter:Accessor, invocation:IMethodInvocation):void {
			var setterAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(ISetterAfterAdvice, advice);
			for each (var a:ISetterAfterAdvice in setterAfterAdvice) {
				a.afterSetter(setter);
			}
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AdviceUtil() {
		}

	}
}
