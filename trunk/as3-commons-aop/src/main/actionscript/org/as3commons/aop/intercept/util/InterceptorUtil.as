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
package org.as3commons.aop.intercept.util {
	import org.as3commons.aop.intercept.IInterceptor;

	/**
	 * Utilities for working with IInterceptor objects.
	 *
	 * @author Christophe Herreman
	 */
	public class InterceptorUtil {

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		public static function getInterceptorsByType(interceptors:Vector.<IInterceptor>, type:Class):Vector.<IInterceptor> {
			var result:Vector.<IInterceptor> = new Vector.<IInterceptor>();
			for each (var interceptor:IInterceptor in interceptors) {
				if (interceptor is type) {
					result.push(interceptor);
				}
			}
			return result;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function InterceptorUtil() {
		}

	}
}
