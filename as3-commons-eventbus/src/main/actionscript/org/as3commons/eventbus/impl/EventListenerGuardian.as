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

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * An <code>EventListenerGuardian<code> can ensure that one or more listeners are removed after a specified
	 * amount of dispatches have been executed.<br/>
	 * Afterwards the <code>EventListenerGuardian<code> will reject any newly added listeners.
	 * @author Roland Zwaga
	 */
	public class EventListenerGuardian implements IEventInterceptor, IEventListenerInterceptor {

		/**
		 * Creates a new <code>EventListenerGuardian</code> instance.
		 */
		public function EventListenerGuardian() {
			super();
		}

		private var _blockEvent:Boolean = false;
		private var _blockListener:Boolean = false;
		private var _currentDispatchCount:int = 0;
		private var _eventBus:IEventBus;
		private var _listeners:Array = [];
		private var _maxDispatchCount:int = 0;
		private var _guarded:Boolean = false;

		public function get blockEvent():Boolean {
			return _blockEvent;
		}

		public function set blockEvent(value:Boolean):void {
			_blockEvent = value;
		}

		public function get blockListener():Boolean {
			return _blockListener;
		}

		public function set blockListener(value:Boolean):void {
			_blockListener = value;
		}

		public function get eventBus():IEventBus {
			return _eventBus;
		}

		public function set eventBus(value:IEventBus):void {
			_eventBus = value;
		}

		public function get maxDispatchCount():int {
			return _maxDispatchCount;
		}

		public function set maxDispatchCount(value:int):void {
			_maxDispatchCount = value;
		}

		public function intercept(event:Event, topic:Object=null):void {
			if (_guarded) {
				return;
			}
			if (++_currentDispatchCount >= _maxDispatchCount) {
				for each (var info:ListenerTypeInfo in _listeners) {
					removeListener(info.listener, info.type, info.topic);
					info.listener = null;
					info.topic = null;
					info.type = null;
				}
				_listeners = null;
				_guarded = true;
			}
		}

		public function interceptListener(listener:Function, eventType:String=null, eventClass:Class=null, topic:Object=null):void {
			if (!_guarded) {
				addListener(eventType, eventClass, listener, topic);
			} else {
				blockListener = true;
			}
		}


		public function interceptListenerProxy(proxy:MethodInvoker, eventType:String=null, eventClass:Class=null, topic:Object=null):void {
			if (!_guarded) {
				addListener(eventType, eventClass, proxy, topic);
			} else {
				blockListener = true;
			}
		}

		private function addListener(eventType:String, eventClass:Class, listener:*, topic:*=null):void {
			var type:* = (eventType != null) ? eventType : eventClass;
			var info:ListenerTypeInfo = new ListenerTypeInfo(listener, type, topic);
			_listeners[_listeners.length] = info;
		}

		private function removeListener(listener:*, listeningType:*, topic:*=null):void {
			if (listener is MethodInvoker) {
				if (listeningType is String) {
					_eventBus.removeEventListenerProxy(listeningType, listener, topic);
				} else {
					_eventBus.removeEventClassListenerProxy(listeningType, listener, topic);
					_eventBus.removeEventClassInterceptor(listeningType, this, topic);
					_eventBus.removeEventClassListenerInterceptor(listeningType, this, topic);
				}
			} else {
				if (listeningType is String) {
					_eventBus.removeEventListener(listeningType, listener, topic);
				} else {
					_eventBus.removeEventClassListener(listeningType, listener, topic);
				}
			}
		}
	}

}

class ListenerTypeInfo {

	public function ListenerTypeInfo(l:*, t:*, top:*) {
		super();
		listener = l;
		type = t;
		topic = top;
	}

	public var listener:*;
	public var topic:*;
	public var type:*;
}
