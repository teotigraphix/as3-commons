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
	import flash.utils.Dictionary;

	import org.as3commons.eventbus.IEventBus;

	/**
	 * Limits a specific listener or lister proxy to the specified dispatch count. After the event has been dispatched the specified
	 * amount of times, the listener will be removed from the <code>IEventBus</code>.
	 * @author Roland Zwaga
	 */
	public class EventListenerLimiter extends AbstractEventPostProcessor {

		private var _maxDispatchCount:int = 0;
		private var _currentDispatchCounts:Dictionary = new Dictionary(true);
		private var _topic:Object;
		private var _listener:*;
		private var _isClassListener:Boolean;

		/**
		 * Creates a new <code>EventListenerLimiter</code> instance.
		 */
		public function EventListenerLimiter() {
			super();
		}

		override public function set eventBus(value:IEventBus):void {
			super.eventBus = value;
			if (_currentDispatchCounts[value] == null) {
				_currentDispatchCounts[value] = 0;
			}
		}

		public function get isClassListener():Boolean {
			return _isClassListener;
		}

		public function set isClassListener(value:Boolean):void {
			_isClassListener = value;
		}

		public function get listener():* {
			return _listener;
		}

		public function set listener(value:*):void {
			_listener = value;
		}

		public function get maxDispatchCount():int {
			return _maxDispatchCount;
		}

		public function set maxDispatchCount(value:int):void {
			_maxDispatchCount = value;
		}

		override public function postProcess(event:Event, wasIntercepted:Boolean, topic:Object=null):void {
			if (_listener == null) {
				return;
			}
			var currentDispatchCount:int = _currentDispatchCounts[eventBus];
			if (++currentDispatchCount > _maxDispatchCount) {
				if (_listener is Function) {
					if (_isClassListener) {
						eventBus.removeEventClassListener(Object(event).constructor as Class, _listener, topic);
					} else {
						eventBus.removeEventListener(event.type, _listener, topic);
					}
				} else {
					if (_isClassListener) {
						eventBus.removeEventClassListenerProxy(Object(event).constructor as Class, _listener, topic);
					} else {
						eventBus.removeEventListenerProxy(event.type, _listener, topic);
					}
				}
				currentDispatchCount = 0;
			}
			_currentDispatchCounts[eventBus] = currentDispatchCount;
		}

	}
}
