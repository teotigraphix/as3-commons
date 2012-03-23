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
package org.as3commons.aop.pointcut.impl.name {
	import org.as3commons.aop.pointcut.IPointcut;
	import org.as3commons.reflect.Constructor;

	/**
	 * Name matcher pointcut used for constructor names.
	 *
	 * @author Christophe Herreman
	 */
	public class ConstructorNameMatchPointcut extends AbstractNameMatchPointcut implements IPointcut {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ConstructorNameMatchPointcut(nameOrNames:*) {
			super(nameOrNames);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function matches(criterion:* = null):Boolean {
			if (criterion is Constructor) {
				return nameMatcher.match(Constructor(criterion).declaringType.name);
			}
			return false;
		}
	}
}
