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
package org.as3commons.bytecode.reflect {
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;

	import mx.core.Application;
	import mx.core.FlexGlobals;

	import org.flexunit.asserts.assertNotNull;

	public class PlayerGlobalDataTest {

		private var _applicationDomain:ApplicationDomain;

		public function PlayerGlobalDataTest() {
		}

		[Before]
		public function setUp():void {
			var loaderInfo:LoaderInfo = Application(FlexGlobals.topLevelApplication).loaderInfo;
			_applicationDomain = loaderInfo.applicationDomain;
			ByteCodeType.fromLoader(loaderInfo, _applicationDomain);
		}

		[Test]
		public function testForNameEventDispatcher():void {
			var type:ByteCodeType = ByteCodeType.forClass(Application, _applicationDomain);
			for each (var method:ByteCodeMethod in type.methods) {
				var i:int = 0;
			}
			assertNotNull(type);
		}
	}
}
