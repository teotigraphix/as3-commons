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
package org.as3commons.eventbus {
	import flash.events.Event;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * Describes an object that is used as a publish/subscribe event mechanism that lets objects communicate
	 * with eachother in a loosely coupled manner.
	 * <p>There are three ways to add listeners to an <code>IEventBus</code>:<br/>
	 * <ol>
	 * <li>Add a listener for all events that are dispatched by an <code>IEventBus</code>.</li>
	 * <li>Add a listener for all events of a certain type that are dispatched by an <code>IEventBus</code>.</li>
	 * <li>Add a listener for all events of a <code>Class</code> that are dispatched by an <code>IEventBus</code>.</li>
	 * </ol>
	 * </p>
	 * <p>Further event filtering can be achieved by using topics, which can be registered through all the different event dispatching
	 * and listeners registration methods as an optional argument.</p>
	 * <p>Events can be modified or blocked using <code>IEventInterceptor</code> implementations.</p>
	 * <p>Events listeners can be blocked using <code>IEventListenerInterceptor</code> implementations.</p>
	 * @author Roland Zwaga
	 */
	public interface IEventBus {

		/**
		 * Registers the specified <code>IEventInterceptor</code> to intercept events of the specified <code>Class</code>, and optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Adds a listener function for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept listeners for the specified event <code>Class</code>, optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic
		 */
		function addEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 * Adds a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean;

		/**
		 * Registers the specified <code>IEventInterceptor</code> to intercept events of the specified type, and optionally for the specified topic.
		 * @param type The specified event type
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function addEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Adds the given listener function as an event handler to the given event type.
		 * @param type the type of event to listen to
		 * @param listener the event handler function
		 */
		function addEventListener(type:String, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept listeners for the specified event type, optionally for the specified topic.
		 * @param type The specified event type
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function addEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 * Adds a proxied event handler as a listener to the specified event type.
		 * @param type the type of event to listen to
		 * @param proxy a proxy method invoker for the event handler
		 */
		function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean;

		/**
		 * Registers the specified <code>IEventInterceptor</code> to intercept all events, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function addInterceptor(interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Adds the given listener object as a listener to all events sent through the event bus.
		 */
		function addListener(listener:IEventBusListener, useWeakReference:Boolean=false, topic:Object=null):Boolean;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept all listeners, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function addListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 * Removes all event listeners, interceptors and listener interceptors from the current <code>IEventBus</code> instance.
		 */
		function clear():void;

		/**
		 * Convenience method for dispatching an event. This will create an <code>Event</code> instance with the given
		 * type and call <code>dispatchEvent()</code> on the event bus.
		 * @param type the type of the event to dispatch.
		 */
		function dispatch(type:String, topic:Object=null):Boolean;

		/**
		 * Dispatches the specified <code>Event</code> on the event bus.
		 * @param event The specified <code>Event</code>.
		 */
		function dispatchEvent(event:Event, topic:Object=null):Boolean;

		/**
		 *
		 * @param clazz
		 * @param topic
		 * @return
		 */
		function getClassInterceptorCount(clazz:Class, topic:Object=null):uint;

		/**
		 * The number of registered event listeners for the specified event class, optionally also for the specified topic. Omitting the topic argument will return the number
		 * of event listeners that have been registered without a topic, so *not* the entire count.
		 * @param eventClass The specified event Class.
		 * @param topic The specified optional topic.
		 * @return The specified number of event listeners.
		 */
		function getClassListenerCount(clazz:Class, topic:Object=null):uint;

		/**
		 *
		 * @param eventClass
		 * @param topic
		 * @return
		 */
		function getClassListenerInterceptorCount(eventClass:Class, topic:Object=null):uint;

		/**
		 * The number of registered event listener proxies for the specified event class, optionally also for the specified topic. Omitting the topic argument will return the number
		 * of event listener proxies that have been registered without a topic, so *not* the entire count.
		 * @param eventClass The specified event Class.
		 * @param topic The specified optional topic.
		 * @return The specified number of event listener proxies.
		 */
		function getClassProxyListenerCount(clazz:Class, topic:Object=null):uint;

		/**
		 *
		 * @param eventType
		 * @param topic
		 * @return
		 */
		function getEventInterceptorCount(eventType:String, topic:Object=null):uint;

		/**
		 * The number of registered event listeners for the specified event type, optionally also for the specified topic. Omitting the topic argument will return the number
		 * of event listeners that have been registered without a topic, so *not* the entire count.
		 * @param eventType The specified event type.
		 * @param topic The specified optional topic.
		 * @return The specified number of event listeners.
		 */
		function getEventListenerCount(eventType:String, topic:Object=null):uint;

		/**
		 *
		 * @param eventType
		 * @param topic
		 * @return
		 */
		function getEventListenerInterceptorCount(eventType:String, topic:Object=null):uint;

		/**
		 * The number of registered event listener proxies for the specified event type, optionally also for the specified topic. Omitting the topic argument will return the number
		 * of event listener proxies that have been registered without a topic, so *not* the entire count.
		 * @param eventType The specified event type.
		 * @param topic The specified optional topic.
		 * @return The specified number of event listener proxies.
		 */
		function getEventListenerProxyCount(eventType:String, topic:Object=null):uint;

		/**
		 *
		 * @param topic
		 * @return
		 */
		function getInterceptorCount(topic:Object=null):uint;

		/**
		 * The number of registered global event listeners, optionally for the specified topic. Omitting the topic argument will return the number
		 * of global listeners that have been registered without a topic, so *not* the entire count.
		 * @param topic The specified optional topic.
		 * @return The specified number of global listeners.
		 */
		function getListenerCount(topic:Object=null):uint;

		/**
		 *
		 * @param topic
		 * @return
		 */
		function getListenerInterceptorCount(topic:Object=null):uint;

		/**
		 * Removes all global, event and class specific interceptors.
		 * @param topic
		 */
		function removeAllInterceptors(topic:Object=null):void;

		/**
		 * Removes all types of listeners.
		 */
		function removeAllListeners(topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventInterceptor</code> for events of the specified <code>Class</code>, and optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void;
		/**
		 * Removes a listener function for events of a specific Class.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		function removeEventClassListener(eventClass:Class, listener:Function, topic:Object=null):void;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept listeners for the specified event <code>Class</code>, optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic
		 */
		function removeEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void;
		/**
		 * Removes a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventInterceptor</code> for events of the specified type, and optionally for the specified topic.
		 * @param type The specified event type
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> was registered.
		 */
		function removeEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void;
		/**
		 * Removes the given listener function as an event handler from the given event type.
		 * @param type
		 * @param listener
		 */
		function removeEventListener(type:String, listener:Function, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventListenerInterceptor</code> for listeners for the specified event type, optionally for the specified topic.
		 * @param type The specified event type
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function removeEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void;
		/**
		 * Removes a proxied event handler as a listener from the specified event type.
		 */
		function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventInterceptor</code> for all events, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> was registered.
		 */
		function removeInterceptor(interceptor:IEventInterceptor, topic:Object=null):void;
		/**
		 * Removes the given listener from the event bus.
		 * @param listener
		 */
		function removeListener(listener:IEventBusListener, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventListenerInterceptor</code> for all listeners, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function removeListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void;
	}
}
