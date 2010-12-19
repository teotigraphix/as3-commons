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

	import org.as3commons.bytecode.emit.IAbcBuilder;

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
	public interface IProxyFactory {

		/**
		 *
		 * @param proxiedClass The specified <code>Class</code> for which a dynamic runtime proxy will be generated.
		 * @param methodInvocationInterceptorClass A <code>Class</code> that is an implementation of <code>IMethodInvocationInterceptor</code>.
		 * @param applicationDomain The <code>ApplicationDomain</code> that contains the defintion of the specified <code>proxiedClass</code>.
		 * @return
		 */
		function defineProxy(proxiedClass:Class, methodInvocationInterceptorClass:Class = null, applicationDomain:ApplicationDomain = null):ClassProxyInfo;
		/**
		 *
		 *
		 */
		function createProxyClasses():IAbcBuilder;

		/**
		 * @param applicationDomain The <code>ApplicationDomain</code> that will be used to load the generated proxies into. By default <code>ApplicationDomain.currentDomain</code> is used.
		 */
		function loadProxyClasses(applicationDomain:ApplicationDomain = null):void;

		function createProxy(clazz:Class, constructorArgs:Array = null):Object;
	}
}