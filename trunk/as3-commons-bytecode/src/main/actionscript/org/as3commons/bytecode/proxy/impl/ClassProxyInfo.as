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
package org.as3commons.bytecode.proxy.impl {
	import flash.errors.IllegalOperationError;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptorFactory;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.ProxyScope;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;

	/**
	 * @inheritDoc
	 */
	public final class ClassProxyInfo implements IClassProxyInfo {

		/**
		 * Creates a new <code>ClassProxyInfo</code> instance.
		 */
		public function ClassProxyInfo(proxiedClass:Class, methodInvocationInterceptorClass:Class=null) {
			super();
			initClassProxyInfo(proxiedClass, methodInvocationInterceptorClass);
		}

		private var _accessors:Array;
		private var _interfaceAccessors:Array;
		private var _interceptorFactory:IMethodInvocationInterceptorFactory;
		private var _introducedInterfaces:Array;
		private var _introductions:Array;
		private var _makeDynamic:Boolean = false;
		private var _methodInvocationInterceptorClass:Class;
		private var _methods:Array;
		private var _interfaceMethods:Array;
		private var _onlyProxyConstructor:Boolean = false;
		private var _proxiedClass:Class;
		private var _proxyAccessorNamespaces:Array;
		private var _proxyAccessorScopes:ProxyScope;
		private var _proxyMethodNamespaces:Array;
		private var _proxyMethodScopes:ProxyScope;

		/**
		 * @inheritDoc
		 */
		public function get accessors():Array {
			return _accessors;
		}

		/**
		 * @inheritDoc
		 */
		public function get interceptorFactory():IMethodInvocationInterceptorFactory {
			return _interceptorFactory;
		}

		/**
		 * @private
		 */
		public function set interceptorFactory(value:IMethodInvocationInterceptorFactory):void {
			_interceptorFactory = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get introducedInterfaces():Array {
			return _introducedInterfaces;
		}

		/**
		 * @inheritDoc
		 */
		public function get introductions():Array {
			return _introductions;
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
		 * @inheritDoc
		 */
		public function get methodInvocationInterceptorClass():Class {
			return _methodInvocationInterceptorClass;
		}

		/**
		 * @inheritDoc
		 */
		public function get methods():Array {
			return _methods;
		}

		/**
		 * @inheritDoc
		 */
		public function get proxiedClass():Class {
			return _proxiedClass;
		}

		/**
		 * @inheritDoc
		 */
		public function get proxyAccessorNamespaces():Array {
			return _proxyAccessorNamespaces;
		}

		/**
		 * @private
		 */
		public function set proxyAccessorNamespaces(value:Array):void {
			_proxyAccessorNamespaces = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get proxyAccessorScopes():ProxyScope {
			return _proxyAccessorScopes;
		}

		/**
		 * @private
		 */
		public function set proxyAccessorScopes(value:ProxyScope):void {
			if (value == null) {
				throw new IllegalOperationError("proxyAccessorScopes value cannot be null");
			}
			_proxyAccessorScopes = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get proxyMethodNamespaces():Array {
			return _proxyMethodNamespaces;
		}

		/**
		 * @private
		 */
		public function set proxyMethodNamespaces(value:Array):void {
			_proxyMethodNamespaces = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get proxyMethodScopes():ProxyScope {
			return _proxyMethodScopes;
		}

		/**
		 * @private
		 */
		public function set proxyMethodScopes(value:ProxyScope):void {
			if (value == null) {
				throw new IllegalOperationError("proxyMethodScopes value cannot be null");
			}
			_proxyMethodScopes = value;
		}

		/**
		 * @inheritDoc
		 */
		public function introduce(clazz:Class):void {
			_introductions[_introductions.length] = ClassUtils.getFullyQualifiedName(clazz, true);
		}

		/**
		 * @inheritDoc
		 */
		public function introduceInterface(interfaze:Class):void {
			if (_introducedInterfaces.indexOf(interfaze) < 0) {
				_introducedInterfaces[_introducedInterfaces.length] = interfaze;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function proxyAccessor(accessorName:String, namespace:String=null):void {
			_accessors[_accessors.length] = new MemberInfo(accessorName, namespace);
		}

		/**
		 * @inheritDoc
		 */
		public function proxyMethod(methodName:String, namespace:String=null):void {
			_methods[_methods.length] = new MemberInfo(methodName, namespace);
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
			_interfaceMethods = [];
			_accessors = [];
			_interfaceAccessors = [];
			_introductions = [];
			_introducedInterfaces = [];
			_proxyAccessorScopes = ProxyScope.ALL;
			_proxyMethodScopes = ProxyScope.ALL;
		}

		public function proxyInterfaceAccessor(accessorName:String):void {
			_interfaceAccessors[_interfaceAccessors.length] = accessorName;
		}

		public function proxyInterfaceMethod(methodName:String):void {
			_interfaceMethods[_interfaceMethods.length] = methodName;
		}
	}
}
