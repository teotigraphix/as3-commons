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
package org.as3commons.aop.advice.util {
	import org.as3commons.aop.advice.IAdvice;

	/**
	 * Utilities for working with advice objects.
	 *
	 * @author Christophe Herreman
	 */
	public class AdviceUtil {

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		public static function getAdviceByType(adviceClass:Class, advice:Vector.<IAdvice>):Vector.<IAdvice> {
			var result:Vector.<IAdvice> = new Vector.<IAdvice>();

			for each (var a:IAdvice in advice) {
				if (a is adviceClass) {
					result.push(a);
				}
			}

			return result;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AdviceUtil() {
		}
	}
}
