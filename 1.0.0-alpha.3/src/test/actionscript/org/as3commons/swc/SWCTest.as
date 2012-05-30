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
package org.as3commons.swc {
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.lang.StringUtils;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;

	public class SWCTest {

		public function SWCTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		[Test(async)]
		public function testLoad():void {
			var swc:SWC = new SWC("as3commons-concurrency.swc");
			var operation:IOperation = swc.load();
			operation.addCompleteListener(Async.asyncHandler(this, testLoad_completeHandler, 10000));
		}

		private function testLoad_completeHandler(event:OperationEvent, data:*):void {
			var swc:SWC = SWC(event.result);
			assertEquals("as3commons-concurrency.swc", swc.url);
			assertEquals(1, swc.numLibraries);
			assertNotNull(swc.scripts);
			assertTrue(swc.scripts.length > 0);
			assertNotNull(swc.getClass("org.as3commons.concurrency.thread.PseudoThread"));
			assertNotNull(swc.classNames);
			assertTrue(swc.classNames.length > 0);
			assertTrue(swc.classNames.indexOf("org.as3commons.concurrency.thread.PseudoThread") > -1);
		}

		[Test(async)]
		public function testLoad_wrongURL():void {
			var swc:SWC = new SWC("no-such-library.swc");
			var operation:IOperation = swc.load();
			operation.addCompleteListener(testLoad_wrongURL_completeHandler);
			operation.addErrorListener(Async.asyncHandler(this, testLoad_wrongURL_errorHandler, 1000));
		}

		private function testLoad_wrongURL_completeHandler(event:OperationEvent, data:*):void {
			fail("Loading a non-existing library should fail.");
		}

		private function testLoad_wrongURL_errorHandler(event:OperationEvent, data:*):void {
			assertNotNull(event.error);
			assertTrue(StringUtils.hasText(event.error));
		}

		[Test(expects="org.as3commons.lang.IllegalStateError")]
		public function testLoad_shouldThrowIllegalStateErrorWhenGettingClassWhenNotLoaded():void {
			var swc:SWC = new SWC("as3commons-concurrency.swc");
			swc.getClass("org.as3commons.concurrency.thread.PseudoThread");
		}

	}
}
