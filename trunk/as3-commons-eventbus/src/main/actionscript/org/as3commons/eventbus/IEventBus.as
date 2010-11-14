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
	 * @author Roland Zwaga
	 */
	public interface IEventBus {
		/**
		 * Adds the given listener object as a listener to all events send via the event bus.
		 */
		function addListener(listener:IEventBusListener, useWeakReference:Boolean = false):void;
		/**
		 * Removes the given listener from the event bus.
		 * @param listener
		 */
		function removeListener(listener:IEventBusListener):void;

		/**
		 * Adds the given listener function as an event handler to the given event type.
		 * @param type the type of event to listen to
		 * @param listener the event handler function
		 */
		function addEventListener(type:String, listener:Function, useWeakReference:Boolean = false):void;
		/**
		 * Removes the given listener function as an event handler from the given event type.
		 * @param type
		 * @param listener
		 */
		function removeEventListener(type:String, listener:Function):void;

		/**
		 * Adds a proxied event handler as a listener to the specified event type.
		 * @param type the type of event to listen to
		 * @param proxy a proxy method invoker for the event handler
		 */
		function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean = false):void;
		/**
		 * Removes a proxied event handler as a listener from the specified event type.
		 */
		function removeEventListenerProxy(type:String, proxy:MethodInvoker):void;

		/**
		 * Adds a listener function for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean = false):void;
		/**
		 * Removes a listener function for events of a specific Class.
		 * @param eventClass The specified <code>Class</code>.
		 * @param listener The specified listener function.
		 */
		function removeEventClassListener(eventClass:Class, listener:Function):void;

		/**
		 * Adds a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean = false):void;
		/**
		 * Removes a proxied event handler as a listener for events of a specific <code>Class</code>.
		 * @param eventClass The specified <code>Class</code>.
		 * @param proxy The specified listener function.
		 */
		function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker):void;

		/**
		 * Removes all types of listeners.
		 */
		function removeAllListeners():void;

		function addInterceptor(interceptor:IEventInterceptor):void;

		function removeInterceptor(interceptor:IEventInterceptor):void;

		function addEventInterceptor(type:String, interceptor:IEventInterceptor):void;

		function removeEventInterceptor(type:String, interceptor:IEventInterceptor):void;

		function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor):void;

		function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor):void;

		function removeAllInterceptors():void;

		function clear():void;

		/**
		 * Dispatches the specified <code>Event</code> on the event bus.
		 * @param event The specified <code>Event</code>.
		 */
		function dispatchEvent(event:Event):void;
		/**
		 * Convenience method for dispatching an event. This will create an <code>Event</code> instance with the given
		 * type and call <code>dispatchEvent()</code> on the event bus.
		 * @param type the type of the event to dispatch
		 */
		function dispatch(type:String):void;
	}
}