/*
 * Copyright 2007-2008 the original author or authors.
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

	import flexunit.framework.TestCase;

	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.reflect.MethodInvoker;

	public class EventBusTests extends TestCase {

		private var _eventReceived:Boolean = false;
		private var _eventBus:EventBus;

		public function EventBusTests(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_eventReceived = false;
			_eventBus = new EventBus();
		}

		public function testAddListener():void {
			assertEquals(0, _eventBus.numListeners);
			_eventBus.addListener(new MockEventBusListener());
			assertEquals(1, _eventBus.numListeners);
		}

		public function testAddTopicListener():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getNumTopicListeners(topic));
			_eventBus.addListener(new MockEventBusListener(), false, topic);
			assertEquals(1, _eventBus.getNumTopicListeners(topic));
			assertEquals(0, _eventBus.numListeners);
		}

		public function testRemoveListener():void {
			var listener:IEventBusListener = new MockEventBusListener();
			assertEquals(0, _eventBus.numListeners);
			_eventBus.addListener(listener);
			assertEquals(1, _eventBus.numListeners);
			_eventBus.removeListener(listener);
			assertEquals(0, _eventBus.numListeners);
		}

		public function testAddEventListener():void {
			assertEquals(0, _eventBus.numEventListeners);
			_eventBus.addEventListener("testType", new Function());
			assertEquals(1, _eventBus.numEventListeners);
		}

		public function testRemoveEventListener():void {
			var f:Function = new Function();
			assertEquals(0, _eventBus.numEventListeners);
			_eventBus.addEventListener("testType", f);
			assertEquals(1, _eventBus.numEventListeners);
			_eventBus.removeEventListener("testType", f);
			assertEquals(0, _eventBus.numEventListeners);
		}

		public function testAddEventListenerProxy():void {
			assertEquals(0, _eventBus.numEventListenerProxies);
			_eventBus.addEventListenerProxy("testType", new MethodInvoker());
			assertEquals(1, _eventBus.numEventListenerProxies);
		}

		public function testRemoveEventListenerProxy():void {
			var m:MethodInvoker = new MethodInvoker();
			assertEquals(0, _eventBus.numEventListenerProxies);
			_eventBus.addEventListenerProxy("testType", m);
			assertEquals(1, _eventBus.numEventListenerProxies);
			_eventBus.removeEventListenerProxy("testType", m);
			assertEquals(0, _eventBus.numEventListenerProxies);
		}

		public function testDispatchToEventBusListener():void {
			var l:MockEventBusListener = new MockEventBusListener();
			_eventBus.addListener(l);
			assertFalse(l.receivedEvent);
			_eventBus.dispatch("testType");
			assertTrue(l.receivedEvent);
		}

		public function testDispatchToListener():void {
			_eventBus.addEventListener("testType", eventBusTestListener);
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType");
			assertTrue(_eventReceived);
		}

		public function testDispatchToClassListener():void {
			_eventBus.addEventClassListener(MockCustomEvent, eventBusTestListener);
			assertFalse(_eventReceived);
			_eventBus.dispatchEvent(new MockCustomEvent());
			assertTrue(_eventReceived);
		}

		public function testDispatchToClassListenerProxy():void {
			var mi:MethodInvoker = new MethodInvoker();
			mi.method = "eventBusTestListener";
			mi.target = this;
			_eventBus.addEventClassListenerProxy(MockCustomEvent, mi);
			assertFalse(_eventReceived);
			_eventBus.dispatchEvent(new MockCustomEvent());
			assertTrue(_eventReceived);
		}

		public function testRemoveAllListeners():void {
			_eventBus.addEventClassListener(MockCustomEvent, eventBusTestListener);
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker())
			_eventBus.addEventListener("testType", new Function());
			_eventBus.addEventListenerProxy("testType", new MethodInvoker());
			_eventBus.addListener(new MockEventBusListener());
			assertEquals(1, _eventBus.numClassListeners);
			assertEquals(1, _eventBus.numClassProxyListeners);
			assertEquals(1, _eventBus.numEventListeners);
			assertEquals(1, _eventBus.numEventListenerProxies);
			assertEquals(1, _eventBus.numListeners);
			_eventBus.removeAllListeners();
			assertEquals(0, _eventBus.numClassListeners);
			assertEquals(0, _eventBus.numClassProxyListeners);
			assertEquals(0, _eventBus.numEventListeners);
			assertEquals(0, _eventBus.numEventListenerProxies);
			assertEquals(0, _eventBus.numListeners);
		}

		public function testAddEventClassInterceptor():void {
			assertEquals(0, _eventBus.numEventClassInterceptors);
			_eventBus.addEventClassInterceptor(MockCustomEvent, new MockInterceptor(true));
			assertEquals(1, _eventBus.numEventClassInterceptors);
		}

		public function testAddEventInterceptor():void {
			assertEquals(0, _eventBus.numEventInterceptors);
			_eventBus.addEventInterceptor("testType", new MockInterceptor(true));
			assertEquals(1, _eventBus.numEventInterceptors);
		}

		public function testAddInterceptor():void {
			assertEquals(0, _eventBus.numInterceptors);
			_eventBus.addInterceptor(new MockInterceptor(true));
			assertEquals(1, _eventBus.numInterceptors);
		}

		public function testRemoveEventClassInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.numEventClassInterceptors);
			_eventBus.addEventClassInterceptor(MockCustomEvent, ic);
			assertEquals(1, _eventBus.numEventClassInterceptors);
			_eventBus.removeEventClassInterceptor(MockCustomEvent, ic);
			assertEquals(0, _eventBus.numEventClassInterceptors);
		}

		public function testRemoveEventInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.numEventInterceptors);
			_eventBus.addEventInterceptor("testType", ic);
			assertEquals(1, _eventBus.numEventInterceptors);
			_eventBus.removeEventInterceptor("testType", ic);
			assertEquals(0, _eventBus.numEventInterceptors);
		}

		public function testRemoveInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.numInterceptors);
			_eventBus.addInterceptor(ic);
			assertEquals(1, _eventBus.numInterceptors);
			_eventBus.removeInterceptor(ic);
			assertEquals(0, _eventBus.numInterceptors);
		}

		public function eventBusTestListener(event:Event):void {
			_eventReceived = true;
		}

	}
}

//import flash.events.Event;
//import org.springextensions.actionscript.core.event.IEventBusListener;
import flash.events.Event;

import org.as3commons.eventbus.IEventBusListener;
import org.as3commons.eventbus.IEventInterceptor;

class MockEventBusListener implements IEventBusListener {

	public var receivedEvent:Boolean = false;

	public function MockEventBusListener() {
		super();
	}

	public function onEvent(event:Event):void {
		receivedEvent = true;
	}
}

class MockCustomEvent extends Event {
	public function MockCustomEvent() {
		super("customEvent");
	}
}

class MockInterceptor implements IEventInterceptor {

	private var _result:Boolean;

	public function MockInterceptor(result:Boolean) {
		_result = result;
	}

	public function intercept(event:Event):Boolean {
		return _result;
	}
}