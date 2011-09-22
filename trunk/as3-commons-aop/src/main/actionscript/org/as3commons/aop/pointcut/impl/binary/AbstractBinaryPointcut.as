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
package org.as3commons.aop.pointcut.impl.binary {
	import org.as3commons.aop.pointcut.IBinaryPointcut;
	import org.as3commons.aop.pointcut.IPointcut;
	import org.as3commons.lang.Assert;

	/**
	 * Abstract base class for binary pointcuts.
	 *
	 * @author Christophe Herreman
	 */
	public class AbstractBinaryPointcut implements IBinaryPointcut {

		private var _left:IPointcut;
		private var _right:IPointcut;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractBinaryPointcut(left:IPointcut, right:IPointcut) {
			Assert.notNull(left);
			Assert.notNull(right);
			_left = left;
			_right = right;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get left():IPointcut {
			return _left;
		}

		public function get right():IPointcut {
			return _right;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function matches(criterion:* = null):Boolean {
			throw new Error("The 'matches' method is abstract and should be overridden by a subclass.");
		}
	}
}
