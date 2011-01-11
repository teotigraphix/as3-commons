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
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.emit.IAbcBuilder;

	/**
	 * Dispatched before a proxy class is created, it allows the creation of a <code>IMethodInvocationInterceptor</code> to be
	 * delegated to an event handler. The event handler needs to assign a valid <code>IMethodInvocationInterceptor</code> instance
	 * to the <code>ProxyFactoryEvent.methodInvocationInterceptor</code> property in order for it to be used for the newly created proxy.
	 * @eventType org.as3commons.bytecode.proxy.event.ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR
	 */
	[Event(name="getMethodInvocationInterceptor", "org.as3commons.bytecode.proxy.event.ProxyFactoryEvent")]
	/**
	 * Dispatched before a getter body will be built, the <code>IMethodBuilder</code> instance assigned to the <code>ProxyFactoryEvent.builder</code> property
	 * can be used to add a custom method body.
	 * @eventType org.as3commons.bytecode.proxy.event.ProxyFactoryEvent.BEFORE_GETTER_BODY_BUILD
	 */
	[Event(name="beforeGetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * Dispatched before a setter body will be built, the <code>IMethodBuilder</code> instance assigned to the <code>ProxyFactoryEvent.builder</code> property
	 * can be used to add a custom method body.
	 * @eventType org.as3commons.bytecode.proxy.event.ProxyFactoryEvent.BEFORE_SETTER_BODY_BUILD
	 */
	[Event(name="beforeSetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * Dispatched before a method body will be built, the <code>IMethodBuilder</code> instance assigned to the <code>ProxyFactoryEvent.builder</code> property
	 * can be used to add a custom method body.
	 * @eventType org.as3commons.bytecode.proxy.event.ProxyFactoryEvent.BEFORE_METHOD_BODY_BUILD
	 */
	[Event(name="beforeMethodBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * Dispatched before the constructor body will be built, the <code>ICtorBuilder</code> instance assigned to the <code>ProxyFactoryEvent.builder</code> property
	 * can be used to add a custom method body.
	 * @eventType org.as3commons.bytecode.proxy.event.ProxyFactoryEvent.BEFORE_CONSTRUCTOR_BODY_BUILD
	 */
	[Event(name="beforeConstructorBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * Dispatched after the proxy has been build, the <code>IClassBuilder</code> instance assigned to the <code>ProxyFactoryEvent.classBuilder</code> property
	 * can be further customized in the handlers for this event.
	 * @eventType org.as3commons.bytecode.proxy.event.ProxyFactoryEvent.AFTER_PROXY_BUILD
	 */
	[Event(name="afterProxyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * Dispatched when the proxy factory has finished loading the SWF/ABC bytecode in the Flash Player/AVM.
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the proxy factory has encountered an IO related error.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Dispatched when the proxy factory has encountered a SWF verification error.
	 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]
	/**
	 * Describes an object capable of creating runtime dynamic proxy classes.
	 * @author Roland Zwaga
	 */
	public interface IProxyFactory extends IEventDispatcher {

		/**
		 *
		 * @param proxiedClass The specified <code>Class</code> for which a dynamic runtime proxy will be generated.
		 * @param methodInvocationInterceptorClass A <code>Class</code> that is an implementation of <code>IMethodInvocationInterceptor</code>.
		 * @param applicationDomain The <code>ApplicationDomain</code> that contains the defintion of the specified <code>proxiedClass</code>.
		 * @return
		 */
		function defineProxy(proxiedClass:Class, methodInvocationInterceptorClass:Class = null, applicationDomain:ApplicationDomain = null):ClassProxyInfo;
		/**
		 * Generates the definitions for all proxied class.
		 * @return The <code>IAbcBuilder</code> instance that contains all the definitions for the proxies.
		 */
		function generateProxyClasses():IAbcBuilder;

		/**
		 * Loads the generated classes into the VM.
		 * @param applicationDomain The <code>ApplicationDomain</code> that will be used to load the generated proxies into. By default <code>ApplicationDomain.currentDomain</code> is used.
		 */
		function loadProxyClasses(applicationDomain:ApplicationDomain = null):void;

		/**
		 * Creates a proxy instance for the specified <code>Class</code>. This method can only be invoked after the <code>defineProxy()</code> and <code>createProxyClasses()</code> methods
		 * have been invoked.
		 * @param clazz
		 * @param constructorArgs
		 * @return
		 */
		function createProxy(clazz:Class, constructorArgs:Array = null):Object;

		/**
		 * Returns a <code>ProxyInfo</code> instance associated with the specified proxied class,
		 * or null if none can be found. This information is only available after the <code>generateProxyClasses()</code>
		 * method has been invoked.
		 * @param clazz The proxied class
		 * @return A <code>ProxyInfo</code> instance associated with the specified proxied class.
		 */
		function getProxyInfoForClass(proxiedClass:Class):ProxyInfo;
	}
}