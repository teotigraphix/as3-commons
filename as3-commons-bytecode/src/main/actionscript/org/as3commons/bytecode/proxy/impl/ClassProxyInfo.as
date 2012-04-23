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
	import org.as3commons.bytecode.reflect.ByteCodeType;
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
			CONFIG::debug {
				Assert.notNull(proxiedClass, "proxiedClass argument must not be null");
			}
			_proxiedClass = proxiedClass;
			_methodInvocationInterceptorClass = methodInvocationInterceptorClass;
			_methods = new Vector.<MemberInfo>();
			_interfaceMethods = new Vector.<MemberInfo>();
			_accessors = new Vector.<MemberInfo>();
			_interfaceAccessors = new Vector.<MemberInfo>();
			_introductions = new Vector.<String>();
			_implementedInterfaces = new Vector.<Class>();
			_proxyAccessorScopes = ProxyScope.ALL;
			_proxyMethodScopes = ProxyScope.ALL;
		}

		private var _accessors:Vector.<MemberInfo>;
		private var _interceptorFactory:IMethodInvocationInterceptorFactory;
		private var _interfaceAccessors:Vector.<MemberInfo>;
		private var _interfaceMethods:Vector.<MemberInfo>;
		private var _implementedInterfaces:Vector.<Class>;
		private var _introductions:Vector.<String>;
		private var _makeDynamic:Boolean = false;
		private var _methodInvocationInterceptorClass:Class;
		private var _methods:Vector.<MemberInfo>;
		private var _onlyProxyConstructor:Boolean = false;
		private var _proxiedClass:Class;
		private var _proxyAccessorNamespaces:Array;
		private var _proxyAccessorScopes:ProxyScope;
		private var _proxyMethodNamespaces:Array;
		private var _proxyMethodScopes:ProxyScope;

		/**
		 * @inheritDoc
		 */
		public function get accessors():Vector.<MemberInfo> {
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
		public function get interfaceAccessors():Vector.<MemberInfo> {
			return _interfaceAccessors;
		}

		/**
		 * @inheritDoc
		 */
		public function get interfaceMethods():Vector.<MemberInfo> {
			return _interfaceMethods;
		}

		/**
		 * @inheritDoc
		 */
		public function get implementedInterfaces():Vector.<Class> {
			return _implementedInterfaces;
		}

		/**
		 * @inheritDoc
		 */
		public function get introductions():Vector.<String> {
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
		public function get methods():Vector.<MemberInfo> {
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
		public function implementInterface(interfaze:Class):void {
			if (!ClassUtils.isInterface(interfaze)) {
				throw new IllegalOperationError("The specified class is not an interface");
			}
			if (_implementedInterfaces.indexOf(interfaze) < 0) {
				_implementedInterfaces[_implementedInterfaces.length] = interfaze;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function proxyAccessor(accessorName:String, namespace:String=null):void {
			_accessors[_accessors.length] = new MemberInfo(accessorName, namespace);
		}

		public function proxyInterfaceAccessor(accessorName:String, declaringType:ByteCodeType):void {
			_interfaceAccessors[_interfaceAccessors.length] = new MemberInfo(accessorName, null, declaringType);
		}

		public function proxyInterfaceMethod(methodName:String, declaringType:ByteCodeType):void {
			_interfaceMethods[_interfaceMethods.length] = new MemberInfo(methodName, null, declaringType);
		}

		/**
		 * @inheritDoc
		 */
		public function proxyMethod(methodName:String, namespace:String=null):void {
			_methods[_methods.length] = new MemberInfo(methodName, namespace);
		}

	}
}
