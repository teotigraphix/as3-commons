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
	import org.as3commons.aop.advice.constructor.IConstructorAfterAdvice;
	import org.as3commons.aop.advice.constructor.IConstructorAfterThrowingAdvice;
	import org.as3commons.aop.as3commons_aop;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Constructor;

	/**
	 * Utilities for working with advice objects.
	 *
	 * @author Christophe Herreman
	 */
	public final class AdviceUtil {

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		public static function getAdviceByType(adviceClass:Class, advice:Vector.<IAdvice>):Vector.<IAdvice> {
			Assert.notNull(adviceClass, "The advice class must not be null");
			Assert.notNull(advice, "The advice vector must not be null");

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
		// Static Helper Methods
		//
		// --------------------------------------------------------------------

		as3commons_aop static function applyConstructorThrowsAdvice(advice:Vector.<IAdvice>, constructor:Constructor, error:Error, args:Array = null):void {
			var constructorThrowsAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IConstructorAfterThrowingAdvice, advice);
			for each (var a:IConstructorAfterThrowingAdvice in constructorThrowsAdvice) {
				a.afterConstructorThrowing(constructor, args, error);
			}
		}

		as3commons_aop static function applyConstructorAfterAdvice(advice:Vector.<IAdvice>, constructor:Constructor, proxy:*, args:Array = null):void {
			var constructorAfterAdvice:Vector.<IAdvice> = AdviceUtil.getAdviceByType(IConstructorAfterAdvice, advice);
			for each (var a:IConstructorAfterAdvice in constructorAfterAdvice) {
				a.afterConstructor(constructor, args, proxy);
			}
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
