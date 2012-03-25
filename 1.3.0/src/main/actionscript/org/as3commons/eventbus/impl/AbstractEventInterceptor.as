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
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventInterceptor;

	/**
	 * Basic implementation of <code>IEventInterceptor</code> to be used as a base class.
	 * @author Roland Zwaga
	 */
	public class AbstractEventInterceptor extends AbstractEventBusAwareObject implements IEventInterceptor {

		/**
		 * Creates a new <code>AbstractEventInterceptor</code> instance.
		 */
		public function AbstractEventInterceptor() {
			super();
		}

		private var _blockEvent:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get blockEvent():Boolean {
			return _blockEvent;
		}

		/**
		 * @private
		 */
		public function set blockEvent(value:Boolean):void {
			_blockEvent = value;
		}

		/**
		 * @inheritDoc
		 */
		public function intercept(event:Event, topic:Object=null):void {
			throw new IllegalOperationError("intercept() not implemented in abstract base class");
		}
	}
}
