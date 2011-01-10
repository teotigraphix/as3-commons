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
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * The <code>EventBus</code> is used as a publish/subscribe event mechanism that lets objects communicate
	 * with eachother in a loosely coupled way.
	 *
	 * <p>Objects interested in receiving events can either implement the <code>IEventBusListener</code> interface
	 * and add themselves as listeners for all events on the event bus via the <code>EventBus.addListener()</code> method,
	 * if they are only interested in some events, they can add a specific event handler via the
	 * <code>EventBus.addEventListener()</code> method. The last option is too subscribe to events of a specific Class, use the</p>
	 * <code>EventBus.addEventClassListener()</code> for this purpose.
	 * <p>To dispatch an event, invoke the <code>EventBus.dispatchEvent()</code> or <code>EventBus.dispatch()</code> method.</p>
	 *
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 */
	public class EventBus implements IEventBus, IEventBusListener {

		private static var LOGGER:ILogger = LoggerFactory.getClassLogger(EventBus);

		// --------------------------------------------------------------------
		//
		// Protected Variables
		//
		// --------------------------------------------------------------------

		// --------------------------------------------------------------------
		//
		// listener collections and lookups
		//
		// --------------------------------------------------------------------

		/** The <code>Dictionary&lt;Class,Function[]&gt;</code> that holds a mapping between event classes and a list of listener functions */
		protected var classListeners:Dictionary = new Dictionary();
		/** */
		protected var topicClassListeners:Dictionary = new Dictionary();
		/** */
		protected var weakTopicClassListeners:Dictionary = new Dictionary(true);
		/** The <code>Dictionary&lt;Class,MethodInvoker[]&gt;</code> that holds a mapping between event classes and a list of listener proxies */
		protected var classProxyListeners:Dictionary = new Dictionary();
		/** */
		protected var topicClassProxyListeners:Dictionary = new Dictionary();
		/** */
		protected var weakTopicClassProxyListeners:Dictionary = new Dictionary(true);
		/** The IEventBusListener objects that listen to all events on the event bus. */
		protected var listeners:ListenerCollection = new ListenerCollection();
		/** A map of topic/eventlistener collection. */
		protected var topicListeners:Dictionary = new Dictionary();
		/** A weak map of topic/eventlistener collection. */
		protected var weakTopicListeners:Dictionary = new Dictionary(true);
		/** A map of event types/names with there corresponding handler functions. */
		protected var eventListeners:Object /* <String, ListenerCollection> */ = {};
		/** A map of topic/eventTypeDictionary  */
		protected var topicEventListeners:Dictionary = new Dictionary();
		/** A weakly referenced map of topic/eventTypeDictionary  */
		protected var weakTopicEventListeners:Dictionary = new Dictionary(true);
		/** A map of event types/names with there corresponding proxied handler functions. */
		protected var eventListenerProxies:Object /* <String, ListenerCollection> */ = {};
		/** */
		protected var topicEventListenerProxies:Dictionary = new Dictionary();
		/** */
		protected var weakTopicEventListenerProxies:Dictionary = new Dictionary(true);

		// --------------------------------------------------------------------
		//
		// interceptor collections and lookups
		//
		// --------------------------------------------------------------------

		/** */
		protected var eventClassInterceptors:Dictionary = new Dictionary();
		/** */
		protected var topicEventClassInterceptors:Dictionary = new Dictionary();
		/** */
		protected var weakTopicEventClassInterceptors:Dictionary = new Dictionary(true);
		/** */
		protected var eventInterceptors:Dictionary = new Dictionary();
		/** */
		protected var topicEventInterceptors:Dictionary = new Dictionary();
		/** */
		protected var weakTopicEventInterceptors:Dictionary = new Dictionary(true);
		/** */
		protected var interceptors:Array = [];
		/** */
		protected var topicInterceptors:Dictionary = new Dictionary();
		/** */
		protected var weakTopicInterceptors:Dictionary = new Dictionary(true);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function EventBus() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function getNumClassListeners():int {
			var len:int = 0;
			for (var s:* in classListeners) {
				len += ListenerCollection(classListeners[s]).length;
			}
			return len;
		}

		public function getNumTopicClassListeners(topic:Object):int {
			var dict:Dictionary = getTopicClassEventListenerLookup(topic);
			var len:int = 0;
			for (var s:* in dict) {
				len += ListenerCollection(dict[s]).length;
			}
			return len;
		}

		public function getNumClassProxyListeners():int {
			var len:int = 0;
			for (var s:* in classProxyListeners) {
				len += ListenerCollection(classProxyListeners[s]).length;
			}
			return len;
		}

		public function getNumTopicClassProxyListeners(topic:Object):int {
			var dict:Dictionary = getTopicClassEventProxyListenerLookup(topic);
			var len:int = 0;
			for (var s:* in dict) {
				len += ListenerCollection(dict[s]).length;
			}
			return len;
		}

		public function getNumListeners():int {
			return listeners.length;
		}

		public function getNumTopicListeners(topic:Object):int {
			var list:ListenerCollection = getListenerCollection(topic);
			return (list != null) ? list.length : 0;
		}

		public function getNumEventListeners():int {
			var len:int = 0;
			for (var s:String in eventListeners) {
				len += ListenerCollection(eventListeners[s]).length;
			}
			return len;
		}

		public function getNumTopicEventListeners(topic:Object):int {
			var dict:Dictionary = getTopicEventLookup(topic);
			var len:int = 0;
			for (var s:String in dict) {
				len += ListenerCollection(dict[s]).length;
			}
			return len;
		}

		public function getNumEventListenerProxies():int {
			var len:int = 0;
			for (var s:String in eventListenerProxies) {
				len += ListenerCollection(eventListenerProxies[s]).length;
			}
			return len;
		}

		public function getNumTopicEventListenerProxies(topic:Object):int {
			var dict:Dictionary = getTopicEventListenerProxiesLookup(topic);
			var len:int = 0;
			for (var s:* in dict) {
				len += ListenerCollection(dict[s]).length;
			}
			return len;
		}

		/** */
		public function getNumEventClassInterceptors():int {
			var len:int = 0;
			for (var s:* in eventClassInterceptors) {
				len += eventClassInterceptors[s].length;
			}
			return len;
		}

		/** */
		public function getNumEventInterceptors():int {
			var len:int = 0;
			for (var s:* in eventInterceptors) {
				len += eventInterceptors[s].length;
			}
			return len;
		}

		/** */
		public function getNumInterceptors():int {
			return interceptors.length;
		}

		/** */
		public function getNumTopicInterceptors(topic:Object):int {
			var lst:Array = getTopicInterceptorList(topic);
			return (lst != null) ? lst.length : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function onEvent(event:Event):void {
			dispatchEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public function addListener(listener:IEventBusListener, useWeakReference:Boolean = false, topic:Object = null):void {
			var lst:ListenerCollection = getListenerCollection(topic);
			if (!listener || (lst.indexOf(listener) > -1)) {
				return;
			}
			lst.add(listener, useWeakReference);
			LOGGER.debug("Added IEventBusListener " + listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener(listener:IEventBusListener, topic:Object = null):void {
			var lst:ListenerCollection = getListenerCollection(topic);
			lst.remove(listener);
			LOGGER.debug("Removed IEventBusListener " + listener + " for topic " + topic);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useWeakReference:Boolean = false, topic:Object = null):void {
			var eventListeners:ListenerCollection = getEventListenersForEventType(type, topic);
			if (eventListeners.indexOf(listener) < 0) {
				eventListeners.add(listener, useWeakReference);
				LOGGER.debug("Added eventbus listener " + listener + " for type " + type);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, topic:Object = null):void {
			var eventListenerCollection:ListenerCollection = getEventListenersForEventType(type, topic);
			eventListenerCollection.remove(listener);
			if (eventListenerCollection.length == 0) {
				deleteEventListener(type, topic);
			}
			LOGGER.debug("Removed eventbus listener " + listener + " for type " + type + " and topic " + topic);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean = false, topic:Object = null):void {
			var eventListenerProxies:ListenerCollection = getEventListenerProxiesForEventType(type, topic);
			if (eventListenerProxies.indexOf(proxy) == -1) {
				eventListenerProxies.add(proxy, useWeakReference);
				LOGGER.debug("Added eventbus listenerproxy " + proxy + " for type " + type);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object = null):void {
			var eventListenerProxyCollection:ListenerCollection = getEventListenerProxiesForEventType(type, topic);
			eventListenerProxyCollection.remove(proxy);
			if (eventListenerProxyCollection.length == 0) {
				var dict:Dictionary = getTopicEventListenerProxiesLookup(topic);
				delete eventListenerProxies[type];
			}
			LOGGER.debug("Removed eventbus listenerproxy " + proxy + " for type " + type);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean = false, topic:Object = null):void {
			var listeners:ListenerCollection = getClassListenerCollection(eventClass, topic);
			if (listeners.indexOf(listener) < 0) {
				listeners.add(listener, useWeakReference);
				LOGGER.debug("Added eventbus classlistener " + listener + " for class " + eventClass);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListener(eventClass:Class, listener:Function, topic:Object = null):void {
			var listeners:ListenerCollection = getClassListenerCollection(eventClass, topic);
			if (listeners != null) {
				listeners.remove(listener);
				LOGGER.debug("Removed eventbus classlistener " + listener + " for class " + eventClass + " and topic " + topic);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean = false, topic:Object = null):void {
			var proxies:ListenerCollection = getClassProxyListenerCollection(eventClass, topic);
			if (proxies.indexOf(proxy) < 0) {
				proxies.add(proxy, useWeakReference);
				LOGGER.debug("Added eventbus classlistener proxy " + proxy + " for class " + eventClass);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object = null):void {
			var proxies:ListenerCollection = getClassProxyListenerCollection(eventClass, topic);
			if (proxies != null) {
				proxies.remove(proxy);
				LOGGER.debug("Removed eventbus classlistener proxy " + proxy + " for class " + eventClass);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllListeners(topic:Object = null):void {
			classListeners = new Dictionary();
			classProxyListeners = new Dictionary();
			listeners = new ListenerCollection();
			eventListeners = {};
			eventListenerProxies = {};
			LOGGER.debug("All eventbus listeners were removed");
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object = null):void {
			var interceptors:Array = getClassInterceptorsForEventClass(eventClass, topic);
			interceptors[interceptors.length] = interceptor;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object = null):void {
			var interceptors:Array = getInterceptorsForEventType(type, topic);
			interceptors[interceptors.length] = interceptor;
		}

		/**
		 * @inheritDoc
		 */
		public function addInterceptor(interceptor:IEventInterceptor, topic:Object = null):void {
			var lst:Array = getInterceptorList(topic);
			lst[lst.length] = interceptor;
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
		public function removeAllInterceptors(topic:Object = null):void {
			eventClassInterceptors = new Dictionary();
			eventInterceptors = new Dictionary();
			interceptors = [];
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object = null):void {
			var clsInterceptors:Array = getClassInterceptorsForEventClass(eventClass, topic);
			var idx:int = clsInterceptors.indexOf(interceptor);
			if (idx > -1) {
				clsInterceptors.splice(idx, 1);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object = null):void {
			var evtInterceptors:Array = getInterceptorsForEventType(type, topic);
			var idx:int = evtInterceptors.indexOf(interceptor);
			if (idx > -1) {
				evtInterceptors.splice(idx, 1);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeInterceptor(interceptor:IEventInterceptor, topic:Object = null):void {
			var idx:int = interceptors.indexOf(interceptor);
			if (idx > -1) {
				interceptors.splice(idx, 1);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event, topic:Object = null):void {
			if (!event) {
				return;
			}
			var eventClass:Class = Object(event).constructor as Class;
			if (invokeInterceptors(event, eventClass, topic) == false) {
				notifyEventBusListeners(event, topic);

				notifySpecificEventListeners(event, topic);
				notifySpecificEventListenerProxies(event, topic);

				notifySpecificClassListeners(eventClass, event, topic);
				notifySpecificClassListenerProxies(eventClass, event, topic);
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function invokeInterceptors(event:Event, eventClass:Class, topic:Object):Boolean {
			var interceptorList:Array = getInterceptorList(topic);
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
		 * @inheritDoc
		 */
		protected function specificEventIntercepted(event:Event, topic:Object):Boolean {
			var interceptors:Array = getInterceptorsForEventType(event.type, topic);
			return intercept(interceptors, event);
		}

		/**
		 * @inheritDoc
		 */
		protected function classIntercepted(eventClass:Class, event:Event, topic:Object):Boolean {
			var interceptors:Array = getClassInterceptorsForEventClass(eventClass, topic);
			return intercept(interceptors, event);
		}

		/**
		 * @inheritDoc
		 */
		protected function intercept(interceptors:Array, event:Event):Boolean {
			if (interceptors != null) {
				for each (var interceptor:IEventInterceptor in interceptors) {
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
		 * @inheritDoc
		 */
		protected function notifySpecificClassListenerProxies(eventClass:Class, event:Event, topic:Object):void {
			// notify proxies for a specific event Class
			var proxies:ListenerCollection = getClassProxyListenerCollection(eventClass, topic);
			if (proxies != null) {
				var len:uint = proxies.length;
				for (var i:uint = 0; i < len; i++) {
					var proxy:MethodInvoker = proxies.get(i) as MethodInvoker;
					if (proxy != null) {
						proxy.arguments = [event];
						proxy.invoke();
						LOGGER.debug("Notified class listenerproxy " + proxy + " of event " + event);
					}
				}
			}
		}


		/**
		 * @inheritDoc
		 */
		protected function notifySpecificClassListeners(eventClass:Class, event:Event, topic:Object):void {
			// notify listeners for a specific event Class
			var funcs:ListenerCollection = getClassListenerCollection(eventClass, topic);
			if (funcs != null) {
				for (var i:uint = 0; i < funcs.length; i++) {
					var func:Function = funcs.get(i) as Function;
					if (func != null) {
						func.apply(null, [event]);
						LOGGER.debug("Notified class listener " + func + " of event " + event);
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function notifySpecificEventListenerProxies(event:Event, topic:Object):void {
			// notify all proxies
			var eventListenerProxies:ListenerCollection = getEventListenerProxiesForEventType(event.type, topic);
			if (eventListenerProxies != null) {
				var len:uint = eventListenerProxies.length;
				for (var i:uint = 0; i < len; i++) {
					var proxy:MethodInvoker = eventListenerProxies.get(i) as MethodInvoker;
					if (proxy != null) {
						proxy.arguments = [event];
						proxy.invoke();
						LOGGER.debug("Notified proxy " + proxy + " of event " + event);
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function notifySpecificEventListeners(event:Event, topic:Object = null):void {
			// notify all specific event listeners
			var eventListeners:ListenerCollection = getEventListenersForEventType(event.type, topic);
			if (eventListeners != null) {
				var len:uint = eventListeners.length;
				for (var i:uint = 0; i < len; i++) {
					var eventListener:Function = eventListeners.get(i) as Function;
					if (eventListener != null) {
						eventListener.apply(null, [event]);
						LOGGER.debug("Notified listener " + eventListener + " of event " + event);
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function notifyEventBusListeners(event:Event, topic:Object = null):void {
			// notify all event bus listeners
			var lst:ListenerCollection = getListenerCollection(topic);
			var len:uint = lst.length;
			for (var i:uint = 0; i < len; i++) {
				var listener:IEventBusListener = lst.get(i) as IEventBusListener;
				if (listener != null) {
					listener.onEvent(event);
					LOGGER.debug("Notified eventbus listener " + listener + " of event " + event + " for topic " + topic);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispatch(type:String, topic:Object = null):void {
			dispatchEvent(new Event(type), topic);
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function getInterceptorList(topic:Object):Array {
			if (topic == null) {
				return interceptors;
			} else {
				return getTopicInterceptorList(topic);
			}
		}

		protected function getTopicInterceptorList(topic:Object):Array {
			if (ObjectUtils.isSimple(topic)) {
				if (topicEventInterceptors[topic] == null) {
					topicEventInterceptors[topic] = [];
				}
				return topicEventInterceptors[topic] as Array;
			} else {
				if (weakTopicEventInterceptors[topic] == null) {
					weakTopicEventInterceptors[topic] = [];
				}
				return weakTopicEventInterceptors[topic] as Array;
			}
		}

		protected function getClassInterceptorsForEventClass(clazz:Class, topic:Object):Array {
			var classInterceptors:Dictionary = getClassInterceptorLookup(clazz, topic);
			if (!classInterceptors[clazz]) {
				classInterceptors[clazz] = [];
			}
			return classInterceptors[clazz];
		}

		protected function getClassInterceptorLookup(clazz:Class, topic:Object):Dictionary {
			if (topic == null) {
				return eventClassInterceptors;
			} else {
				if (ObjectUtils.isSimple(topic)) {
					return topicEventClassInterceptors;
				} else {
					return weakTopicEventClassInterceptors;
				}
			}
		}

		protected function getInterceptorsForEventType(type:String, topic:Object):Array {
			var interceptorLookup:Dictionary = getEventInterceptorLookup(type, topic);
			if (!interceptorLookup[type]) {
				interceptorLookup[type] = [];
			}
			return interceptorLookup[type];
		}

		protected function getEventInterceptorLookup(type:String, topic:Object):Dictionary {
			if (topic == null) {
				return eventInterceptors;
			} else {
				if (ObjectUtils.isSimple(topic)) {
					if (topicEventInterceptors[type] == null) {
						topicEventInterceptors[type] = new Dictionary();
					}
					return topicEventInterceptors[type] as Dictionary;
				} else {
					if (weakTopicEventInterceptors[type] == null) {
						weakTopicEventInterceptors[type] = new Dictionary();
					}
					return weakTopicEventInterceptors[type] as Dictionary;
				}
			}
		}

		protected function getEventListenersForEventType(eventType:String, topic:Object):ListenerCollection {
			if (topic == null) {
				if (!eventListeners[eventType]) {
					eventListeners[eventType] = new ListenerCollection();
				}
				return ListenerCollection(eventListeners[eventType]);
			} else {
				var eventTypeLookup:Dictionary = getTopicEventLookup(topic);
				if (!eventTypeLookup[eventType]) {
					eventTypeLookup[eventType] = new ListenerCollection();
				}
				return ListenerCollection(eventTypeLookup[eventType]);
			}
		}

		protected function deleteEventListener(eventType:String, topic:Object):void {
			if (topic == null) {
				delete eventListeners[eventType];
			} else {
				var eventTypeLookup:Dictionary = getTopicEventLookup(topic);
				delete eventTypeLookup[eventType];
			}
		}

		protected function getTopicEventLookup(topic:Object):Dictionary {
			if (ObjectUtils.isSimple(topic)) {
				if (topicEventListeners[topic] == null) {
					topicEventListeners[topic] = new Dictionary();
				}
				return Dictionary(topicEventListeners[topic]);
			} else {
				if (weakTopicEventListeners[topic] == null) {
					weakTopicEventListeners[topic] = new Dictionary();
				}
				return Dictionary(weakTopicEventListeners[topic]);
			}
		}

		protected function getListenerCollection(topic:Object):ListenerCollection {
			if (topic == null) {
				return listeners;
			} else {
				if (ObjectUtils.isSimple(topic)) {
					if (topicListeners[topic] == null) {
						topicListeners[topic] = new ListenerCollection();
					}
					return topicListeners[topic] as ListenerCollection;
				} else {
					if (weakTopicListeners[topic] == null) {
						weakTopicListeners[topic] = new ListenerCollection();
					}
					return weakTopicListeners[topic] as ListenerCollection;
				}
			}
		}

		protected function getEventListenerProxiesForEventType(eventType:String, topic:Object):ListenerCollection {
			if (topic == null) {
				if (!eventListenerProxies[eventType]) {
					eventListenerProxies[eventType] = new ListenerCollection();
				}
				return eventListenerProxies[eventType];
			} else {
				var dict:Dictionary = getTopicEventListenerProxiesLookup(topic);
				if (dict[eventType] == null) {
					dict[eventType] = new ListenerCollection();
				}
				return ListenerCollection(dict[eventType]);
			}
		}

		protected function getClassListenerCollection(eventClass:Class, topic:Object):ListenerCollection {
			return getListenerCollectionForTopic(eventClass, topic, classListeners, topicClassListeners, weakTopicClassListeners);
		}

		protected function getClassProxyListenerCollection(eventClass:Class, topic:Object):ListenerCollection {
			return getListenerCollectionForTopic(eventClass, topic, classProxyListeners, topicClassProxyListeners, weakTopicClassProxyListeners);
		}

		protected function getListenerCollectionForTopic(eventClass:Class, topic:Object, listeners:Dictionary, topicListeners:Dictionary, weakTopicListeners:Dictionary):ListenerCollection {
			if (topic == null) {
				if (listeners[eventClass] == null) {
					listeners[eventClass] = new ListenerCollection();
				}
				return listeners[eventClass];
			} else {
				if (ObjectUtils.isSimple(topic)) {
					return getTopicCollectionForEventClass(topic, topicListeners, eventClass);
				} else {
					return getTopicCollectionForEventClass(topic, weakTopicListeners, eventClass);
				}
			}
		}

		protected function getTopicClassEventListenerLookup(topic:Object):Dictionary {
			return getLookupForTopic(topic, topicClassListeners, weakTopicClassListeners);
		}

		protected function getTopicClassEventProxyListenerLookup(topic:Object):Dictionary {
			return getLookupForTopic(topic, topicClassProxyListeners, weakTopicClassProxyListeners);
		}

		protected function getTopicEventListenerProxiesLookup(topic:Object):Dictionary {
			return getLookupForTopic(topic, topicEventListenerProxies, weakTopicEventListenerProxies);
		}

		protected function getLookupForTopic(topic:Object, dictionary:Dictionary, weakDictionary:Dictionary):Dictionary {
			if (ObjectUtils.isSimple(topic)) {
				if (dictionary[topic] == null) {
					dictionary[topic] = new Dictionary();
				}
				return dictionary[topic];
			} else {
				if (weakDictionary[topic] == null) {
					weakDictionary[topic] = new Dictionary();
				}
				return weakDictionary[topic];
			}
		}

		protected function getTopicCollectionForEventClass(topic:Object, dictionary:Dictionary, eventClass:Class):ListenerCollection {
			var collection:ListenerCollection;
			if (dictionary[topic] == null) {
				dictionary[topic] = new Dictionary();
				collection = new ListenerCollection();
				dictionary[topic][eventClass] = collection;
			} else {
				var dict:Dictionary = dictionary[topic];
				if (dict[eventClass] == null) {
					collection = new ListenerCollection()
					dict[eventClass] = collection;
				} else {
					collection = dict[eventClass];
				}
			}
			return collection;
		}

	}

}