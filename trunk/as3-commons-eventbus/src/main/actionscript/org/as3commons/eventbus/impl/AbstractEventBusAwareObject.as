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
package org.as3commons.eventbus.impl {
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AbstractEventBusAwareObject implements IEventBusAware {

		private var _eventBus:IEventBus;

		/**
		 * Creates a new <code>AbstractEventBusAwareObject</code> instance.
		 *
		 */
		public function AbstractEventBusAwareObject() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get eventBus():IEventBus {
			return _eventBus;
		}

		/**
		 * @private
		 */
		public function set eventBus(value:IEventBus):void {
			_eventBus = value;
		}
	}
}