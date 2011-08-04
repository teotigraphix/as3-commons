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

	/**
	 * Describes an object that can examine an <code>IMethodInvocation</code> and optionally
	 * change its properties according to some kind of custom business logic.
	 * @author Roland Zwaga
	 */
	public interface IInterceptor {
		/**
		 * Method that may contain custom business logic that determines if and how to alter the
		 * values contained in the specified <code>IMethodInvocation</code> instance.
		 * @param invocation The specified <code>IMethodInvocation</code> instance.
		 */
		function intercept(invocation:IMethodInvocation):void;
	}
}