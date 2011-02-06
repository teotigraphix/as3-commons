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
	import org.as3commons.eventbus.impl.EventBus;
	import org.as3commons.reflect.MethodInvoker;

	public final class StaticEventBus {

		private static var _eventBus:EventBus;

		public function StaticEventBus() {
			super();
			throw new IllegalOperationError("Do not instantiate the StaticEventBus, use its staic methods instead.");
		}

		protected static function get eventBus():EventBus {
			if (_eventBus == null) {
				_eventBus = new EventBus();
			}
			return _eventBus;
		}

		public static function addListener(listener:IEventBusListener, useWeakReference:Boolean = false, topic:Object = null):Boolean {
			return eventBus.addListener(listener, useWeakReference, topic);
		}

		public static function removeListener(listener:IEventBusListener, topic:Object = null):void {
			eventBus.removeListener(listener, topic);
		}

		public static function addEventListener(type:String, listener:Function, useWeakReference:Boolean = false, topic:Object = null):Boolean {
			return eventBus.addEventListener(type, listener, useWeakReference, topic);
		}

		public static function removeEventListener(type:String, listener:Function, topic:Object = null):void {
			eventBus.removeEventListener(type, listener, topic);
		}

		public static function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean = false, topic:Object = null):Boolean {
			return eventBus.addEventListenerProxy(type, proxy, useWeakReference, topic);
		}

		public static function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object = null):void {
			return eventBus.removeEventListenerProxy(type, proxy, topic);
		}

		public static function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean = false, topic:Object = null):Boolean {
			return eventBus.addEventClassListener(eventClass, listener, useWeakReference, topic);
		}

		public static function removeEventClassListener(eventClass:Class, listener:Function, topic:Object = null):void {
			eventBus.removeEventClassListener(eventClass, listener, topic);
		}

		public static function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean = false, topic:Object = null):Boolean {
			return eventBus.addEventClassListenerProxy(eventClass, proxy, useWeakReference, topic);
		}

		public static function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object = null):void {
			eventBus.removeEventClassListenerProxy(eventClass, proxy, topic);
		}

		public static function removeAllListeners(topic:Object = null):void {
			eventBus.removeAllListeners(topic);
		}

		public static function addInterceptor(interceptor:IEventInterceptor, topic:Object = null):void {
			eventBus.addInterceptor(interceptor, topic);
		}

		public static function removeInterceptor(interceptor:IEventInterceptor, topic:Object = null):void {
			eventBus.removeInterceptor(interceptor, topic);
		}

		public static function addEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object = null):void {
			eventBus.addEventInterceptor(type, interceptor, topic);
		}

		public static function removeEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object = null):void {
			eventBus.removeEventInterceptor(type, interceptor, topic);
		}

		public static function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object = null):void {
			eventBus.addEventClassInterceptor(eventClass, interceptor, topic);
		}

		public static function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object = null):void {
			eventBus.removeEventClassInterceptor(eventClass, interceptor, topic);
		}

		public static function removeAllInterceptors(topic:Object = null):void {
			eventBus.removeAllInterceptors(topic);
		}

		public static function addListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object = null):void {
			eventBus.addListenerInterceptor(interceptor, topic);
		}

		public static function removeListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object = null):void {
			eventBus.removeListenerInterceptor(interceptor, topic);
		}

		public static function addEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object = null):void {
			eventBus.addEventListenerInterceptor(type, interceptor, topic);
		}

		public static function removeEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object = null):void {
			eventBus.removeEventListenerInterceptor(type, interceptor, topic);
		}

		public static function addEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object = null):void {
			eventBus.addEventClassListenerInterceptor(eventClass, interceptor, topic);
		}

		public static function removeEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object = null):void {
			eventBus.removeEventClassListenerInterceptor(eventClass, interceptor, topic);
		}

		public static function clear():void {
			eventBus.clear();
		}

		public static function dispatchEvent(event:Event, topic:Object = null):Boolean {
			return eventBus.dispatchEvent(event, topic);
		}

		public static function dispatch(type:String, topic:Object = null):Boolean {
			return eventBus.dispatch(type, topic);
		}
	}
}