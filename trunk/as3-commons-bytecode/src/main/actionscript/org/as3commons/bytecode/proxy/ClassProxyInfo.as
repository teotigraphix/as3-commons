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
	import flash.system.Capabilities;
	import flash.system.System;

	import org.as3commons.lang.Assert;

	/**
	 * Contains all the necessary information for an <code>IProxyFactory</code> to generate
	 * a proxy class.
	 * @author Roland Zwaga
	 */
	public final class ClassProxyInfo {

		private var _proxiedClass:Class;
		private var _methodInvocationInterceptorClass:Class;
		private var _methods:Array;
		private var _accessors:Array;
		private var _properties:Array;
		private var _onlyProxyConstructor:Boolean = false;
		private var _makeDynamic:Boolean = false;

		/**
		 * Creates a new <code>ClassProxyInfo</code> instance.
		 */
		public function ClassProxyInfo(proxiedClass:Class, methodInvocationInterceptorClass:Class = null) {
			super();
			initClassProxyInfo(proxiedClass, methodInvocationInterceptorClass);
		}

		/**
		 * The class for which a proxy will be generated.
		 */
		public function get proxiedClass():Class {
			return _proxiedClass;
		}

		/**
		 * The <code>Class</code> that will be injected into the proxy class as the main interceptor mechanism.
		 */
		public function get methodInvocationInterceptorClass():Class {
			return _methodInvocationInterceptorClass;
		}

		/**
		 * Initializes the current <code>ClassProxyInfo</code>.
		 * @param proxiedClass
		 * @param methodInvocationInterceptorClass
		 */
		protected function initClassProxyInfo(proxiedClass:Class, methodInvocationInterceptorClass:Class):void {
			Assert.notNull(proxiedClass, "proxiedClass argument must not be null");
			_proxiedClass = proxiedClass;
			_methodInvocationInterceptorClass = methodInvocationInterceptorClass;
			_methods = [];
			_accessors = [];
			_properties = [];
		}

		/**
		 * Determines if the proxy class will be marked as dynamic.
		 */
		public function get makeDynamic():Boolean {
			return _makeDynamic;
		}

		/**
		 * @private
		 */
		public function set makeDynamic(value:Boolean):void {
			_makeDynamic = value;
		}

		/**
		 * Determines whether the <code>IProxyFactory</code> should proxy all members of the proxied class.
		 */
		public function get proxyAll():Boolean {
			return ((_methods.length + _accessors.length + _properties.length) == 0);
		}

		/**
		 * Determines whether the <code>IProxyFactory</code> should only generate a proxy for the constructor.
		 * (No other members will be proxied).
		 */
		public function get onlyProxyConstructor():Boolean {
			return _onlyProxyConstructor;
		}

		/**
		 * @private
		 */
		public function set onlyProxyConstructor(value:Boolean):void {
			_onlyProxyConstructor = value;
		}

		/**
		 * Marks the specified method and optional namespace for proxying.
		 * @param methodName The specified method name.
		 * @param namespace Optionally the custom namespace of the specified method.
		 */
		public function proxyMethod(methodName:String, namespace:String = null):void {
			_methods[_methods.length] = new MemberInfo(methodName, namespace);
		}

		/**
		 * Marks the specified accessor and optional namespace for proxying.
		 * @param accessorName The specified accessor name.
		 * @param namespace Optionally the custom namespace of the specified accessor.
		 */
		public function proxyAccessor(accessorName:String, namespace:String = null):void {
			_accessors[_accessors.length] = new MemberInfo(accessorName, namespace);
		}

		/**
		 * An <code>Array</code> of <code>MemberInfo</code> instances that describe the methods
		 * that will be proxied for the specified class.
		 */
		public function get methods():Array {
			return _methods;
		}

		/**
		 * An <code>Array</code> of <code>MemberInfo</code> instances that describe the accessors
		 * that will be proxied for the specified class.
		 */
		public function get accessors():Array {
			return _accessors;
		}

	}
}