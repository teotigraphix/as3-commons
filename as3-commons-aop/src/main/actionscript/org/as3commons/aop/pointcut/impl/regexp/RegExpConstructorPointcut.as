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
package org.as3commons.aop.pointcut.impl.regexp {
	import org.as3commons.aop.pointcut.IPointcut;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Constructor;

	/**
	 * Regular expression pointcut to match constructors.
	 *
	 * @author Christophe Herreman
	 */
	public class RegExpConstructorPointcut extends AbstractRegExpPointcut implements IPointcut {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function RegExpConstructorPointcut() {
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function matches(criterion:* = null):Boolean {
			if (criterion is Constructor) {
				var constructor:Constructor = Constructor(criterion);
				var className:String = ClassUtils.getFullyQualifiedName(constructor.declaringType.clazz, true);
				return match(className);
			}
			return false;
		}

	}
}
