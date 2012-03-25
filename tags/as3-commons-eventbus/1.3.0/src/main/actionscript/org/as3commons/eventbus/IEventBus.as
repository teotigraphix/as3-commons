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
	 * Describes an object that functions as an <code>ISimpleEventbus</code> but adds extra functionality that allows events and listeners to be intercepted
	 * and modified.
	 * <p>Events can be modified or blocked using <code>IEventInterceptor</code> implementations.</p>
	 * <p>Events listeners can be blocked using <code>IEventListenerInterceptor</code> implementations.</p>
	 * <p>Events listener proxiess can be blocked or modified using <code>IEventListenerInterceptor</code> implementations.</p>
	 * @author Roland Zwaga
	 */
	public interface IEventBus extends ISimpleEventBus {

		/**
		 * Registers the specified <code>IEventInterceptor</code> to intercept events of the specified <code>Class</code>, and optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept listeners for the specified event <code>Class</code>, optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic
		 */
		function addEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventClass
		 * @param eventPostProcessor
		 */
		function addEventClassPostProcessor(eventClass:Class, eventPostProcessor:IEventPostProcessor, topic:Object=null):void;

		/**
		 * Registers the specified <code>IEventInterceptor</code> to intercept events of the specified eventType, and optionally for the specified topic.
		 * @param eventType The specified event eventType
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function addEventInterceptor(eventType:String, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept listeners for the specified event eventType, optionally for the specified topic.
		 * @param eventType The specified event eventType
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function addEventListenerInterceptor(eventType:String, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventType
		 * @param eventPostProcessor
		 */
		function addEventPostProcessor(eventType:String, eventPostProcessor:IEventPostProcessor, topic:Object=null):void;

		/**
		 * Registers the specified <code>IEventInterceptor</code> to intercept all events, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function addInterceptor(interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept all listeners, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function addListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventPostProcessor
		 */
		function addPostProcessor(eventPostProcessor:IEventPostProcessor, topic:Object=null):void;

		/**
		 *
		 * @param eventClass
		 * @param topic
		 * @return
		 */
		function getClassInterceptorCount(eventClass:Class, topic:Object=null):uint;

		/**
		 *
		 * @param eventClass
		 * @param topic
		 * @return
		 */
		function getClassListenerInterceptorCount(eventClass:Class, topic:Object=null):uint;

		/**
		 *
		 * @param eventType
		 * @param topic
		 * @return
		 */
		function getEventInterceptorCount(eventType:String, topic:Object=null):uint;

		/**
		 *
		 * @param eventType
		 * @param topic
		 * @return
		 */
		function getEventListenerInterceptorCount(eventType:String, topic:Object=null):uint;

		/**
		 *
		 * @param topic
		 * @return
		 */
		function getInterceptorCount(topic:Object=null):uint;

		/**
		 *
		 * @param topic
		 * @return
		 */
		function getListenerInterceptorCount(topic:Object=null):uint;

		/**
		 *
		 * @param topic
		 * @return
		 */
		function getPostProcessorCount(topic:Object=null):uint;

		/**
		 *
		 * @param eventType
		 * @param topic
		 * @return
		 */
		function getEventPostProcessorCount(eventType:String, topic:Object=null):uint;

		/**
		 *
		 * @param eventClass
		 * @param topic
		 * @return
		 */
		function getEventClassPostProcessorCount(eventClass:Class, topic:Object=null):uint;

		/**
		 * Removes all global, event and class specific interceptors.
		 * @param topic
		 */
		function removeAllInterceptors(topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventInterceptor</code> for events of the specified <code>Class</code>, and optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> will be registered.
		 */
		function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Registers the specified <code>IEventListenerInterceptor</code> to intercept listeners for the specified event <code>Class</code>, optionally for the specified topic.
		 * @param eventClass The specified event <code>Class</code>
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic
		 */
		function removeEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param postProcessor
		 * @param topic
		 */
		function removeEventClassPostProcessor(eventClass:Class, postProcessor:IEventPostProcessor, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventInterceptor</code> for events of the specified eventType, and optionally for the specified topic.
		 * @param eventType The specified event eventType
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> was registered.
		 */
		function removeEventInterceptor(eventType:String, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventListenerInterceptor</code> for listeners for the specified event eventType, optionally for the specified topic.
		 * @param eventType The specified event eventType
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function removeEventListenerInterceptor(eventType:String, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventType
		 * @param postProcessor
		 * @param topic
		 */
		function removeEventPostProcessor(eventType:String, postProcessor:IEventPostProcessor, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventInterceptor</code> for all events, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventInterceptor</code> was registered.
		 */
		function removeInterceptor(interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 * Removes the specified <code>IEventListenerInterceptor</code> for all listeners, optionally for the specified topic.
		 * @param interceptor The specified <code>IEventListenerInterceptor</code>
		 * @param topic an optional topic for which the specified <code>IEventListenerInterceptor</code> will be registered.
		 */
		function removeListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param postProcessor
		 * @param topic
		 */
		function removePostProcessor(postProcessor:IEventPostProcessor, topic:Object=null):void;
	}
}
