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
package org.as3commons.eventbus.singleton {

	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.eventbus.impl.SimpleEventBus;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public final class StaticSimpleEventBus {
		private static var _simpleEventBus:SimpleEventBus;

		public function StaticSimpleEventBus() {
			super();
			throw new IllegalOperationError("Do not instantiate the StaticSimpleEventBus, use its static methods instead.");
		}

		public static function get simpleEventBusInstance():SimpleEventBus {
			return _simpleEventBus ||= new SimpleEventBus();
		}

		public static function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return simpleEventBusInstance.addEventClassListener(eventClass, listener, useWeakReference, topic);
		}

		public static function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return simpleEventBusInstance.addEventClassListenerProxy(eventClass, proxy, useWeakReference, topic);
		}

		public static function addEventListener(type:String, listener:Function, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return simpleEventBusInstance.addEventListener(type, listener, useWeakReference, topic);
		}

		public static function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return simpleEventBusInstance.addEventListenerProxy(type, proxy, useWeakReference, topic);
		}

		public static function addListener(listener:IEventBusListener, useWeakReference:Boolean=false, topic:Object=null):Boolean {
			return simpleEventBusInstance.addListener(listener, useWeakReference, topic);
		}

		public static function clear():void {
			simpleEventBusInstance.clear();
		}

		public static function dispatch(type:String, topic:Object=null):Boolean {
			return simpleEventBusInstance.dispatch(type, topic);
		}

		public static function dispatchEvent(event:Event, topic:Object=null):Boolean {
			return simpleEventBusInstance.dispatchEvent(event, topic);
		}

		public static function getClassListenerCount(clazz:Class, topic:Object=null):uint {
			return simpleEventBusInstance.getClassListenerCount(clazz, topic);
		}

		public static function getClassProxyListenerCount(clazz:Class, topic:Object=null):uint {
			return simpleEventBusInstance.getClassProxyListenerCount(clazz, topic);
		}

		public static function getEventListenerCount(eventType:String, topic:Object=null):uint {
			return simpleEventBusInstance.getEventListenerCount(eventType, topic);
		}

		public static function getEventListenerProxyCount(eventType:String, topic:Object=null):uint {
			return simpleEventBusInstance.getEventListenerProxyCount(eventType, topic);
		}

		public static function getListenerCount(topic:Object=null):uint {
			return simpleEventBusInstance.getListenerCount(topic);
		}

		public static function removeAllListeners(topic:Object=null):void {
			simpleEventBusInstance.removeAllListeners(topic);
		}

		public static function removeEventClassListener(eventClass:Class, listener:Function, topic:Object=null):void {
			simpleEventBusInstance.removeEventClassListener(eventClass, listener, topic);
		}

		public static function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object=null):void {
			simpleEventBusInstance.removeEventClassListenerProxy(eventClass, proxy, topic);
		}

		public static function removeEventListener(type:String, listener:Function, topic:Object=null):void {
			simpleEventBusInstance.removeEventListener(type, listener, topic);
		}

		public static function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object=null):void {
			simpleEventBusInstance.removeEventListenerProxy(type, proxy, topic);
		}

		public static function removeListener(listener:IEventBusListener, topic:Object=null):void {
			simpleEventBusInstance.removeListener(listener, topic);
		}
	}
}
