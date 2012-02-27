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
	import flash.events.Event;
	import flash.utils.Dictionary;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.as3commons.eventbus.impl.collection.WeakLinkedList;
	import org.as3commons.eventbus.impl.collection.WeakLinkedListIterator;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * The <code>EventBus</code> is used as a publish/subscribe event mechanism that lets objects communicate
	 * with eachother in a loosely coupled way.
	 *
	 * <p>Objects interested in receiving events can either implement the <code>IEventBusListener</code> interface
	 * and add themselves as listeners for all events on the event bus via the <code>EventBus.addListener()</code> method,
	 * if they are only interested in some events, they can add a specific event handler via the
	 * <code>EventBus.addEventListener()</code> method. The last option is to subscribe to events of a specific Class, use the</p>
	 * <code>EventBus.addEventClassListener()</code> for this purpose.
	 * <p>Event filtering is supported through the use of topics, all event listening, intercepting and dispatching methods optionally
	 * accept a topic object which can be used for these purposes.</p>
	 * <p>To dispatch an event, invoke the <code>EventBus.dispatchEvent()</code> or <code>EventBus.dispatch()</code> methods.</p>
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 */
	public class EventBus implements IEventBus, IEventBusListener, IDisposable {

		private static var LOGGER:ILogger = getLogger(EventBus);

		public function EventBus() {
			super();
		}

		/** The <code>Dictionary&lt;Class,Function[]&gt;</code> that holds a mapping between event classes and a list of listener functions */
		protected var classListeners:Dictionary = new Dictionary();

		/** The <code>Dictionary&lt;Class,MethodInvoker[]&gt;</code> that holds a mapping between event classes and a list of listener proxies */
		protected var classProxyListeners:Dictionary = new Dictionary();

		/** */
		protected var eventClassInterceptors:Dictionary = new Dictionary();

		/** */
		protected var eventClassListenerInterceptors:Dictionary = new Dictionary();

		/** */
		protected var eventInterceptors:Dictionary = new Dictionary();

		/** */
		protected var eventListenerInterceptors:Dictionary = new Dictionary();

		/** A map of event types/names with there corresponding proxied handler functions. */
		protected var eventListenerProxies:Object /* <String, BusCollectionLookup> */ = {};

		/** A map of event types/names with there corresponding handler functions. */
		protected var eventListeners:Object /* <String, BusCollectionLookup> */ = {};

		/** */
		protected var interceptors:EventBusCollectionLookup = new EventBusCollectionLookup();

		/** */
		protected var listenerInterceptors:EventBusCollectionLookup = new EventBusCollectionLookup();
		/** */

		/** The IEventBusListener objects that listen to all events on the event bus. */
		protected var listeners:EventBusCollectionLookup = new EventBusCollectionLookup();
		private var _dispatchedEvents:Dictionary = new Dictionary(true);
		private var _isDisposed:Boolean;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void {
			if (eventClassInterceptors[eventClass] == null) {
				eventClassInterceptors[eventClass] = new EventBusCollectionLookup();
			}
			var interceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventClassInterceptors[eventClass]);
			interceptors.add(interceptor, false, topic);
			LOGGER.debug("Added eventclass interceptor {0} for class {1} and topic {2}", [interceptor, eventClass, topic]);
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
		public function addEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			if (eventClassListenerInterceptors[eventClass] == null) {
				eventClassListenerInterceptors[eventClass] = new EventBusCollectionLookup();
			}
			var classListenerInterceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventClassListenerInterceptors[eventClass]);
			classListenerInterceptors.add(interceptor, false, topic);
			LOGGER.debug("Added eventbus classlistener interceptor {0} for class {1} and topic {2}", [interceptor, eventClass, topic]);
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
		public function addEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void {
			if (eventInterceptors[type] == null) {
				eventInterceptors[type] = new EventBusCollectionLookup();
			}
			var interceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventInterceptors[type]);
			interceptors.add(interceptor, false, topic);
			LOGGER.debug("Added event interceptor {0} for type {1} and topic {2}", [interceptor, type, topic]);
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
		public function addEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			if (eventListenerInterceptors[type] == null) {
				eventListenerInterceptors[type] = new EventBusCollectionLookup();
			}
			var evtListenerInterceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventListenerInterceptors[type]);
			evtListenerInterceptors.add(interceptor, false, topic);
			LOGGER.debug("Added IEventListenerInterceptor {0} for type {1} and topic {2}", [interceptor, type, topic]);
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
		public function addInterceptor(interceptor:IEventInterceptor, topic:Object=null):void {
			interceptors.add(interceptor, false, topic);
			LOGGER.debug("Added IEventInterceptor {0} for topic {1}", [interceptor, topic]);
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
		public function addListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void {
			listenerInterceptors.add(interceptor, false, topic);
			LOGGER.debug("Added IEventListenerInterceptor {0} for topic {1}", [interceptor, topic]);
		}

		/**
		 * @inheritDoc
		 */
		public function clear():void {
			removeAllListeners();
			removeAllInterceptors();
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
			_dispatchedEvents[event] = true;
			var eventClass:Class = Object(event).constructor as Class;
			if (invokeInterceptors(event, eventClass, topic) == false) {
				notifyEventBusListeners(event, topic);

				notifySpecificEventListeners(event, topic);
				notifySpecificEventListenerProxies(event, topic);

				notifySpecificClassListeners(eventClass, event, topic);
				notifySpecificClassListenerProxies(eventClass, event, topic);
				return true;
			}
			return false;
		}

		public function dispose():void {
			if (!_isDisposed) {
				var item:*;
				for (item in eventClassListenerInterceptors) {
					EventBusCollectionLookup(eventClassListenerInterceptors[item]).dispose();
				}
				eventClassListenerInterceptors = null;
				for (item in eventInterceptors) {
					EventBusCollectionLookup(eventInterceptors[item]).dispose();
				}
				eventInterceptors = null;
				for (item in eventListenerInterceptors) {
					EventBusCollectionLookup(eventListenerInterceptors[item]).dispose();
				}
				eventListenerInterceptors = null;
				for (item in eventListenerProxies) {
					EventBusCollectionLookup(eventListenerProxies[item]).dispose();
				}
				eventListenerProxies = null;
				for (item in eventListeners) {
					EventBusCollectionLookup(eventListeners[item]).dispose();
				}
				eventListeners = null;
				interceptors.dispose();
				interceptors = null;
				listenerInterceptors.dispose();
				listenerInterceptors = null;
				listeners.dispose();
				listeners = null;
				_isDisposed = true;
				LOGGER.debug("Disposed eventbus instance {0}", [this]);
			}
		}

		public function getClassInterceptorCount(clazz:Class, topic:Object=null):uint {
			if (eventClassInterceptors[clazz] != null) {
				return EventBusCollectionLookup(eventClassInterceptors[clazz]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getClassListenerCount(clazz:Class, topic:Object=null):uint {
			if (classListeners[clazz] != null) {
				return EventBusCollectionLookup(classListeners[clazz]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getClassListenerInterceptorCount(eventClass:Class, topic:Object=null):uint {
			if (eventClassListenerInterceptors[eventClass] != null) {
				return EventBusCollectionLookup(eventClassListenerInterceptors[eventClass]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getClassProxyListenerCount(clazz:Class, topic:Object=null):uint {
			if (classProxyListeners[clazz] != null) {
				return EventBusCollectionLookup(classProxyListeners[clazz]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getEventInterceptorCount(eventType:String, topic:Object=null):uint {
			if (eventInterceptors[eventType] != null) {
				return EventBusCollectionLookup(eventInterceptors[eventType]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getEventListenerCount(eventType:String, topic:Object=null):uint {
			if (eventListeners[eventType] != null) {
				return EventBusCollectionLookup(eventListeners[eventType]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getEventListenerInterceptorCount(eventType:String, topic:Object=null):uint {
			if (eventListenerInterceptors[eventType] != null) {
				return EventBusCollectionLookup(eventListenerInterceptors[eventType]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getEventListenerProxyCount(eventType:String, topic:Object=null):uint {
			if (eventListenerProxies[eventType] != null) {
				return EventBusCollectionLookup(eventListenerProxies[eventType]).getCollectionCount(topic);
			}
			return 0;
		}

		public function getInterceptorCount(topic:Object=null):uint {
			return interceptors.getCollectionCount(topic);
		}

		public function getListenerCount(topic:Object=null):uint {
			return listeners.getCollectionCount(topic);
		}

		public function getListenerInterceptorCount(topic:Object=null):uint {
			return listenerInterceptors.getCollectionCount(topic);
		}

		/**
		 * @inheritDoc
		 */
		public function onEvent(event:Event):void {
			if (_dispatchedEvents[event] != true) {
				LOGGER.debug("Received event {0}, redispatching it", [event]);
				dispatchEvent(event);
			}		
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllInterceptors(topic:Object=null):void {
			eventClassInterceptors = new Dictionary();
			eventInterceptors = new Dictionary();
			interceptors = new EventBusCollectionLookup();
			listenerInterceptors = new EventBusCollectionLookup();
			LOGGER.debug("All eventbus interceptors were removed");
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
		public function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void {
			if (eventClassInterceptors[eventClass] != null) {
				var clsInterceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventClassInterceptors[eventClass]);
				clsInterceptors.remove(interceptor, topic);
				LOGGER.debug("All eventbus classinterceptor {0} for class {1} and topic {2}", [interceptor, eventClass, topic]);
			}
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
		public function removeEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			if (eventClassListenerInterceptors[eventClass] == null) {
				var classListenerInterceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventClassListenerInterceptors[eventClass]);
				classListenerInterceptors.remove(interceptor, topic);
				LOGGER.debug("All eventbus classlistener interceptor {0} for class {1} and topic {2}", [interceptor, eventClass, topic]);
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
		public function removeEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void {
			if (eventInterceptors[type] != null) {
				var evtInterceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventInterceptors[type]);
				evtInterceptors.remove(interceptor, topic);
				LOGGER.debug("Removed event interceptor {0} for event type {1} and topic {2}", [interceptor, type, topic]);
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
		public function removeEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			if (eventListenerInterceptors[type] == null) {
				var evtListenerInterceptors:EventBusCollectionLookup = EventBusCollectionLookup(eventListenerInterceptors[type]);
				evtListenerInterceptors.remove(interceptor, topic);
				LOGGER.debug("Removed event listener interceptor {0} for type {1} and topic {2}", [interceptor, type, topic]);
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
		public function removeInterceptor(interceptor:IEventInterceptor, topic:Object=null):void {
			interceptors.remove(interceptor, topic);
			LOGGER.debug("Removed event interceptor {0} for topic {1}", [interceptor, topic]);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener(listener:IEventBusListener, topic:Object=null):void {
			listeners.remove(listener, topic);
			LOGGER.debug("Removed IEventBusListener {0} for topic {1}", [listener, topic]);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void {
			listenerInterceptors.remove(interceptor, topic);
			LOGGER.debug("Removed listener interceptor {0} for topic {1}", [interceptor, topic]);
		}

		/**
		 * @inheritDoc
		 */
		protected function classIntercepted(eventClass:Class, event:Event, topic:Object):Boolean {
			if (eventClassInterceptors[eventClass] != null) {
				var interceptors:WeakLinkedList = EventBusCollectionLookup(eventClassInterceptors[eventClass]).getCollection(topic);
				return intercept(interceptors, event);
			}
			return false;
		}

		protected function classListenerIntercepted(listener:Object, topic:Object, eventClass:Class):Boolean {
			if (eventClassListenerInterceptors[eventClass] != null) {
				var interceptors:WeakLinkedList = EventBusCollectionLookup(eventClassListenerInterceptors[eventClass]).getCollection(topic);
				return listenerIntercept(interceptors, listener, null, eventClass);
			} else {
				return false;
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function intercept(interceptors:WeakLinkedList, event:Event):Boolean {
			if (interceptors != null) {
				var iterator:WeakLinkedListIterator = WeakLinkedListIterator(interceptors.iterator());
				while (iterator.hasNext()) {
					iterator.next();
					var interceptor:IEventInterceptor = IEventInterceptor(iterator.current);
					interceptor.eventBus = this;
					interceptor.intercept(event);
					if (interceptor.blockEvent) {
						return true;
					}
				}
			}
			return false;
		}

		/**
		 *
		 * @param collection
		 * @param listener
		 * @param useWeakReference
		 * @param topic
		 * @param key
		 * @return
		 *
		 */
		protected function internalAddListener(collection:EventBusCollectionLookup, listener:Object, useWeakReference:Boolean, topic:Object, key:Object):Boolean {
			if (invokeListenerInterceptors(listener, topic, key) == false) {
				collection.add(listener, useWeakReference, topic);
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param event
		 * @param eventClass
		 * @param topic
		 * @return
		 */
		protected function invokeInterceptors(event:Event, eventClass:Class, topic:Object):Boolean {
			var interceptorList:WeakLinkedList = interceptors.getCollection(topic);
			if (intercept(interceptorList, event)) {
				return true;
			}
			if (specificEventIntercepted(event, topic)) {
				return true;
			}
			if (classIntercepted(eventClass, event, topic)) {
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param listener
		 * @param topic
		 * @param key
		 * @return
		 */
		protected function invokeListenerInterceptors(listener:Object, topic:Object, key:Object):Boolean {
			var interceptorList:WeakLinkedList = listenerInterceptors.getCollection(topic);
			var eventType:String = (key as String);
			var eventClass:Class = (key as Class);
			if (listenerIntercept(interceptorList, listener, eventType, eventClass)) {
				return true;
			}
			if ((eventType != null) && (specificEventListenerIntercepted(listener, topic, eventType))) {
				return true;
			}
			if ((eventClass != null) && (classListenerIntercepted(listener, topic, eventClass))) {
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param interceptors
		 * @param listener
		 * @param eventType
		 * @param eventClass
		 * @return
		 */
		protected function listenerIntercept(interceptors:WeakLinkedList, listener:Object, eventType:String, eventClass:Class):Boolean {
			if (interceptors != null) {
				var iterator:WeakLinkedListIterator = WeakLinkedListIterator(interceptors.iterator());
				while (iterator.hasNext()) {
					iterator.next();
					var interceptor:IEventListenerInterceptor = IEventListenerInterceptor(iterator.current);
					interceptor.eventBus = this;
					if (listener is Function) {
						interceptor.interceptListener((listener as Function), eventType, eventClass);
					} else {
						interceptor.interceptListenerProxy(MethodInvoker(listener), eventType, eventClass);
					}
					if (interceptor.blockListener) {
						return true;
					}
				}
			}
			return false;
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
		 * @inheritDoc
		 */
		protected function specificEventIntercepted(event:Event, topic:Object):Boolean {
			if (eventInterceptors[event.type] != null) {
				var interceptors:WeakLinkedList = EventBusCollectionLookup(eventInterceptors[event.type]).getCollection(topic);
				return intercept(interceptors, event);
			} else {
				return false;
			}
		}

		protected function specificEventListenerIntercepted(listener:Object, topic:Object, eventType:String):Boolean {
			if (eventListenerInterceptors[eventType] != null) {
				var interceptors:WeakLinkedList = EventBusCollectionLookup(eventListenerInterceptors[eventType]).getCollection(topic);
				return listenerIntercept(interceptors, listener, eventType, null);
			} else {
				return false;
			}
		}
	}

}
