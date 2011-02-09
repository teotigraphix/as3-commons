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
	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.as3commons.reflect.MethodInvoker;

	public class EventBusTest extends TestCase {

		private var _eventReceived:Boolean = false;
		private var _eventBus:EventBus;

		public function EventBusTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_eventReceived = false;
			_eventBus = new EventBus();
		}

		public function testAddListener():void {
			assertEquals(0, _eventBus.getListenerCount());
			_eventBus.addListener(new MockEventBusListener());
			assertEquals(1, _eventBus.getListenerCount());
		}

		public function testAddTopicListener():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getListenerCount(topic));
			_eventBus.addListener(new MockEventBusListener(), false, topic);
			assertEquals(1, _eventBus.getListenerCount(topic));
			assertEquals(0, _eventBus.getListenerCount());
			_eventBus.addListener(new MockEventBusListener(), false);
			assertEquals(1, _eventBus.getListenerCount(topic));
			assertEquals(1, _eventBus.getListenerCount());
		}

		public function testRemoveListener():void {
			var listener:IEventBusListener = new MockEventBusListener();
			assertEquals(0, _eventBus.getListenerCount());
			_eventBus.addListener(listener);
			assertEquals(1, _eventBus.getListenerCount());
			_eventBus.removeListener(listener);
			assertEquals(0, _eventBus.getListenerCount());
		}

		public function testRemoveTopicListener():void {
			var topic:String = "testTopic";
			var listener:IEventBusListener = new MockEventBusListener();
			assertEquals(0, _eventBus.getListenerCount());
			assertEquals(0, _eventBus.getListenerCount(topic));
			_eventBus.addListener(listener, false, topic);
			assertEquals(1, _eventBus.getListenerCount(topic));
			_eventBus.removeListener(listener, topic);
			assertEquals(0, _eventBus.getListenerCount(topic));
		}

		public function testAddEventListener():void {
			assertEquals(0, _eventBus.getEventListenerCount("testType"));
			_eventBus.addEventListener("testType", new Function());
			assertEquals(1, _eventBus.getEventListenerCount("testType"));
			_eventBus.addEventListener("testType", new Function());
			assertEquals(2, _eventBus.getEventListenerCount("testType"));
		}

		public function testAddTopicEventListener():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getEventListenerCount("testType", topic));
			_eventBus.addEventListener("testType", new Function(), false, topic);
			assertEquals(1, _eventBus.getEventListenerCount("testType", topic));
			_eventBus.addEventListener("testType", new Function(), false, topic);
			assertEquals(2, _eventBus.getEventListenerCount("testType", topic));
			topic = "testTopic2";
			_eventBus.addEventListener("testType", new Function(), false, topic);
			assertEquals(1, _eventBus.getEventListenerCount("testType", topic));
		}

		public function testRemoveEventListener():void {
			var f:Function = new Function();
			assertEquals(0, _eventBus.getEventListenerCount("testType"));
			_eventBus.addEventListener("testType", f);
			assertEquals(1, _eventBus.getEventListenerCount("testType"));
			_eventBus.removeEventListener("testType", f);
			assertEquals(0, _eventBus.getEventListenerCount("testType"));
		}

		public function testRemoveTopicEventListener():void {
			var topic:String = "testTopic";
			var f:Function = new Function();
			assertEquals(0, _eventBus.getEventListenerCount("testType", topic));
			_eventBus.addEventListener("testType", f, false, topic);
			assertEquals(1, _eventBus.getEventListenerCount("testType", topic));
			_eventBus.removeEventListener("testType", f, topic);
			assertEquals(0, _eventBus.getEventListenerCount("testType", topic));
		}

		public function testAddEventListenerProxy():void {
			assertEquals(0, _eventBus.getEventListenerProxyCount("testType"));
			_eventBus.addEventListenerProxy("testType", new MethodInvoker());
			assertEquals(1, _eventBus.getEventListenerProxyCount("testType"));
		}

		public function testAddTopicEventListenerProxy():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getEventListenerProxyCount("testType", topic));
			_eventBus.addEventListenerProxy("testType", new MethodInvoker(), false, topic);
			assertEquals(1, _eventBus.getEventListenerProxyCount("testType", topic));
			_eventBus.addEventListenerProxy("testType", new MethodInvoker(), false, topic);
			assertEquals(2, _eventBus.getEventListenerProxyCount("testType", topic));
		}

		public function testAddClassEventListenerProxy():void {
			assertEquals(0, _eventBus.getClassProxyListenerCount(MockCustomEvent));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker());
			assertEquals(1, _eventBus.getClassProxyListenerCount(MockCustomEvent));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker());
			assertEquals(2, _eventBus.getClassProxyListenerCount(MockCustomEvent));
		}

		public function testAddTopicClassEventListenerProxy():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getClassProxyListenerCount(MockCustomEvent, topic));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker(), false, topic);
			assertEquals(1, _eventBus.getClassProxyListenerCount(MockCustomEvent, topic));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, new MethodInvoker(), false, topic);
			assertEquals(2, _eventBus.getClassProxyListenerCount(MockCustomEvent, topic));
		}

		public function testRemoveTopicClassEventListenerProxy():void {
			var topic:String = "testTopic";
			var mi:MethodInvoker = new MethodInvoker();
			assertEquals(0, _eventBus.getClassProxyListenerCount(MockCustomEvent, topic));
			_eventBus.addEventClassListenerProxy(MockCustomEvent, mi, false, topic);
			assertEquals(1, _eventBus.getClassProxyListenerCount(MockCustomEvent, topic));
			_eventBus.removeEventClassListenerProxy(MockCustomEvent, mi, topic);
			assertEquals(0, _eventBus.getClassProxyListenerCount(MockCustomEvent, topic));
		}

		public function testAddClassEventListener():void {
			assertEquals(0, _eventBus.getClassListenerCount(MockCustomEvent));
			_eventBus.addEventClassListener(MockCustomEvent, new Function());
			assertEquals(1, _eventBus.getClassListenerCount(MockCustomEvent));
			_eventBus.addEventClassListener(MockCustomEvent, new Function());
			assertEquals(2, _eventBus.getClassListenerCount(MockCustomEvent));
		}

		public function testAddTopicClassEventListener():void {
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getClassListenerCount(MockCustomEvent, topic));
			_eventBus.addEventClassListener(MockCustomEvent, new Function(), false, topic);
			assertEquals(1, _eventBus.getClassListenerCount(MockCustomEvent, topic));
			_eventBus.addEventClassListener(MockCustomEvent, new Function(), false, topic);
			assertEquals(2, _eventBus.getClassListenerCount(MockCustomEvent, topic));
		}

		public function testRemoveClassEventListener():void {
			var f:Function = new Function();
			assertEquals(0, _eventBus.getClassListenerCount(MockCustomEvent));
			_eventBus.addEventClassListener(MockCustomEvent, f);
			assertEquals(1, _eventBus.getClassListenerCount(MockCustomEvent));
			_eventBus.removeEventClassListener(MockCustomEvent, f);
			assertEquals(0, _eventBus.getClassListenerCount(MockCustomEvent));
		}

		public function testRemoveTopicClassEventListener():void {
			var topic:String = "testTopic";
			var f:Function = new Function();
			assertEquals(0, _eventBus.getClassListenerCount(MockCustomEvent, topic));
			_eventBus.addEventClassListener(MockCustomEvent, f, false, topic);
			assertEquals(1, _eventBus.getClassListenerCount(MockCustomEvent, topic));
			_eventBus.removeEventClassListener(MockCustomEvent, f, topic);
			assertEquals(0, _eventBus.getClassListenerCount(MockCustomEvent, topic));
		}

		public function testRemoveEventListenerProxy():void {
			var m:MethodInvoker = new MethodInvoker();
			assertEquals(0, _eventBus.getEventListenerProxyCount("testType"));
			_eventBus.addEventListenerProxy("testType", m);
			assertEquals(1, _eventBus.getEventListenerProxyCount("testType"));
			_eventBus.removeEventListenerProxy("testType", m);
			assertEquals(0, _eventBus.getEventListenerProxyCount("testType"));
			_eventBus.removeEventListenerProxy("testType", m);
			assertEquals(0, _eventBus.getEventListenerProxyCount("testType"));
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
			assertEquals(1, _eventBus.getClassListenerCount(MockCustomEvent));
			assertEquals(1, _eventBus.getClassProxyListenerCount(MockCustomEvent));
			assertEquals(1, _eventBus.getEventListenerCount("testType"));
			assertEquals(1, _eventBus.getEventListenerProxyCount("testType"));
			assertEquals(1, _eventBus.getListenerCount());
			_eventBus.removeAllListeners();
			assertEquals(0, _eventBus.getClassListenerCount(MockCustomEvent));
			assertEquals(0, _eventBus.getClassProxyListenerCount(MockCustomEvent));
			assertEquals(0, _eventBus.getEventListenerCount("testType"));
			assertEquals(0, _eventBus.getEventListenerProxyCount("testType"));
			assertEquals(0, _eventBus.getListenerCount());
		}

		public function testAddEventClassInterceptor():void {
			assertEquals(0, _eventBus.getClassInterceptorCount(MockCustomEvent));
			_eventBus.addEventClassInterceptor(MockCustomEvent, new MockInterceptor(true));
			assertEquals(1, _eventBus.getClassInterceptorCount(MockCustomEvent));
		}

		public function testAddEventInterceptor():void {
			assertEquals(0, _eventBus.getEventInterceptorCount("testType"));
			_eventBus.addEventInterceptor("testType", new MockInterceptor(true));
			assertEquals(1, _eventBus.getEventInterceptorCount("testType"));
		}

		public function testAddInterceptor():void {
			assertEquals(0, _eventBus.getInterceptorCount());
			_eventBus.addInterceptor(new MockInterceptor(true));
			assertEquals(1, _eventBus.getInterceptorCount());
		}

		public function testRemoveEventClassInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.getClassInterceptorCount(MockCustomEvent));
			_eventBus.addEventClassInterceptor(MockCustomEvent, ic);
			assertEquals(1, _eventBus.getClassInterceptorCount(MockCustomEvent));
			_eventBus.removeEventClassInterceptor(MockCustomEvent, ic);
			assertEquals(0, _eventBus.getClassInterceptorCount(MockCustomEvent));
		}

		public function testRemoveEventInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.getEventInterceptorCount("testType"));
			_eventBus.addEventInterceptor("testType", ic);
			assertEquals(1, _eventBus.getEventInterceptorCount("testType"));
			_eventBus.removeEventInterceptor("testType", ic);
			assertEquals(0, _eventBus.getEventInterceptorCount("testType"));
		}

		public function testRemoveInterceptor():void {
			var ic:IEventInterceptor = new MockInterceptor(true);
			assertEquals(0, _eventBus.getInterceptorCount());
			_eventBus.addInterceptor(ic);
			assertEquals(1, _eventBus.getInterceptorCount());
			_eventBus.removeInterceptor(ic);
			assertEquals(0, _eventBus.getInterceptorCount());
		}

		public function testAddListenerInterceptor():void {
			var li:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var li2:IEventListenerInterceptor = new MockListenerInterceptor(true);
			assertEquals(0, _eventBus.getListenerInterceptorCount());
			_eventBus.addListenerInterceptor(li);
			assertEquals(1, _eventBus.getListenerInterceptorCount());
			_eventBus.addListenerInterceptor(li2);
			assertEquals(2, _eventBus.getListenerInterceptorCount());
		}

		public function testAddDuplicateListenerInterceptor():void {
			var li:IEventListenerInterceptor = new MockListenerInterceptor(true);
			assertEquals(0, _eventBus.getListenerInterceptorCount());
			_eventBus.addListenerInterceptor(li);
			assertEquals(1, _eventBus.getListenerInterceptorCount());
			_eventBus.addListenerInterceptor(li);
			assertEquals(1, _eventBus.getListenerInterceptorCount());
		}

		public function testAddListenerInterceptorForTopic():void {
			var li:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getListenerInterceptorCount(topic));
			_eventBus.addListenerInterceptor(li, topic);
			assertEquals(1, _eventBus.getListenerInterceptorCount(topic));
			assertEquals(0, _eventBus.getListenerInterceptorCount());
		}

		public function testAddEventListenerInterceptor():void {
			var li:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var li2:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var eventType:String = "testType";
			assertEquals(0, _eventBus.getEventListenerInterceptorCount(eventType));
			_eventBus.addEventListenerInterceptor(eventType, li);
			assertEquals(1, _eventBus.getEventListenerInterceptorCount(eventType));
			_eventBus.addEventListenerInterceptor(eventType, li2);
			assertEquals(2, _eventBus.getEventListenerInterceptorCount(eventType));
		}

		public function testAddEventListenerInterceptorForTopic():void {
			var li:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var li2:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var eventType:String = "testType";
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getEventListenerInterceptorCount(eventType, topic));
			_eventBus.addEventListenerInterceptor(eventType, li, topic);
			assertEquals(1, _eventBus.getEventListenerInterceptorCount(eventType, topic));
			assertEquals(0, _eventBus.getEventListenerInterceptorCount(eventType));
			_eventBus.addEventListenerInterceptor(eventType, li2, topic);
			assertEquals(2, _eventBus.getEventListenerInterceptorCount(eventType, topic));
			assertEquals(0, _eventBus.getEventListenerInterceptorCount(eventType));
		}

		public function testAddEventClassListenerInterceptor():void {
			var li:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var li2:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var eventClass:Class = MockCustomEvent;
			assertEquals(0, _eventBus.getClassListenerInterceptorCount(eventClass));
			_eventBus.addEventClassListenerInterceptor(eventClass, li);
			assertEquals(1, _eventBus.getClassListenerInterceptorCount(eventClass));
			_eventBus.addEventClassListenerInterceptor(eventClass, li2);
			assertEquals(2, _eventBus.getClassListenerInterceptorCount(eventClass));
		}

		public function testAddEventClassListenerInterceptorForTopic():void {
			var li:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var li2:IEventListenerInterceptor = new MockListenerInterceptor(true);
			var eventClass:Class = MockCustomEvent;
			var topic:String = "testTopic";
			assertEquals(0, _eventBus.getClassListenerInterceptorCount(eventClass, topic));
			_eventBus.addEventClassListenerInterceptor(eventClass, li, topic);
			assertEquals(1, _eventBus.getClassListenerInterceptorCount(eventClass, topic));
			assertEquals(0, _eventBus.getClassListenerInterceptorCount(eventClass));
			_eventBus.addEventClassListenerInterceptor(eventClass, li2, topic);
			assertEquals(2, _eventBus.getClassListenerInterceptorCount(eventClass, topic));
			assertEquals(0, _eventBus.getClassListenerInterceptorCount(eventClass));
		}

		public function testGlobalListenerIntercept():void {
			var eventType:String = "testType";
			_eventBus.addListenerInterceptor(new MockListenerInterceptor(true));
			_eventBus.addEventListener(eventType, eventBusTestListener);
			assertEquals(0, _eventBus.getEventListenerCount(eventType));
		}

		public function testGlobalIntercept():void {
			_eventBus.addEventListener("testType", eventBusTestListener);
			_eventBus.addInterceptor(new MockInterceptor(true));
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType");
			assertFalse(_eventReceived);
		}

		public function testGlobalListenerInterceptWithTopic():void {
			var eventType:String = "testType";
			var topic:String = "testTopic";
			_eventBus.addListenerInterceptor(new MockListenerInterceptor(true), topic);
			_eventBus.addEventListener(eventType, eventBusTestListener, false, topic);
			_eventBus.addEventListener(eventType, eventBusTestListener);
			assertEquals(0, _eventBus.getEventListenerCount(eventType, topic));
			assertEquals(1, _eventBus.getEventListenerCount(eventType));
		}

		public function testSpecificEventListenerIntercept():void {
			_eventBus.addEventListenerInterceptor("testType", new MockListenerInterceptor(true));
			_eventBus.addEventListener("testType", eventBusTestListener);
			_eventBus.addEventListener("testType2", eventBusTestListener);
			assertEquals(0, _eventBus.getEventListenerCount("testType"));
			assertEquals(1, _eventBus.getEventListenerCount("testType2"));
		}

		public function testSpecificEventListenerInterceptWithTopic():void {
			var topic:String = "testTopic";
			_eventBus.addEventListenerInterceptor("testType", new MockListenerInterceptor(true), topic);
			_eventBus.addEventListener("testType", eventBusTestListener, false, topic);
			_eventBus.addEventListener("testType", eventBusTestListener);
			assertEquals(0, _eventBus.getEventListenerCount("testType", topic));
			assertEquals(1, _eventBus.getEventListenerCount("testType"));
		}

		public function testGlobalInterceptWithTopic():void {
			var topic:String = "testTopic";
			_eventBus.addEventListener("testType", eventBusTestListener, false, topic);
			_eventBus.addInterceptor(new MockInterceptor(true), topic);
			assertFalse(_eventReceived);
			var dispatched:Boolean = _eventBus.dispatch("testType", topic);
			assertFalse(dispatched);
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

		public function testSpecificEventIntercept():void {
			_eventBus.addEventListener("testType", eventBusTestListener, false);
			_eventBus.addEventListener("testType2", eventBusTestListener, false);
			_eventBus.addEventInterceptor("testType", new MockInterceptor(true));
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType");
			assertFalse(_eventReceived);
			_eventReceived = false;
			_eventBus.dispatch("testType2");
			assertTrue(_eventReceived);
		}

		public function testSpecificEventInterceptWithTopic():void {
			var topic:String = "testTopic";
			_eventBus.addEventListener("testType", eventBusTestListener, false, topic);
			_eventBus.addEventListener("testType2", eventBusTestListener, false);
			_eventBus.addEventInterceptor("testType", new MockInterceptor(true), topic);
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType");
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType", topic);
			assertFalse(_eventReceived);
			_eventReceived = false;
			_eventBus.dispatch("testType2");
			assertTrue(_eventReceived);
			_eventReceived = false;
			_eventBus.dispatch("testType2", topic);
			assertFalse(_eventReceived);
		}

		public function testSpecificEventInterceptWithComplexTypedTopic():void {
			var topic:EventBus = new EventBus();
			_eventBus.addEventListener("testType", eventBusTestListener, false, topic);
			_eventBus.addEventListener("testType2", eventBusTestListener, false);
			_eventBus.addEventInterceptor("testType", new MockInterceptor(true), topic);
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType");
			assertFalse(_eventReceived);
			_eventBus.dispatch("testType", topic);
			assertFalse(_eventReceived);
			_eventReceived = false;
			_eventBus.dispatch("testType2");
			assertTrue(_eventReceived);
			_eventReceived = false;
			_eventBus.dispatch("testType2", topic);
			assertFalse(_eventReceived);
		}

		public function eventBusTestListener(event:Event):void {
			_eventReceived = true;
		}

	}
}

import flash.events.Event;

import org.as3commons.eventbus.IEventBusListener;
import org.as3commons.eventbus.IEventInterceptor;
import org.as3commons.eventbus.impl.AbstractEventInterceptor;
import org.as3commons.eventbus.impl.AbstractEventListenerInterceptor;
import org.as3commons.reflect.MethodInvoker;

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

class MockInterceptor extends AbstractEventInterceptor {

	public function MockInterceptor(block:Boolean) {
		blockEvent = block;
	}

	override public function intercept(event:Event):void {
	}
}

class MockListenerInterceptor extends AbstractEventListenerInterceptor {

	public function MockListenerInterceptor(block:Boolean) {
		blockListener = block;
	}

	override public function interceptListener(listener:Function, eventType:String = null, eventClass:Class = null):void {
	}

	override public function interceptListenerProxy(proxy:MethodInvoker, eventType:String = null, eventClass:Class = null):void {
	}
}