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
package org.as3commons.configuration.impl {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 *
	 * @author rolandzwaga
	 */
	public class ConfigurationTest {
		private var _config:Configuration;

		/**
		 * Creates a new <code>ConfigurationTest</code> instance.
		 */
		public function ConfigurationTest() {
			super();
		}
		
		[Before]
		public function setUp():void {
			_config = new Configuration();
		}
		
		[Test]
		public function testIsEmptyWithEmptyConfig():void {
			assertTrue(_config.isEmpty());
		}
		
		[Test]
		public function testIsEmptyWithNonEmptyConfig():void {
			_config.setProperty("test", "testValue");
			assertFalse(_config.isEmpty());
		}

		[Test]
		public function testContainsKeyForNonExistingKey():void {
			assertFalse(_config.containsKey("test"));
		}

		[Test]
		public function testContainsKeyForExistingKey():void {
			_config.setProperty("test", "testValue");
			assertTrue(_config.containsKey("test"));
		}
		
		[Test]
		public function testGetProperty():void {
			_config.setProperty("test", "testValue");
			assertEquals("testValue", _config.getProperty("test"));
		}

		[Test]
		public function testGetBooleanWithTypedBoolean():void {
			_config.setProperty("test", true);
			assertTrue(_config.getBoolean("test"));
		}

		[Test]
		public function testGetBooleanWithBooleanString():void {
			_config.setProperty("test", "true");
			assertTrue(_config.getBoolean("test"));
		}

		[Test]
		public function testGetBooleanForNonBoolean():void {
			_config.setProperty("test", "testValue");
			assertFalse(_config.getBoolean("test"));
		}
	}
}
