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
	public class EventBus implements IEventBus {

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

		/** A map of event types/names with there corresponding handler functions. */
		protected var eventListeners:Object /* <String, ListenerCollection> */ = {};

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
		 * Adds the given listener object as a listener to all events send via the event bus.
		 */
		public function addListener(listener:IEventBusListener, useWeakReference:Boolean = false):void {
			if (!listener || (listeners.indexOf(listener) > -1)) {
				return;
			}
			listeners.add(listener, useWeakReference);
			LOGGER.debug("Added IEventBusListener " + listener);
		}

		/**
		 * Removes the given listener from the event bus.
		 * @param listener
		 */
		public function removeListener(listener:IEventBusListener):void {
			listeners.remove(listener);
			LOGGER.debug("Removed IEventBusListener " + listener);
		}

		/**
		 * Adds the given listener function as an event handler to the given event type.
		 * @param type the type of event to listen to
		 * @param listener the event handler function
		 */
		public function addEventListener(type:String, listener:Function, useWeakReference:Boolean = false):void {
			var eventListeners:ListenerCollection = getEventListenersForEventType(type);
			if (eventListeners.indexOf(listener) == -1) {
				eventListeners.add(listener, useWeakReference);
				LOGGER.debug("Added eventbus listener " + listener + " for type " + type);
			}
		}

		/**
		 * Removes the given listener function as an event handler from the given event type.
		 * @param type
		 * @param listener
		 */
		public function removeEventListener(type:String, listener:Function):void {
			var eventListenerCollection:ListenerCollection = getEventListenersForEventType(type);
			eventListenerCollection.remove(listener);
			if (eventListenerCollection.length == 0) {
				delete this.eventListeners[type];
			}
			LOGGER.debug("Removed eventbus listener " + listener + " for type " + type);
		}

		/**
		 * Adds a proxied event handler as a listener to the specified event type.
		 * @param type the type of event to listen to
		 * @param proxy a proxy method invoker for the event handler
		 */
		public function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean = false):void {
			var eventListenerProxies:ListenerCollection = getEventListenerProxiesForEventType(type);
			if (eventListenerProxies.indexOf(proxy) == -1) {
				eventListenerProxies.add(proxy, useWeakReference);
				LOGGER.debug("Added eventbus listenerproxy " + proxy + " for type " + type);
			}
		}

		/**
		 * Removes a proxied event handler as a listener from the specified event type.
		 */
		public function removeEventListenerProxy(type:String, proxy:MethodInvoker):void {
			var eventListenerProxyCollection:ListenerCollection = getEventListenerProxiesForEventType(type);
			eventListenerProxyCollection.remove(proxy);
			if (eventListenerProxyCollection.length == 0) {
				delete eventListenerProxies[type];
			}
			LOGGER.debug("Removed eventbus listenerproxy " + proxy + " for type " + type);
		}

		/**
		 * Adds a listener function for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		public function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean = false):void {
			var listeners:ListenerCollection = (classListeners[eventClass] == null) ? new ListenerCollection() : classListeners[eventClass] as ListenerCollection;
			if (listeners.indexOf(listener) < 0) {
				listeners.add(listener, useWeakReference);
				classListeners[eventClass] = listeners;
				LOGGER.debug("Added eventbus classlistener " + listener + " for class " + eventClass);
			}
		}

		/**
		 * Removes a listener function for events of a specific Class.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		public function removeEventClassListener(eventClass:Class, listener:Function):void {
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
		 * Adds a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		public function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean = false):void {
			var proxies:ListenerCollection = (classProxyListeners[eventClass] == null) ? new ListenerCollection() : classProxyListeners[eventClass] as ListenerCollection;
			if (proxies.indexOf(proxy) < 0) {
				proxies.add(proxy, useWeakReference);
				classProxyListeners[eventClass] = proxies;
				LOGGER.debug("Added eventbus classlistener proxy " + proxy + " for class " + eventClass);
			}
		}

		/**
		 * Removes a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		public function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker):void {
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
		 * Clears the entire <code>EventBus</code> by removing all types of listeners.
		 */
		public function removeAllListeners():void {
			classListeners = new Dictionary();
			classProxyListeners = new Dictionary();
			listeners = new ListenerCollection();
			eventListeners = {};
			eventListenerProxies = {};
			LOGGER.debug("All eventbus listeners were removed");
		}

		public function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor):void {
			var interceptors:Array = getClassInterceptorsForEventClass(eventClass);
			interceptors[interceptors.length] = interceptor;
		}

		public function addEventInterceptor(type:String, interceptor:IEventInterceptor):void {
			var interceptors:Array = getInterceptorsForEventType(type);
			interceptors[interceptors.length] = interceptor;
		}

		public function addInterceptor(interceptor:IEventInterceptor):void {
			interceptors[interceptors.length] = interceptor;
		}

		public function clear():void {
			removeAllListeners();
			removeAllInterceptors();
		}

		public function removeAllInterceptors():void {
			eventClassInterceptors = new Dictionary();
			eventInterceptors = {};
			interceptors = [];
		}

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

		public function removeInterceptor(interceptor:IEventInterceptor):void {
			var idx:int = interceptors.indexOf(interceptor);
			if (idx > -1) {
				interceptors.splice(idx, 1);
			}
		}

		/**
		 * Dispatches the specified <code>Event</code> on the event bus.
		 * @param event The specified <code>Event</code>.
		 */
		public function dispatchEvent(event:Event):void {
			if (!event) {
				return;
			}

			if (interceptGlobal(event) == false) {
				notifyEventBusListeners(event);

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

		public function interceptGlobal(event:Event):Boolean {
			return intercept(interceptors, event);
		}

		public function specificEventIntercepted(event:Event):Boolean {
			var interceptors:Array = eventInterceptors[event.type];
			return intercept(interceptors, event);
		}

		public function classIntercepted(eventClass:Class, event:Event):Boolean {
			var interceptors:Array = eventClassInterceptors[eventClass];
			return intercept(interceptors, event);
		}

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

		public function notifyEventBusListeners(event:Event):void {
			// notify all event bus listeners
			var len:uint = listeners.length;
			for (var i:uint = 0; i < len; i++) {
				var listener:IEventBusListener = listeners.get(i) as IEventBusListener;
				if (listener != null) {
					listener.onEvent(event);
					LOGGER.debug("Notified eventbus listener " + listener + " of event " + event);
				}
			}
		}


		/**
		 * Convenience method for dispatching an event. This will create an Event instance with the given
		 * type and call dispatchEvent() on the event bus.
		 * @param type the type of the event to dispatch
		 */
		public function dispatch(type:String):void {
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

		protected function getEventListenersForEventType(eventType:String):ListenerCollection {
			if (!eventListeners[eventType]) {
				eventListeners[eventType] = new ListenerCollection();
			}
			return eventListeners[eventType];
		}

		protected function getEventListenerProxiesForEventType(eventType:String):ListenerCollection {
			if (!eventListenerProxies[eventType]) {
				eventListenerProxies[eventType] = new ListenerCollection();
			}
			return eventListenerProxies[eventType];
		}

	}

}