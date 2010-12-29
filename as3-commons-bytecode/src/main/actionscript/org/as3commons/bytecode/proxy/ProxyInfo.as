/*
* Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.proxy {
	import flash.system.ApplicationDomain;

	import mx.core.IFactory;

	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;

	/**
	 * Contains the the necessary information for an <code>IProxyFactory</code> to
	 * create an instance of a proxy class.
	 * @author Roland Zwaga
	 */
	public final class ProxyInfo {

		public var proxiedClass:Class;
		public var proxyClass:Class;
		public var proxyClassName:String;
		public var applicationDomain:ApplicationDomain;
		public var methodInvocationInterceptorClass:Class;
		public var interceptorFactory:IFactory;

		/**
		 * Creates a new <code>ProxyInfo</code> instance.
		 * @param className
		 *
		 */
		public function ProxyInfo(className:String) {
			super();
			initProxyInfo(className);
		}

		/**
		 * Initializes the current <code>ProxyInfo</code> instance.
		 * @param className
		 */
		protected function initProxyInfo(className:String):void {
			Assert.hasText(className, "className argument must not be empty or null");
			proxyClassName = className;
		}

	}
}