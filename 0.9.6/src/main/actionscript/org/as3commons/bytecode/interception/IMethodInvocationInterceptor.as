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
package org.as3commons.bytecode.interception {
	import org.as3commons.bytecode.interception.impl.InvocationKind;

	/**
	 * Describes an object that acts as a registry of <code>IInterceptor</code> instances capable
	 * of intercepting the invocation of a method and potentially change its parameters and return value.
	 * @author Roland Zwaga
	 */
	public interface IMethodInvocationInterceptor {
		/**
		 * Intercepts an invocation and potentially delegates it to any <code>IIntercepters</code> instances that have been registred with
		 * the current <code>IMethodInvocationInterceptor</code>.
		 * @param targetInstance The object instance whose method is being intercepted.
		 * @param kind The kind of invocation that is being intercepted.
		 * @param member The <code>QName</code> for the method or accessor that is being intercepted. Is <code>null</code> when a constructor is being constructed.
		 * @param arguments Optional array of arguments that have been passed to the method.
		 * @param method A reference to the method that is being intercepted, <code>null</code> when a constructor or accessor is being intercepted.
		 * @return The return value for the specified method. May be undefined for <code>void</code> methods or constructors.
		 */
		function intercept(targetInstance:Object, kind:InvocationKind, member:QName, arguments:Array = null, method:Function = null):*;
	}
}