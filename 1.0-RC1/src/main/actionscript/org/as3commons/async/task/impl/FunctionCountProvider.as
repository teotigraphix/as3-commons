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
package org.as3commons.async.task.impl {
	import org.as3commons.lang.Assert;

	/**
	 * <code>ICountProvider</code> implementation that takes a <code>Function</code> as
	 * a constructor argument and will invoke this <code>Function</code> in its <code>getCount()</code> method.
	 * <p>The signature of this <code>Function</code> should be <code>Function():uint;</code></p>
	 * @author Roland Zwaga
	 */
	public class FunctionCountProvider extends CountProvider {

		private var _func:Function;

		/**
		 * Creates a new <code>FunctionCountProvider</code> instance.
		 * @param func A <code>Function</code> that returns a <code>uint</code> representing the specified count. The signature of this <code>Function</code> should be <code>Function():uint;</code>
		 */
		public function FunctionCountProvider(func:Function) {
			Assert.notNull(func, "The func argument must not be null");
			super();
			_func = func;
		}

		override public function getCount():uint {
			return _func();
		}

	}
}
