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
package org.as3commons.aop.factory.impl {
	import flash.display.LoaderInfo;

	import org.as3commons.aop.*;
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.aop.advisor.IAdvisor;
	import org.as3commons.aop.factory.*;
	import org.as3commons.aop.intercept.IInterceptor;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.Assert;

	use namespace as3commons_aop;

	/**
	 * Proxy factory that is able to proxy 1 target (class or instance). Note that when several
	 * targets need to be proxied, it is better to use the AOPBatchProxyFactory.
	 *
	 * @author Christophe Herreman
	 */
	public class AOPProxyFactory implements IAOPProxyFactory {

		// --------------------------------------------------------------------
		//
		// Private
		//
		// --------------------------------------------------------------------

		private var _proxyFactory:AOPBatchProxyFactory;
		private var _target:*;
		private var _adviceAndAdvisors:Array;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>AOPProxyFactory</code>.
		 *
		 * @param loaderInfo an optional loaderInfo on which bytecode reflection will
		 * be done. In case this is not provided, the loader info will be determined.
		 * For Flex applications, this is generally not needed.
		 */
		public function AOPProxyFactory(loaderInfo:LoaderInfo=null) {
			super();
			_proxyFactory = new AOPBatchProxyFactory(loaderInfo);
			_adviceAndAdvisors = [];
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The target to proxy. This can either be a class or an instance.
		 * @param value
		 */
		public function set target(value:*):void {
			Assert.notNull(value);
			Assert.state(_target == null, "The target has already been set.");
			_target = value;
			_proxyFactory.addTarget(value);
			addAdviceAndAdvisors();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function addAdvice(advice:IAdvice):void {
			if (_target) {
				_proxyFactory.addAdvice(advice, _target);
			} else {
				_adviceAndAdvisors.push(advice);
			}
		}

		public function addAdvisor(advisor:IAdvisor):void {
			if (_target) {
				_proxyFactory.addAdvisor(advisor, _target);
			} else {
				_adviceAndAdvisors.push(advisor);
			}
		}

		/*public function addInterceptor(interceptor:IInterceptor):void {
			if (_target) {
				_proxyFactory.addInterceptor(interceptor, _target);
			} else {
				_adviceAndAdvisors.push(interceptor);
			}
		}*/

		public function load():IOperation {
			return _proxyFactory.load();
		}

		public function getProxy(constructorArgs:Array=null):* {
			return _proxyFactory.getProxy(_target, constructorArgs);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function addAdviceAndAdvisors():void {
			for (var i:uint = 0; i < _adviceAndAdvisors.length; i++) {
				var adviceOrAdvisor:* = _adviceAndAdvisors[i];
				if (adviceOrAdvisor is IAdvice) {
					_proxyFactory.addAdvice(adviceOrAdvisor, _target);
				} else if (adviceOrAdvisor is IAdvisor) {
					_proxyFactory.addAdvisor(adviceOrAdvisor, _target);
				}
				/* else if (adviceOrAdvisor is IInterceptor) {
					addInterceptor(adviceOrAdvisor)
				}*/
			}
			_adviceAndAdvisors = null;
		}

	}
}
