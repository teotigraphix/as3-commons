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
package org.as3commons.async.task.support {

	import org.as3commons.async.task.ICountProvider;

	/**
	 * Base class for <code>ICountProvider</code> implementations.
	 * @docref the_operation_api.html#tasks
	 * @inheritDoc
	 */
	public class CountProvider implements ICountProvider {

		private var _count:int;

		/**
		 * Creates a new <code>CountProvider</code> instance.
		 * @param count The specified count.
		 */
		public function CountProvider(count:int = 0) {
			super();
			_count = count;
		}

		/**
		 * @inheritDoc
		 */
		public function getCount():uint {
			return _count;
		}

	}
}