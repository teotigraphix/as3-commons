/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.aop.advice.constructor {
	import org.as3commons.aop.advice.IBeforeAdvice;
	import org.as3commons.reflect.Constructor;

	/**
	 * Constructor "before" advice is invoked before a constructor is called. This enables the interceptor
	 * to manipulate the constructor arguments.
	 *
	 * @author Christophe Herreman
	 */
	public interface IConstructorBeforeAdvice extends IConstructorAdvice, IBeforeAdvice {

		function beforeConstructor(constructor:Constructor, args:Array):void;

	}

}
