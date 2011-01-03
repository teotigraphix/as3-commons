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
			assertEquals(0, _eventBus.getNumListeners());
			_eventBus.addListener(new MockEventBusListener());
			assertEquals(1, _eventBus.getNumListeners());
		}

		public function testAddTopicListener():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getNumTopicListeners(topic));
			_eventBus.addListener(new MockEventBusListener(), false, topic);
			assertEquals(1, _eventBus.getNumTopicListeners(topic));
			assertEquals(0, _eventBus.getNumListeners());
		}

		public function testRemoveListener():void {
			var listener:IEventBusListener = new MockEventBusListener();
			assertEquals(0, _eventBus.getNumListeners());
			_eventBus.addListener(listener);
			assertEquals(1, _eventBus.getNumListeners());
			_eventBus.removeListener(listener);
			assertEquals(0, _eventBus.getNumListeners());
		}

		public function testRemoveTopicListener():void {
			var topic:String = "testTopic";
			var listener:IEventBusListener = new MockEventBusListener();
			assertEquals(0, _eventBus.getNumListeners());
			assertEquals(0, _eventBus.getNumTopicListeners(topic));
			_eventBus.addListener(listener, false, topic);
			assertEquals(1, _eventBus.getNumTopicListeners(topic));
			_eventBus.removeListener(listener, topic);
			assertEquals(0, _eventBus.getNumTopicListeners(topic));
		}

		public function testAddEventListener():void {
			assertEquals(0, _eventBus.getNumEventListeners());
			_eventBus.addEventListener("testType", new Function());
			assertEquals(1, _eventBus.getNumEventListeners());
			_eventBus.addEventListener("testType", new Function());
			assertEquals(2, _eventBus.getNumEventListeners());
		}

		public function testAddTopicEventListener():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getNumTopicEventListeners(topic));
			_eventBus.addEventListener("testType", new Function(), false, topic);
			assertEquals(1, _eventBus.getNumTopicEventListeners(topic));
			_eventBus.addEventListener("testType", new Function(), false, topic);
			assertEquals(2, _eventBus.getNumTopicEventListeners(topic));
			topic = "testTopic2";
			_eventBus.addEventListener("testType", new Function(), false, topic);
			assertEquals(1, _eventBus.getNumTopicEventListeners(topic));
		}

		public function testRemoveEventListener():void {
			var f:Function = new Function();
			assertEquals(0, _eventBus.getNumEventListeners());
			_eventBus.addEventListener("testType", f);
			assertEquals(1, _eventBus.getNumEventListeners());
			_eventBus.removeEventListener("testType", f);
			assertEquals(0, _eventBus.getNumEventListeners());
		}

		public function testRemoveTopicEventListener():void {
			var topic:String = "testTopic";
			var f:Function = new Function();
			assertEquals(0, _eventBus.getNumTopicEventListeners(topic));
			_eventBus.addEventListener("testType", f, false, topic);
			assertEquals(1, _eventBus.getNumTopicEventListeners(topic));
			_eventBus.removeEventListener("testType", f, topic);
			assertEquals(0, _eventBus.getNumTopicEventListeners(topic));
		}

		public function testAddEventListenerProxy():void {
			assertEquals(0, _eventBus.getNumEventListenerProxies());
			_eventBus.addEventListenerProxy("testType", new MethodInvoker());
			assertEquals(1, _eventBus.getNumEventListenerProxies());
		}

		public function testAddTopicEventListenerProxy():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getNumTopicEventListenerProxies(topic));
			_eventBus.addEventListenerProxy("testType", new MethodInvoker(), false, topic);
			assertEquals(1, _eventBus.getNumTopicEventListenerProxies(topic));
			_eventBus.addEventListenerProxy("testType", new MethodInvoker(), false, topic);
			assertEquals(2, _eventBus.getNumTopicEventListenerProxies(topic));
		}

		public function testAddClassEventListenerProxy():void {
			assertEquals(0, _eventBus.getNumClassProxyListeners());
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker());
			assertEquals(1, _eventBus.getNumClassProxyListeners());
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker());
			assertEquals(2, _eventBus.getNumClassProxyListeners());
		}

		public function testAddTopicClassEventListenerProxy():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getNumTopicClassProxyListeners(topic));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker(), false, topic);
			assertEquals(1, _eventBus.getNumTopicClassProxyListeners(topic));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker(), false, topic);
			assertEquals(2, _eventBus.getNumTopicClassProxyListeners(topic));
		}

		public function testRemoveTopicClassEventListenerProxy():void {
			var topic:String = "testTopic";
			var mi:MethodInvoker = new MethodInvoker();
			assertEquals(0, _eventBus.getNumTopicClassProxyListeners(topic));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, mi, false, topic);
			assertEquals(1, _eventBus.getNumTopicClassProxyListeners(topic));
			_eventBus.removeEventClassListenerProxy(MockCustomEvent, mi, topic);
			assertEquals(0, _eventBus.getNumTopicClassProxyListeners(topic));
		}

		public function testAddClassEventListener():void {
			assertEquals(0, _eventBus.getNumClassListeners());
			_eventBus.addEventClassListener(MockCustomEvent, new Function());
			assertEquals(1, _eventBus.getNumClassListeners());
			_eventBus.addEventClassListener(MockCustomEvent, new Function());
			assertEquals(2, _eventBus.getNumClassListeners());
		}

		public function testAddTopicClassEventListener():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getNumTopicClassListeners(topic));
			_eventBus.addEventClassListener(MockCustomEvent, new Function(), false, topic);
			assertEquals(1, _eventBus.getNumTopicClassListeners(topic));
			_eventBus.addEventClassListener(MockCustomEvent, new Function(), false, topic);
			assertEquals(2, _eventBus.getNumTopicClassListeners(topic));
		}

		public function testRemoveClassEventListener():void {
			var f:Function = new Function();
			assertEquals(0, _eventBus.getNumClassListeners());
			_eventBus.addEventClassListener(MockCustomEvent, f);
			assertEquals(1, _eventBus.getNumClassListeners());
			_eventBus.removeEventClassListener(MockCustomEvent, f);
			assertEquals(0, _eventBus.getNumClassListeners());
		}

		public function testRemoveTopicClassEventListener():void {
			var topic:String = "testTopic";
			var f:Function = new Function();
			assertEquals(0, _eventBus.getNumTopicClassListeners(topic));
			_eventBus.addEventClassListener(MockCustomEvent, f, false, topic);
			assertEquals(1, _eventBus.getNumTopicClassListeners(topic));
			_eventBus.removeEventClassListener(MockCustomEvent, f, topic);
			assertEquals(0, _eventBus.getNumTopicClassListeners(topic));
		}

		public function testRemoveEventListenerProxy():void {
			var m:MethodInvoker = new MethodInvoker();
			assertEquals(0, _eventBus.getNumEventListenerProxies());
			_eventBus.addEventListenerProxy("testType", m);
			assertEquals(1, _eventBus.getNumEventListenerProxies());
			_eventBus.removeEventListenerProxy("testType", m);
			assertEquals(0, _eventBus.getNumEventListenerProxies());
			_eventBus.removeEventListenerProxy("testType", m);
			assertEquals(0, _eventBus.getNumEventListenerProxies());
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
			assertEquals(1, _eventBus.getNumClassListeners());
			assertEquals(1, _eventBus.getNumClassProxyListeners());
			assertEquals(1, _eventBus.getNumEventListeners());
			assertEquals(1, _eventBus.getNumEventListenerProxies());
			assertEquals(1, _eventBus.getNumListeners());
			_eventBus.removeAllListeners();
			assertEquals(0, _eventBus.getNumClassListeners());
			assertEquals(0, _eventBus.getNumClassProxyListeners());
			assertEquals(0, _eventBus.getNumEventListeners());
			assertEquals(0, _eventBus.getNumEventListenerProxies());
			assertEquals(0, _eventBus.getNumListeners());
		}

		public function testAddEventClassInterceptor():void {
			assertEquals(0, _eventBus.getNumEventClassInterceptors());
			_eventBus.addEventClassInterceptor(MockCustomEvent, new MockInterceptor(true));
			assertEquals(1, _eventBus.getNumEventClassInterceptors());
		}

		public function testAddEventInterceptor():void {
			assertEquals(0, _eventBus.getNumEventInterceptors());
			_eventBus.addEventInterceptor("testType", new MockInterceptor(true));
			assertEquals(1, _eventBus.getNumEventInterceptors());
		}

		public function testAddInterceptor():void {
			assertEquals(0, _eventBus.getNumInterceptors());
			_eventBus.addInterceptor(new MockInterceptor(true));
			assertEquals(1, _eventBus.getNumInterceptors());
		}

		public function testRemoveEventClassInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.getNumEventClassInterceptors());
			_eventBus.addEventClassInterceptor(MockCustomEvent, ic);
			assertEquals(1, _eventBus.getNumEventClassInterceptors());
			_eventBus.removeEventClassInterceptor(MockCustomEvent, ic);
			assertEquals(0, _eventBus.getNumEventClassInterceptors());
		}

		public function testRemoveEventInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.getNumEventInterceptors());
			_eventBus.addEventInterceptor("testType", ic);
			assertEquals(1, _eventBus.getNumEventInterceptors());
			_eventBus.removeEventInterceptor("testType", ic);
			assertEquals(0, _eventBus.getNumEventInterceptors());
		}

		public function testRemoveInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.getNumInterceptors());
			_eventBus.addInterceptor(ic);
			assertEquals(1, _eventBus.getNumInterceptors());
			_eventBus.removeInterceptor(ic);
			assertEquals(0, _eventBus.getNumInterceptors());
		}

		public function testGlobalIntercept():void {
			_eventBus.addEventListener("testType", eventBusTestListener);
			_eventBus.addInterceptor(new MockInterceptor(true));
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType");
			assertFalse(_eventReceived);
		}

		public function testGlobalInterceptWithTopic():void {
			var topic:String = "testTopic";
			_eventBus.addEventListener("testType", eventBusTestListener, false, topic);
			_eventBus.addInterceptor(new MockInterceptor(true), topic);
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType", topic);
			assertFalse(_eventReceived);
		}

		public function testGlobalInterceptWithEventTopic():void {
			var topic:String = "testTopic";
			_eventBus.addEventListener("testType", eventBusTestListener, false, topic);
			_eventBus.addInterceptor(new MockInterceptor(true));
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType", topic);
			assertTrue(_eventReceived);
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