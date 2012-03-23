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
package org.as3commons.aop.factory {
	import org.as3commons.aop.advice.IAdvice;
	import org.as3commons.async.operation.IOperation;

	/**
	 * Factory that creates a single proxy.
	 *
	 * @author Christophe Herreman
	 */
	public interface IAOPProxyFactory {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The class or instance to proxy.
		 * @param value
		 */
		function set target(value:*):void;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds an advice to this proxy factory.
		 * @param advice
		 */
		function addAdvice(advice:IAdvice):void;

		/**
		 * Start the asynchronous creation of the proxy.
		 * @return an operation that can be listened to in order to know when the proxy is created
		 */
		function load():IOperation;

		/**
		 * Returns a new proxy.
		 * @return
		 */
		function getProxy(constructorArgs:Array = null):*;

	}
}
