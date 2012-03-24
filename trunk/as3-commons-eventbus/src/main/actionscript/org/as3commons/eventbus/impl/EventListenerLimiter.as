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
package org.as3commons.eventbus.impl {
	import flash.events.Event;

	import org.as3commons.eventbus.ITopicAware;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventListenerLimiter extends AbstractEventInterceptor implements ITopicAware {

		private var _maxDispatchCount:int = 0;
		private var _currentDispatchCount:int = 0;
		private var _topic:Object;

		/**
		 * Creates a new <code>EventListenerLimiter</code> instance.
		 */
		public function EventListenerLimiter() {
			super();
		}

		public function get currentDispatchCount():int {
			return _currentDispatchCount;
		}

		public function set currentDispatchCount(value:int):void {
			_currentDispatchCount = value;
		}

		public function get maxDispatchCount():int {
			return _maxDispatchCount;
		}

		public function set maxDispatchCount(value:int):void {
			_maxDispatchCount = value;
		}

		override public function intercept(event:Event, topic:Object=null):void {
			if (++_currentDispatchCount > _maxDispatchCount) {

			}
		}

		public function get topic():Object {
			return _topic;
		}

		public function set topic(value:Object):void {
			_topic = value;
		}
	}
}
