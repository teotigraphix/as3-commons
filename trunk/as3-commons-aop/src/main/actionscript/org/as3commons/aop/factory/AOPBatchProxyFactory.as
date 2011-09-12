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
package org.as3commons.aop.factory {
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advisor.IAdvisor;
	import org.as3commons.aop.advisor.impl.AlwaysMatchingPointcutAdvisor;
	import org.as3commons.aop.as3commons_aop;
	import org.as3commons.aop.intercept.AdvisorInterceptor;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.bytecode.interception.impl.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.proxy.impl.ProxyFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.lang.ClassUtils;

	use namespace as3commons_aop;

	public class AOPBatchProxyFactory {

		private var _proxyFactory:IProxyFactory;
		private var _advisors:Dictionary = new Dictionary();
		private var _adviceInterceptor:AdvisorInterceptor;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AOPBatchProxyFactory() {
			// TODO externalize this
			ByteCodeType.fromLoader(FlexGlobals.topLevelApplication.loaderInfo);

			_proxyFactory = new ProxyFactory();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, proxyFactory_getMethodInvocationInterceptorHandler);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function addTarget(target:*, advisors:Vector.<IAdvisor> = null):void {
			if (target is Class) {
				_proxyFactory.defineProxy(target);
			} else {
				var targetClass:Class = ClassUtils.forInstance(target);
				_proxyFactory.defineProxy(target);
			}

			advisors ||= new Vector.<IAdvisor>();
			_advisors[target] = advisors;
		}

		public function addAdvice(advice:IAdvice, target:* = null):void {
			addAdvisor(new AlwaysMatchingPointcutAdvisor(advice), target);
		}

		public function addAdvisor(advisor:IAdvisor, target:* = null):void {
			if (target) {
				addAdvisorForTarget(advisor, target);
			} else {
				addAdvisorToAllTargets(advisor);
			}
		}

		public function createProxies():IOperation {
			_proxyFactory.generateProxyClasses();
			return new LoadProxyFactoryOperation(_proxyFactory);
		}

		public function getProxy(target:*, constructorArgs:Array = null):* {
			var result:*;
			var clazz:Class = getTargetClass(target);
			
			try {
				result = _proxyFactory.createProxy(clazz, constructorArgs);
			} catch (e:Error) {
				applyConstructorThrowsAdvice(clazz, e, constructorArgs);
			} finally {
				applyConstructorAfterAdvice(clazz, result, constructorArgs);
			}
			
			return result;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function addAdvisorForTarget(advisor:IAdvisor, target:*):void {
			getAdvisorsForTarget(target).push(advisor);
		}

		private function getAdvisorsForTarget(target:*):Vector.<IAdvisor> {
			if (!_advisors[target]) {
				_advisors[target] = new Vector.<IAdvisor>();
			}
			return _advisors[target];
		}

		private function addAdvisorToAllTargets(advisor:IAdvisor):void {
			for (var target:* in _advisors) {
				addAdvisorForTarget(advisor, target);
			}
		}

		private function getTargetClass(target:*):Class {
			if (target is Class) {
				return Class(target);
			}
			return ByteCodeType.forInstance(target).clazz;
		}

		private function proxyFactory_getMethodInvocationInterceptorHandler(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			var advisors:Vector.<IAdvisor> = getAdvisorsForTarget(event.proxiedClass);
			_adviceInterceptor = new AdvisorInterceptor(advisors);
			interceptor.interceptors.push(_adviceInterceptor);
			event.methodInvocationInterceptor = interceptor;
		}

		private function applyConstructorThrowsAdvice(clazz:Class, error:Error, args:Array = null):void {
			_adviceInterceptor.as3commons_aop::applyConstructorThrowsAdvice(clazz, error, args);
		}
		
		private function applyConstructorAfterAdvice(clazz:Class, proxy:*, args:Array = null):void {
			_adviceInterceptor.as3commons_aop::applyConstructorAfterAdvice(clazz, proxy, args);
		}

	}
}
