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

	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.eventbus.ISimpleEventBus;
	import org.as3commons.eventbus.impl.collection.WeakLinkedList;
	import org.as3commons.eventbus.impl.collection.WeakLinkedListIterator;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 *
	 * @author rolandzwaga
	 */
	public class SimpleEventBus implements ISimpleEventBus, IDisposable, IEventBusListener {

		private static var LOGGER:ILogger = getLogger(SimpleEventBus);

		/** The <code>Dictionary&lt;Class,Function[]&gt;</code> that holds a mapping between event classes and a list of listener functions */
		protected var classListeners:Dictionary = new Dictionary();
		/** The <code>Dictionary&lt;Class,MethodInvoker[]&gt;</code> that holds a mapping between event classes and a list of listener proxies */
		protected var classProxyListeners:Dictionary = new Dictionary();
		/** A map of event types/names with there corresponding proxied handler functions. */
		protected var eventListenerProxies:Object /* <String, BusCollectionLookup> */ = {};
		/** A map of event types/names with there corresponding handler functions. */
		protected var eventListeners:Object /* <String, BusCollectionLookup> */ = {};
		/** The IEventBusListener objects that listen to all events on the event bus. */
		protected var listeners:EventBusCollectionLookup = new EventBusCollectionLookup();
		protected var dispatchedEvents:Dictionary = new Dictionary(true);
		private var _isDisposed:Boolean;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			if (classListeners[eventClass] == null) {
				classListeners[eventClass] = new EventBusCollectionLookup();
			}
			var listeners:EventBusCollectionLookup = EventBusCollectionLookup(classListeners[eventClass]);
			var result:Boolean = internalAddListener(listeners, listener, useWeakReference, topic, eventClass);
			LOGGER.debug("Added eventbus classlistener {0} for class {1} and topic {2}", [listener, eventClass, topic]);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			var proxies:EventBusCollectionLookup = classProxyListeners[eventClass] ||= new EventBusCollectionLookup();
			var result:Boolean = internalAddListener(proxies, proxy, useWeakReference, topic, eventClass);
			LOGGER.debug("Added eventbus classlistener proxy {0} for class {1}", [proxy, eventClass]);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			if (eventListeners[type] == null) {
				eventListeners[type] = new EventBusCollectionLookup();
			}
			var listeners:EventBusCollectionLookup = EventBusCollectionLookup(eventListeners[type]);
			var result:Boolean = internalAddListener(listeners, listener, useWeakReference, topic, type);
			LOGGER.debug("Added IEventBusListener listener {0} for type {1} and topic {2}", [listener, type, topic]);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			var proxies:EventBusCollectionLookup = eventListenerProxies[type] ||= new EventBusCollectionLookup();
			var result:Boolean = internalAddListener(proxies, proxy, useWeakReference, topic, type);
			LOGGER.debug("Added eventbus listenerproxy {0} for type {1}", [proxy, type]);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function addListener(listener:IEventBusListener, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			if (listener === this) {
				return false;
			}
			var result:Boolean = internalAddListener(listeners, listener, useWeakReference, topic, null);
			LOGGER.debug("Added IEventBusListener {0} for topic {1}", [listener, topic]);
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function clear():void {
			removeAllListeners();
		}

		/**
		 * @inheritDoc
		 */
		public function dispatch(type:String, topic:Object=null):Boolean {
			LOGGER.debug("Dispatching event with type {0} for topic {1}", [type, topic]);
			return dispatchEvent(new Event(type), topic);
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event, topic:Object=null):Boolean {
			if (!event) {
				return false;
			}
			LOGGER.debug("Dispatching event {0} for topic {1}", [event, topic]);
			dispatchedEvents[event] = true;
			var eventClass:Class = Object(event).constructor as Class;
			notifyEventBusListeners(event, topic);

			notifySpecificEventListeners(event, topic);
			notifySpecificEventListenerProxies(event, topic);

			notifySpecificClassListeners(eventClass, event, topic);
			notifySpecificClassListenerProxies(eventClass, event, topic);
			return true;
		}

		public function dispose():void {
			if (!_isDisposed) {
				eventListenerProxies = null;
				for (var item:* in eventListeners) {
					EventBusCollectionLookup(eventListeners[item]).dispose();
				}
				eventListeners = null;
				listeners.dispose();
				listeners = null;
				_isDisposed = true;
				LOGGER.debug("Disposed simple eventbus instance {0}", [this]);
			}
		}

		public function getClassListenerCount(clazz:Class, topic:Object=null):uint {
			if (classListeners[clazz] != null) {
				return EventBusCollectionLookup(classListeners[clazz]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getClassProxyListenerCount(clazz:Class, topic:Object=null):uint {
			if (classProxyListeners[clazz] != null) {
				return EventBusCollectionLookup(classProxyListeners[clazz]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getEventListenerCount(eventType:String, topic:Object=null):uint {
			if (eventListeners[eventType] != null) {
				return EventBusCollectionLookup(eventListeners[eventType]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getEventListenerProxyCount(eventType:String, topic:Object=null):uint {
			if (eventListenerProxies[eventType] != null) {
				return EventBusCollectionLookup(eventListenerProxies[eventType]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getListenerCount(topic:Object=null):uint {
			return listeners.getCollectionCount(topic);
		}

		/**
		 * @inheritDoc
		 */
		public function onEvent(event:Event):void {
			if (dispatchedEvents[event] != true) {
				LOGGER.debug("Received event {0}, redispatching it", [event]);
				dispatchEvent(event);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllListeners(topic:Object=null):void {
			classListeners = new Dictionary();
			classProxyListeners = new Dictionary();
			listeners = new EventBusCollectionLookup();
			eventListeners = {};
			eventListenerProxies = {};
			LOGGER.debug("All eventbus listeners were removed");
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListener(eventClass:Class, listener:Function, topic:Object=null):void {
			if (classListeners[eventClass] != null) {
				var listeners:EventBusCollectionLookup = EventBusCollectionLookup(classListeners[eventClass]);
				listeners.remove(listener, topic);
				LOGGER.debug("Removed eventbus classlistener {0} for class {1} and topic {2}", [listener, eventClass, topic]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object=null):void {
			if (classProxyListeners[eventClass] != null) {
				var proxies:EventBusCollectionLookup = EventBusCollectionLookup(classProxyListeners[eventClass]);
				proxies.remove(proxy, topic);
				LOGGER.debug("Removed eventbus classlistener proxy {0} for class {1}", [proxy, eventClass]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, topic:Object=null):void {
			if (eventListeners[type] != null) {
				var eventListenerCollection:EventBusCollectionLookup = EventBusCollectionLookup(eventListeners[type]);
				eventListenerCollection.remove(listener, topic);
				LOGGER.debug("Removed eventbus listener {0} for type {1} and topic {2}", [listener, type, topic]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object=null):void {
			if (eventListenerProxies[type] != null) {
				var proxies:EventBusCollectionLookup = EventBusCollectionLookup(eventListenerProxies[type]);
				proxies.remove(proxy, topic);
				LOGGER.debug("Removed eventbus listenerproxy {0} for type {1}", [proxy, type]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener(listener:IEventBusListener, topic:Object=null):void {
			listeners.remove(listener, topic);
			LOGGER.debug("Removed IEventBusListener {0} for topic {1}", [listener, topic]);
		}

		/**
		 *
		 * @param collection
		 * @param listener
		 * @param useWeakReference
		 * @param topic
		 * @param key
		 * @return
		 */
		protected function internalAddListener(collection:EventBusCollectionLookup, listener:Object, useWeakReference:Boolean, topic:Object, key:Object):Boolean {
			collection.add(listener, useWeakReference, topic);
			return true;
		}

		/**
		 * @inheritDoc
		 */
		protected function notifyEventBusListeners(event:Event, topic:Object=null):void {
			// notify all event bus listeners
			var lst:WeakLinkedList = listeners.getCollection(topic);
			if (lst != null) {
				var iterator:WeakLinkedListIterator = WeakLinkedListIterator(lst.iterator());
				while (iterator.hasNext()) {
					iterator.next();
					if (iterator.current == null) {
						iterator.remove();
					} else {
						var listener:IEventBusListener = IEventBusListener(iterator.current);
						listener.onEvent(event);
						LOGGER.debug("Notified eventbus listener " + listener + " of event " + event + " for topic " + topic);
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function notifySpecificClassListenerProxies(eventClass:Class, event:Event, topic:Object):void {
			// notify proxies for a specific event Class
			if (classProxyListeners[eventClass] != null) {
				var proxies:WeakLinkedList = EventBusCollectionLookup(classProxyListeners[eventClass]).getCollection(topic);
				if (proxies != null) {
					var iterator:WeakLinkedListIterator = WeakLinkedListIterator(proxies.iterator());
					while (iterator.hasNext()) {
						iterator.next();
						if (iterator.current == null) {
							iterator.remove();
						} else {
							var proxy:MethodInvoker = MethodInvoker(iterator.current);
							proxy.arguments = [event];
							proxy.invoke();
							LOGGER.debug("Notified class listenerproxy " + proxy + " of event " + event);
						}
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function notifySpecificClassListeners(eventClass:Class, event:Event, topic:Object):void {
			// notify listeners for a specific event Class
			if (classListeners[eventClass] != null) {
				var funcs:WeakLinkedList = EventBusCollectionLookup(classListeners[eventClass]).getCollection(topic);
				if (funcs != null) {
					var iterator:WeakLinkedListIterator = WeakLinkedListIterator(funcs.iterator());
					while (iterator.hasNext()) {
						iterator.next();
						if (iterator.current == null) {
							iterator.remove();
						} else {
							var func:Function = iterator.current as Function;
							func.apply(null, [event]);
							LOGGER.debug("Notified class listener " + func + " of event " + event);
						}
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function notifySpecificEventListenerProxies(event:Event, topic:Object):void {
			// notify all proxies
			if (eventListenerProxies[event.type] != null) {
				var proxies:WeakLinkedList = EventBusCollectionLookup(eventListenerProxies[event.type]).getCollection(topic);
				if (proxies != null) {
					var iterator:WeakLinkedListIterator = WeakLinkedListIterator(proxies.iterator());
					while (iterator.hasNext()) {
						iterator.next();
						if (iterator.current == null) {
							iterator.remove();
						} else {
							var proxy:MethodInvoker = MethodInvoker(iterator.current);
							proxy.arguments = [event];
							proxy.invoke();
							LOGGER.debug("Notified proxy " + proxy + " of event " + event);
						}
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function notifySpecificEventListeners(event:Event, topic:Object=null):void {
			// notify all specific event listeners
			if (eventListeners[event.type] != null) {
				var listeners:WeakLinkedList = EventBusCollectionLookup(eventListeners[event.type]).getCollection(topic);
				if (listeners != null) {
					var iterator:WeakLinkedListIterator = WeakLinkedListIterator(listeners.iterator());
					while (iterator.hasNext()) {
						iterator.next();
						if (iterator.current == null) {
							iterator.remove();
						} else {
							var eventListener:Function = iterator.current as Function;
							eventListener.apply(null, [event]);
							LOGGER.debug("Notified listener " + eventListener + " of event " + event);
						}
					}
				}
			}
		}
	/**
	 * Creates a new <code>SimpleEventBus2</code> instance.
	 */
	}
}
