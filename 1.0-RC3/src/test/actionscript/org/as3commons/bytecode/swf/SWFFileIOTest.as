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
package org.as3commons.bytecode.swf {

	import flash.utils.ByteArray;

	import flexunit.framework.TestCase;

	import mx.core.Application;
	import mx.managers.SystemManager;

	import org.as3commons.bytecode.TestConstants;

	public class SWFFileIOTest extends TestCase {

		private var _swfFileIO:SWFFileIO;

		public function SWFFileIOTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_swfFileIO = new SWFFileIO();
		}

		public function testLoadFromLoaderInfo():void {
			var file:SWFFile = _swfFileIO.read(SystemManager(Application.application.systemManager).loaderInfo.bytes);
		}

		public function testDeserializeFramework4():void {
			var byteStream:ByteArray = TestConstants.getFramework4();
			var file:SWFFile = _swfFileIO.read(byteStream);
		}

		public function testDeserializeFramework41():void {
			var byteStream:ByteArray = TestConstants.getFramework41();
			var file:SWFFile = _swfFileIO.read(byteStream);
		}

	}
}