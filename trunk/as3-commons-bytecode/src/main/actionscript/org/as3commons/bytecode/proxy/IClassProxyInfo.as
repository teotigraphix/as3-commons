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
package org.as3commons.bytecode.proxy {
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptorFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;

	/**
	 * Contains all the necessary information for an <code>IProxyFactory</code> to generate
	 * a proxy class.
	 * @author Roland Zwaga
	 */
	public interface IClassProxyInfo {

		/**
		 * An <code>Array</code> of <code>MemberInfo</code> instances that describe the accessors belonging to the interfaces
		 * that were implemented by the specified class.
		 */
		function get interfaceAccessors():Array;

		/**
		 * An <code>Array</code> of <code>MemberInfo</code> instances that describe the methods belonging to the interfaces
		 * that were implemented by the specified class.
		 */
		function get interfaceMethods():Array;

		/**
		 * An <code>Array</code> of <code>MemberInfo</code> instances that describe the accessors
		 * that will be proxied for the specified class.
		 */
		function get accessors():Array;

		/**
		 * An <code>IMethodInvocationInterceptorFactory</code> instance capable of creating an <code>IMethodInvocationInterceptor</code>
		 * that will be injected into the created proxy instance.
		 */
		function get interceptorFactory():IMethodInvocationInterceptorFactory;

		/**
		 * @private
		 */
		function set interceptorFactory(value:IMethodInvocationInterceptorFactory):void;

		/**
		 * An <code>Array</code> of interfaces that need to be dynamically added to the proxy.
		 */
		function get implementedInterfaces():Vector.<Class>;

		/**
		 * An <code>Array</code> of <code>Classes</code> that will be merged with the generated proxy.
		 */
		function get introductions():Array;

		/**
		 * Determines if the generated proxy class will be marked as <code>dynamic</code>.
		 */
		function get makeDynamic():Boolean;

		/**
		 * @private
		 */
		function set makeDynamic(value:Boolean):void;

		/**
		 * Optionally an <code>IMethodInvocationInterceptor</code> implementing <code>Class</code> which will be
		 * instantiated and injected into the proxy instance when the <code>interceptorFactory</code> property is null
		 * and no interceptor has been injected using the <code>ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR</code> event.
		 */
		function get methodInvocationInterceptorClass():Class;

		/**
		 * An <code>Array</code> of <code>MemberInfo</code> instances that describe the methods
		 * that will be proxied for the specified class.
		 */
		function get methods():Array;

		/**
		 * The <code>Class</code> for which a dynamic proxy class will be generated.
		 */
		function get proxiedClass():Class;

		/**
		 * An <code>Array</code> of namespaces for accessors that need to be proxied.<br/>
		 * i.e. <code>["http://www.mydomain.com/mynamespace", "http://www.mydomain.com/myothernamespace"]</code>.
		 */
		function get proxyAccessorNamespaces():Array;

		/**
		 * @private
		 */
		function set proxyAccessorNamespaces(value:Array):void;

		/**
		 * Determines the scope of all the accessors that will be automatically proxied.
		 */
		function get proxyAccessorScopes():ProxyScope;

		/**
		 * @private
		 */
		function set proxyAccessorScopes(value:ProxyScope):void;

		/**
		 * An <code>Array</code> of namespaces for methods that need to be proxied.<br/>
		 * i.e. <code>["http://www.mydomain.com/mynamespace", "http://www.mydomain.com/myothernamespace"]</code>.
		 */
		function get proxyMethodNamespaces():Array;

		/**
		 * @private
		 */
		function set proxyMethodNamespaces(value:Array):void;

		/**
		 * Determines the scope of all the methods that will be automatically proxied.
		 */
		function get proxyMethodScopes():ProxyScope;

		/**
		 * @private
		 */
		function set proxyMethodScopes(value:ProxyScope):void;

		/**
		 * The specified <code>Class</code> will be merged with the generated proxy.
		 * @param clazz The specified <code>Class</code>.
		 */
		function introduce(clazz:Class):void;

		/**
		 * Adds the specified interface to the proxy, this automatically adds all the interface's members to
		 * the proxy instance.
		 * @param interfaze The specified interface.
		 */
		function implementInterface(interfaze:Class):void;

		/**
		 * Marks the specified accessor and optional namespace for proxying.
		 * @param accessorName The specified accessor name.
		 * @param namespace Optionally the custom namespace of the specified accessor.
		 */
		function proxyAccessor(accessorName:String, namespace:String=null):void;

		/**
		 *
		 * @param accessorName
		 */
		function proxyInterfaceAccessor(accessorName:String, declaringType:ByteCodeType):void;

		/**
		 *
		 * @param methodName
		 */
		function proxyInterfaceMethod(methodName:String, declaringType:ByteCodeType):void;

		/**
		 * Marks the specified method and optional namespace for proxying.
		 * @param methodName The specified method name.
		 * @param namespace Optionally the custom namespace of the specified method.
		 */
		function proxyMethod(methodName:String, namespace:String=null):void;
	}
}
