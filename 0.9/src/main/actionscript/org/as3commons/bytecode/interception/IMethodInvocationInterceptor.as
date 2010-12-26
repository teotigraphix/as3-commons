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
package org.as3commons.bytecode.interception {

	/**
	 * Describes an object that acts as a registry of <code>IInterceptor</code> instances capable
	 * of intercepting the invocation of a method and potentially change its parameters and return value.
	 * @author Roland Zwaga
	 */
	public interface IMethodInvocationInterceptor {
		/**
		 *
		 * @param instance
		 * @param methodNamem
		 * @param method
		 * @param arguments
		 * @return
		 */
		function intercept(targetInstance:Object, kind:InvocationKind, member:QName, arguments:Array = null, method:Function = null):*;
	}
}