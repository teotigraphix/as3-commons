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

	import org.as3commons.async.task.IConditionProvider;
	import org.as3commons.lang.Assert;

	/**
	 * <code>IConditionProvider</code> implementation that takes a <code>Function</code> as
	 * a constructor argument and will invoke this <code>Function</code> in its <code>getResult()</code> method.
	 * <p>The signature of this <code>Function</code> should be as follows: <code>function():Boolean</code></p>
	 * @author Roland Zwaga
	 */
	public class FunctionConditionProvider implements IConditionProvider {

		private var _func:Function;

		/**
		 * Creates a new <code>FunctionConditionProvider</code> instance.
		 * @param func The specified <code>Function</code> instance. The signature of this <code>Function</code> should be as follows: <code>function():Boolean</code>
		 */
		public function FunctionConditionProvider(func:Function) {
			Assert.notNull(func, "The func argument must not be null");
			super();
			_func = func;
		}

		/**
		 * @inheritDoc
		 */
		public function getResult():Boolean {
			return _func();
		}

	}
}
