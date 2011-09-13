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
package org.as3commons.aop.pointcut.impl.name {
	import org.as3commons.aop.pointcut.impl.*;
	import org.as3commons.aop.pointcut.IMethodPointcut;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Method;

	/**
	 * Name matcher pointcut used for method names.
	 *
	 * @author Christophe Herreman
	 */
	public class MethodNameMatchPointcut extends AbstractNameMatchPointcut implements IMethodPointcut {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MethodNameMatchPointcut(nameOrNames:*) {
			super(nameOrNames);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function matchesMethod(method:Method):Boolean {
			Assert.notNull(method);
			return nameMatcher.match(method.name);
		}
	}
}
