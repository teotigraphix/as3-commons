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
package org.as3commons.eventbus.impl {
	import flash.events.Event;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.reflect.MethodInvoker;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.object.nullValue;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventListenerGuardianTest {
		private var _guardian:EventListenerGuardian;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		[Mock]
		public var eventBus:IEventBus;

		/**
		 * Creates a new <code>EventListenerGuardianTest</code> instance.
		 */
		public function EventListenerGuardianTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_guardian = new EventListenerGuardian();
			eventBus = nice(IEventBus);
			_guardian.eventBus = eventBus;
		}

		[Test]
		public function testMaxDispatchCount():void {
			assertEquals(0, _guardian.maxDispatchCount);
			_guardian.maxDispatchCount = 10;
			assertEquals(10, _guardian.maxDispatchCount);
		}

		[Test]
		public function testMaxDispatchCountNotReachedWithProxyAndEventType():void {
			var proxy:MethodInvoker = new MethodInvoker();

			mock(eventBus).method("removeEventListenerProxy").args("test", proxy, nullValue()).never();

			_guardian.maxDispatchCount = 5;
			_guardian.interceptListenerProxy(proxy, "test");
			var event:Event = new Event("test");
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);

			verify(eventBus);
		}

		[Test]
		public function testMaxDispatchCountWithProxyAndEventType():void {
			var proxy:MethodInvoker = new MethodInvoker();

			mock(eventBus).method("removeEventListenerProxy").args("test", proxy, nullValue()).once();

			_guardian.maxDispatchCount = 5;
			_guardian.interceptListenerProxy(proxy, "test");
			var event:Event = new Event("test");
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);

			verify(eventBus);
		}

		[Test]
		public function testMaxDispatchCountNotReachedWithProxyAndEventClass():void {
			var proxy:MethodInvoker = new MethodInvoker();

			mock(eventBus).method("removeEventClassListenerProxy").args(Event, proxy, nullValue()).never();

			_guardian.maxDispatchCount = 5;
			_guardian.interceptListenerProxy(proxy, null, Event);
			var event:Event = new Event("test");
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);

			verify(eventBus);
		}

		[Test]
		public function testMaxDispatchCountWithProxyAndEventClass():void {
			var proxy:MethodInvoker = new MethodInvoker();

			mock(eventBus).method("removeEventClassListenerProxy").args(Event, proxy, nullValue()).once();

			_guardian.maxDispatchCount = 5;
			_guardian.interceptListenerProxy(proxy, null, Event);
			var event:Event = new Event("test");
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);
			_guardian.postProcess(event, false);

			verify(eventBus);
		}
	}
}
