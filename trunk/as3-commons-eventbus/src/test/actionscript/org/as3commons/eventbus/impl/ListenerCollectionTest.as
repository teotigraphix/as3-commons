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
package org.as3commons.eventbus.impl {
	import flexunit.framework.TestCase;

	public class ListenerCollectionTest extends TestCase {

		public function ListenerCollectionTest(methodName:String = null) {
			super(methodName);
		}

		public function testLength():void {
			var lc:ListenerCollection = new ListenerCollection();
			assertEquals(0, lc.length);
			var o:Object = {};
			lc.add(o, true);
			lc.add({}, true);
			lc.add({}, true);
			assertEquals(3, lc.length);
			lc.remove(o);
			assertEquals(2, lc.length);
		}

		public function testAdd():void {
			var lc:ListenerCollection = new ListenerCollection();
			assertEquals(0, lc.length);
			var o:Object = {};
			lc.add(o, true);
			assertEquals(1, lc.length);
		}

		public function testRemove():void {
			var lc:ListenerCollection = new ListenerCollection();
			assertEquals(0, lc.length);
			var o:Object = {};
			lc.add(o, true);
			assertEquals(1, lc.length);
			lc.remove(o);
			assertEquals(0, lc.length);
		}

		public function testIndexOf():void {
			var lc:ListenerCollection = new ListenerCollection();
			assertEquals(0, lc.length);
			var o:Object = {};
			lc.add(o, true);
			assertEquals(0, lc.indexOf(o));
			assertEquals(-1, lc.indexOf({}));
		}

		public function testGet():void {
			var lc:ListenerCollection = new ListenerCollection();
			assertEquals(0, lc.length);
			var o:Object = {};
			lc.add(o, true);
			assertEquals(o, lc.get(0));
			assertNull(lc.get(1));
		}

	}
}