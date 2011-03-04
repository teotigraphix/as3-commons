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
	import flash.utils.ByteArray;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.TestConstants;

	public class ByteCodeTypeTest extends TestCase {

		public function ByteCodeTypeTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			ByteCodeType.getCache().clear();
		}

		public function testDebugBuildRead():void {
			var source:ByteArray = TestConstants.getDebugBuildTest();
			ByteCodeType.fromByteArray(source, null, false);
			var type:ByteCodeType = ByteCodeType.forName("classes.TestImplementation");
			assertNotNull(type);
			assertEquals(12, type.methods.length);
			assertEquals(1, type.accessors.length);

			var ba:ByteCodeAccessor = type.accessors[0];
			assertEquals("testAccessor", ba.name);

			var bm:ByteCodeMethod = type.getMethod("testMethod") as ByteCodeMethod;
			assertEquals("testMethod", bm.name);
			assertEquals("public testMethod():int", bm.fullName);
			assertEquals(1, type.interfaces.length);
			assertEquals("interfaces.ITestInterface", String(type.interfaces[0]));

			bm = type.getMethod("testProtectedMethod") as ByteCodeMethod;
			assertEquals("protected:", bm.scopeName);

			bm = type.getMethod("testPrivateMethod") as ByteCodeMethod;
			assertEquals("private:", bm.scopeName);

			type = ByteCodeType.forName("interfaces.ITestInterface");
			assertNotNull(type);
			assertEquals(1, type.methods.length);
			assertEquals(1, type.accessors.length);

			bm = type.getMethod("testMethod") as ByteCodeMethod;
			assertEquals("interfaces:ITestInterface", bm.scopeName);

			var classNames:Array = ByteCodeType.interfaceLookup["interfaces.ITestInterface"];
			assertNotNull(classNames.length);
			assertEquals(1, classNames.length);
			assertEquals("classes.TestImplementation", classNames[0]);
		}

		public function testReleaseBuildRead():void {
			var source:ByteArray = TestConstants.getReleaseBuildTest();
			ByteCodeType.fromByteArray(source, null, false);
			var type:ByteCodeType = ByteCodeType.forName("classes.TestImplementation");
			assertNotNull(type);
			assertEquals(12, type.methods.length);
			assertEquals(1, type.accessors.length);

			var ba:ByteCodeAccessor = type.accessors[0];
			assertEquals("testAccessor", ba.name);

			var bm:ByteCodeMethod = type.getMethod("testMethod") as ByteCodeMethod;
			assertEquals("testMethod", bm.name);
			assertEquals("public testMethod():int", bm.fullName);
			assertEquals(1, type.interfaces.length);
			assertEquals("interfaces.ITestInterface", String(type.interfaces[0]));

			bm = type.getMethod("testProtectedMethod") as ByteCodeMethod;
			assertEquals("protected:", bm.scopeName);

			bm = type.getMethod("testPrivateMethod") as ByteCodeMethod;
			assertEquals("private:", bm.scopeName);

			type = ByteCodeType.forName("interfaces.ITestInterface");
			assertNotNull(type);
			assertEquals(1, type.methods.length);
			assertEquals(1, type.accessors.length);

			bm = type.getMethod("testMethod") as ByteCodeMethod;
			assertEquals("interfaces:ITestInterface", bm.scopeName);

			var classNames:Array = ByteCodeType.interfaceLookup["interfaces.ITestInterface"];
			assertNotNull(classNames.length);
			assertEquals(1, classNames.length);
			assertEquals("classes.TestImplementation", classNames[0]);
		}

	}
}