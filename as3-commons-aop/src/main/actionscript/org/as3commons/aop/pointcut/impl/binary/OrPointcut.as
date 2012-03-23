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
package org.as3commons.aop.pointcut.impl.binary {
	import org.as3commons.aop.pointcut.IPointcut;

	/**
	 * Binary OR pointcut.
	 *
	 * @author Christophe Herreman
	 */
	public class OrPointcut extends AbstractBinaryPointcut {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function OrPointcut(left:IPointcut, right:IPointcut) {
			super(left, right);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function matches(criterion:* = null):Boolean {
			return (left.matches(criterion) || right.matches(criterion));
		}
	}
}
