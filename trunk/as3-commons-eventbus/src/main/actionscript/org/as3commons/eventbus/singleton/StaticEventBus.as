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
package org.as3commons.eventbus.singleton {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.as3commons.eventbus.IEventPostProcessor;
	import org.as3commons.eventbus.impl.EventBus;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * A static version of the <code>EventBus</code>. Internally one <code>EventBus</code> is created and all of the
	 * static methods are routed to that instance's methods.
	 * @author Roland Zwaga
	 */
	public final class StaticEventBus {

		private static var _eventBus:EventBus;

		public static function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void {
			eventBusInstance.addEventClassInterceptor(eventClass, interceptor, topic);
		}

		public static function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return eventBusInstance.addEventClassListener(eventClass, listener, useWeakReference, topic);
		}

		public static function addEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			eventBusInstance.addEventClassListenerInterceptor(eventClass, interceptor, topic);
		}

		public static function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return eventBusInstance.addEventClassListenerProxy(eventClass, proxy, useWeakReference, topic);
		}

		public static function addEventClassPostProcessor(eventClass:Class, eventPostProcessor:IEventPostProcessor, topic:Object=null):void {
			return eventBusInstance.addEventClassPostProcessor(eventClass, eventPostProcessor, topic);
		}

		public static function addEventInterceptor(eventType:String, interceptor:IEventInterceptor, topic:Object=null):void {
			eventBusInstance.addEventInterceptor(eventType, interceptor, topic);
		}

		public static function addEventListener(eventType:String, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return eventBusInstance.addEventListener(eventType, listener, useWeakReference, topic);
		}

		public static function addEventListenerInterceptor(eventType:String, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			eventBusInstance.addEventListenerInterceptor(eventType, interceptor, topic);
		}

		public static function addEventListenerProxy(eventType:String, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return eventBusInstance.addEventListenerProxy(eventType, proxy, useWeakReference, topic);
		}

		public static function addEventPostProcessor(eventType:String, eventPostProcessor:IEventPostProcessor, topic:Object=null):void {
			return eventBusInstance.addEventPostProcessor(eventType, eventPostProcessor, topic);
		}

		public static function addInterceptor(interceptor:IEventInterceptor, topic:Object=null):void {
			eventBusInstance.addInterceptor(interceptor, topic);
		}

		public static function addListener(listener:IEventBusListener, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return eventBusInstance.addListener(listener, useWeakReference, topic);
		}

		public static function addListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void {
			eventBusInstance.addListenerInterceptor(interceptor, topic);
		}

		public static function addPostProcessor(eventPostProcessor:IEventPostProcessor, topic:Object=null):void {
			return eventBusInstance.addPostProcessor(eventPostProcessor, topic);
		}

		public static function clear():void {
			eventBusInstance.clear();
		}

		public static function dispatch(eventType:String, topic:Object=null):Boolean {
			return eventBusInstance.dispatch(eventType, topic);
		}

		public static function dispatchEvent(event:Event, topic:Object=null):Boolean {
			return eventBusInstance.dispatchEvent(event, topic);
		}

		public static function removeAllInterceptors(topic:Object=null):void {
			eventBusInstance.removeAllInterceptors(topic);
		}

		public static function removeAllListeners(topic:Object=null):void {
			eventBusInstance.removeAllListeners(topic);
		}

		public static function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void {
			eventBusInstance.removeEventClassInterceptor(eventClass, interceptor, topic);
		}

		public static function removeEventClassListener(eventClass:Class, listener:Function, topic:Object=null):void {
			eventBusInstance.removeEventClassListener(eventClass, listener, topic);
		}

		public static function removeEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			eventBusInstance.removeEventClassListenerInterceptor(eventClass, interceptor, topic);
		}

		public static function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object=null):void {
			eventBusInstance.removeEventClassListenerProxy(eventClass, proxy, topic);
		}

		public static function removeEventClassPostProcessor(eventClass:Class, postProcessor:IEventPostProcessor, topic:Object=null):void {
			return eventBusInstance.removeEventClassPostProcessor(eventClass, postProcessor, topic);
		}

		public static function removeEventInterceptor(eventType:String, interceptor:IEventInterceptor, topic:Object=null):void {
			eventBusInstance.removeEventInterceptor(eventType, interceptor, topic);
		}

		public static function removeEventListener(eventType:String, listener:Function, topic:Object=null):void {
			eventBusInstance.removeEventListener(eventType, listener, topic);
		}

		public static function removeEventListenerInterceptor(eventType:String, interceptor:IEventListenerInterceptor, topic:Object=null):void {
			eventBusInstance.removeEventListenerInterceptor(eventType, interceptor, topic);
		}

		public static function removeEventListenerProxy(eventType:String, proxy:MethodInvoker, topic:Object=null):void {
			return eventBusInstance.removeEventListenerProxy(eventType, proxy, topic);
		}

		public static function removeEventPostProcessor(eventType:String, postProcessor:IEventPostProcessor, topic:Object=null):void {
			return eventBusInstance.removeEventPostProcessor(eventType, postProcessor, topic);
		}

		public static function removeInterceptor(interceptor:IEventInterceptor, topic:Object=null):void {
			eventBusInstance.removeInterceptor(interceptor, topic);
		}

		public static function removeListener(listener:IEventBusListener, topic:Object=null):void {
			eventBusInstance.removeListener(listener, topic);
		}

		public static function removeListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void {
			eventBusInstance.removeListenerInterceptor(interceptor, topic);
		}

		public static function removePostProcessor(postProcessor:IEventPostProcessor, topic:Object=null):void {
			return eventBusInstance.removePostProcessor(postProcessor, topic);
		}

		public function StaticEventBus() {
			super();
			throw new IllegalOperationError("Do not instantiate the StaticEventBus, use its static methods instead.");
		}

		public static function get eventBusInstance():EventBus {
			return _eventBus ||= new EventBus();
		}

		public function getClassInterceptorCount(eventClass:Class, topic:Object=null):uint {
			return eventBusInstance.getClassInterceptorCount(eventClass, topic);
		}

		public function getClassListenerCount(eventClass:Class, topic:Object=null):uint {
			return eventBusInstance.getClassListenerCount(eventClass, topic);
		}

		public function getClassListenerInterceptorCount(eventClass:Class, topic:Object=null):uint {
			return eventBusInstance.getClassListenerInterceptorCount(eventClass, topic);
		}

		public function getClassProxyListenerCount(eventClass:Class, topic:Object=null):uint {
			return eventBusInstance.getClassProxyListenerCount(eventClass, topic);
		}

		public function getEventInterceptorCount(eventType:String, topic:Object=null):uint {
			return eventBusInstance.getEventInterceptorCount(eventType, topic);
		}

		public function getEventListenerCount(eventType:String, topic:Object=null):uint {
			return eventBusInstance.getEventListenerCount(eventType, topic);
		}

		public function getEventListenerInterceptorCount(eventType:String, topic:Object=null):uint {
			return eventBusInstance.getEventListenerInterceptorCount(eventType, topic);
		}

		public function getEventListenerProxyCount(eventType:String, topic:Object=null):uint {
			return eventBusInstance.getEventListenerProxyCount(eventType, topic);
		}

		public function getInterceptorCount(topic:Object=null):uint {
			return eventBusInstance.getInterceptorCount(topic);
		}

		public function getListenerCount(topic:Object=null):uint {
			return eventBusInstance.getListenerCount(topic);
		}

		public function getListenerInterceptorCount(topic:Object=null):uint {
			return eventBusInstance.getListenerInterceptorCount(topic);
		}

		public static function getEventClassPostProcessorCount(eventClass:Class, topic:Object=null):uint {
			return eventBusInstance.getEventClassPostProcessorCount(eventClass, topic);
		}

		public static function getEventPostProcessorCount(eventType:String, topic:Object=null):uint {
			return eventBusInstance.getEventPostProcessorCount(eventType, topic);
		}

		public static function getPostProcessorCount(topic:Object=null):uint {
			return eventBusInstance.getPostProcessorCount(topic);
		}
	}
}
