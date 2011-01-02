/*
 * Copyright 2007-2010 the original author or authors.
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

		/** The <code>Dictionary&lt;Class,Function[]&gt;</code> that holds a mapping between event classes and a list of listener functions */
		protected var classListeners:Dictionary = new Dictionary();

		/** The <code>Dictionary&lt;Class,MethodInvoker[]&gt;</code> that holds a mapping between event classes and a list of listener proxies */
		protected var classProxyListeners:Dictionary = new Dictionary();

		/** The IEventBusListener objects that listen to all events on the event bus. */
		protected var listeners:ListenerCollection = new ListenerCollection();

		/** A map of topic/eventlistener collection. */
		protected var topicListeners:Dictionary = new Dictionary();
		/** A weak map of topic/eventlistener collection. */
		protected var weakTopicListeners:Dictionary = new Dictionary(true);

		/** A map of event types/names with there corresponding handler functions. */
		protected var eventListeners:Object /* <String, ListenerCollection> */ = {};

		/** A map of topic/eventTypeDictionary  */
		protected var typedEventTopicLookup:Dictionary = new Dictionary();

		/** A weakly referenced map of topic/eventTypeDictionary  */
		protected var weakTypedEventTopicLookup:Dictionary = new Dictionary(true);

		/** A map of event types/names with there corresponding proxied handler functions. */
		protected var eventListenerProxies:Object /* <String, ListenerCollection> */ = {};

		/** */
		protected var eventClassInterceptors:Dictionary = new Dictionary();
		/** */
		protected var eventInterceptors:Object = {};
		/** */
		protected var interceptors:Array = [];

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

		public function get numClassListeners():int {
			var idx:int = 0;
			for (var s:* in classListeners) {
				idx++;
			}
			return idx;
		}

		public function get numClassProxyListeners():int {
			var idx:int = 0;
			for (var s:* in classProxyListeners) {
				idx++;
			}
			return idx;
		}

		public function get numListeners():int {
			return listeners.length;
		}

		public function getNumTopicListeners(topic:Object):int {
			var list:ListenerCollection = getListenerCollection(topic)
			return (list != null) ? list.length : 0;
		}

		public function get numEventListeners():int {
			var idx:int = 0;
			for (var s:* in eventListeners) {
				idx++;
			}
			return idx;
		}

		public function get numEventListenerProxies():int {
			var idx:int = 0;
			for (var s:* in eventListenerProxies) {
				idx++;
			}
			return idx;
		}

		/** */
		public function get numEventClassInterceptors():int {
			var idx:int = 0;
			for (var s:* in eventClassInterceptors) {
				idx++;
			}
			return idx;
		}

		/** */
		public function get numEventInterceptors():int {
			var idx:int = 0;
			for (var s:* in eventInterceptors) {
				idx++;
			}
			return idx;
		}

		/** */
		public function get numInterceptors():int {
			return interceptors.length;
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
			listeners.remove(listener);
			LOGGER.debug("Removed IEventBusListener " + listener);
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
			var eventListenerProxies:ListenerCollection = getEventListenerProxiesForEventType(type);
			if (eventListenerProxies.indexOf(proxy) == -1) {
				eventListenerProxies.add(proxy, useWeakReference);
				LOGGER.debug("Added eventbus listenerproxy " + proxy + " for type " + type);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object = null):void {
			var eventListenerProxyCollection:ListenerCollection = getEventListenerProxiesForEventType(type);
			eventListenerProxyCollection.remove(proxy);
			if (eventListenerProxyCollection.length == 0) {
				delete eventListenerProxies[type];
			}
			LOGGER.debug("Removed eventbus listenerproxy " + proxy + " for type " + type);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean = false, topic:Object = null):void {
			var listeners:ListenerCollection = (classListeners[eventClass] == null) ? new ListenerCollection() : classListeners[eventClass] as ListenerCollection;
			if (listeners.indexOf(listener) < 0) {
				listeners.add(listener, useWeakReference);
				classListeners[eventClass] = listeners;
				LOGGER.debug("Added eventbus classlistener " + listener + " for class " + eventClass);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListener(eventClass:Class, listener:Function, topic:Object = null):void {
			var listeners:ListenerCollection = classListeners[eventClass] as ListenerCollection;
			if (listeners != null) {
				listeners.remove(listener);
				if (listeners.length < 1) {
					delete classListeners[eventClass];
				}
				LOGGER.debug("Removed eventbus classlistener " + listener + " for class " + eventClass);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean = false, topic:Object = null):void {
			var proxies:ListenerCollection = (classProxyListeners[eventClass] == null) ? new ListenerCollection() : classProxyListeners[eventClass] as ListenerCollection;
			if (proxies.indexOf(proxy) < 0) {
				proxies.add(proxy, useWeakReference);
				classProxyListeners[eventClass] = proxies;
				LOGGER.debug("Added eventbus classlistener proxy " + proxy + " for class " + eventClass);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object = null):void {
			var proxies:ListenerCollection = classProxyListeners[eventClass] as ListenerCollection;
			if (proxies != null) {
				proxies.remove(proxy);
				if (proxies.length < 1) {
					delete classProxyListeners[eventClass];
				}
				LOGGER.debug("Removed eventbus classlistener proxy " + proxy + " for class " + eventClass);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllListeners():void {
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
		public function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor):void {
			var interceptors:Array = getClassInterceptorsForEventClass(eventClass);
			interceptors[interceptors.length] = interceptor;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventInterceptor(type:String, interceptor:IEventInterceptor):void {
			var interceptors:Array = getInterceptorsForEventType(type);
			interceptors[interceptors.length] = interceptor;
		}

		/**
		 * @inheritDoc
		 */
		public function addInterceptor(interceptor:IEventInterceptor):void {
			interceptors[interceptors.length] = interceptor;
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
		public function removeAllInterceptors():void {
			eventClassInterceptors = new Dictionary();
			eventInterceptors = {};
			interceptors = [];
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor):void {
			var clsInterceptors:Array = getClassInterceptorsForEventClass(eventClass);
			var idx:int = clsInterceptors.indexOf(interceptor);
			if (idx > -1) {
				clsInterceptors.splice(idx, 1);
				if (clsInterceptors.length == 0) {
					delete eventClassInterceptors[eventClass];
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventInterceptor(type:String, interceptor:IEventInterceptor):void {
			var evtInterceptors:Array = getInterceptorsForEventType(type);
			var idx:int = evtInterceptors.indexOf(interceptor);
			if (idx > -1) {
				evtInterceptors.splice(idx, 1);
				if (evtInterceptors.length == 0) {
					delete eventInterceptors[type];
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeInterceptor(interceptor:IEventInterceptor):void {
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

			if (interceptGlobal(event) == false) {
				notifyEventBusListeners(event, topic);

				if (specificEventIntercepted(event) == false) {
					notifySpecificEventListeners(event);
					notifyProxies(event);
				}

				var eventClass:Class = Object(event).constructor as Class;

				if (classIntercepted(eventClass, event) == false) {
					notifySpecificClassListeners(eventClass, event);
					notifySpecificClassListenerProxies(eventClass, event);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function interceptGlobal(event:Event):Boolean {
			return intercept(interceptors, event);
		}

		/**
		 * @inheritDoc
		 */
		public function specificEventIntercepted(event:Event):Boolean {
			var interceptors:Array = eventInterceptors[event.type];
			return intercept(interceptors, event);
		}

		/**
		 * @inheritDoc
		 */
		public function classIntercepted(eventClass:Class, event:Event):Boolean {
			var interceptors:Array = eventClassInterceptors[eventClass];
			return intercept(interceptors, event);
		}

		/**
		 * @inheritDoc
		 */
		public function intercept(interceptors:Array, event:Event):Boolean {
			if (interceptors != null) {
				for each (var interceptor:IEventInterceptor in interceptors) {
					if (interceptor.intercept(event) == true) {
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function notifySpecificClassListenerProxies(eventClass:Class, event:Event):void {
			// notify proxies for a specific event Class
			var proxies:ListenerCollection = classProxyListeners[eventClass] as ListenerCollection;
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
		public function notifySpecificClassListeners(eventClass:Class, event:Event):void {
			// notify listeners for a specific event Class
			var funcs:ListenerCollection = classListeners[eventClass];
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
		public function notifyProxies(event:Event):void {
			// notify all proxies
			var eventListenerProxies:ListenerCollection = eventListenerProxies[event.type];
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
		public function notifySpecificEventListeners(event:Event):void {
			// notify all specific event listeners
			var eventListeners:ListenerCollection = eventListeners[event.type];
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
		public function notifyEventBusListeners(event:Event, topic:Object = null):void {
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
			dispatchEvent(new Event(type));
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function getClassInterceptorsForEventClass(clazz:Class):Array {
			if (!eventClassInterceptors[clazz]) {
				eventClassInterceptors[clazz] = [];
			}
			return eventClassInterceptors[clazz];
		}

		protected function getInterceptorsForEventType(type:String):Array {
			if (!eventInterceptors[type]) {
				eventInterceptors[type] = [];
			}
			return eventInterceptors[type];
		}

		protected function getEventListenersForEventType(eventType:String, topic:Object):ListenerCollection {
			if (topic == null) {
				if (!eventListeners[eventType]) {
					eventListeners[eventType] = new ListenerCollection();
				}
				return ListenerCollection(eventListeners[eventType]);
			} else {
				var eventTypeLookup:Dictionary = getEventTopicLookup(topic);
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
				var eventTypeLookup:Dictionary = getEventTopicLookup(topic);
				delete eventTypeLookup[eventType];
			}
		}

		protected function getEventTopicLookup(topic:Object):Dictionary {
			if (ObjectUtils.isSimple(topic)) {
				if (typedEventTopicLookup[topic] == null) {
					typedEventTopicLookup[topic] = new Dictionary();
				}
				return Dictionary(typedEventTopicLookup[topic]);
			} else {
				if (weakTypedEventTopicLookup[topic] == null) {
					weakTypedEventTopicLookup[topic] = new Dictionary();
				}
				return Dictionary(weakTypedEventTopicLookup[topic]);
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

		protected function getEventListenerProxiesForEventType(eventType:String):ListenerCollection {
			if (!eventListenerProxies[eventType]) {
				eventListenerProxies[eventType] = new ListenerCollection();
			}
			return eventListenerProxies[eventType];
		}

	}

}