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
	 *
	 * @author Roland Zwaga
	 */
	public final class ClassProxyInfo {

		private var _proxiedClass:Class;
		private var _methodInvocationInterceptorClass:Class;
		private var _methods:Array;
		private var _accessors:Array;
		private var _properties:Array;
		private var _onlyProxyConstructor:Boolean = false;

		/**
		 * Creates a new <code>ClassProxyInfo</code> instance.
		 */
		public function ClassProxyInfo(proxiedClass:Class, methodInvocationInterceptorClass:Class = null) {
			super();
			initClassProxyInfo(proxiedClass, methodInvocationInterceptorClass);
		}

		public function get proxiedClass():Class {
			return _proxiedClass;
		}

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

		public function get proxyAll():Boolean {
			return ((_methods.length + _accessors.length + _properties.length) == 0);
		}

		public function get onlyProxyConstructor():Boolean {
			return _onlyProxyConstructor;
		}

		public function set onlyProxyConstructor(value:Boolean):void {
			_onlyProxyConstructor = value;
		}

		public function proxyMethod(methodName:String, namespace:String = null, isProtected:Boolean = false):void {
			_methods[_methods.length] = new MemberInfo(methodName, namespace, isProtected);
		}

		public function proxyAccessor(accessorName:String, namespace:String = null, isProtected:Boolean = false):void {
			_accessors[_accessors.length] = new MemberInfo(accessorName, namespace, isProtected);
		}

		public function proxyProperty(propertyName:String, namespace:String = null, isProtected:Boolean = false):void {
			_properties[_properties.length] = new MemberInfo(propertyName, namespace, isProtected);
		}

		public function get methods():Array {
			return _methods;
		}

		public function get accessors():Array {
			return _accessors;
		}

		public function get properties():Array {
			return _properties;
		}
	}
}