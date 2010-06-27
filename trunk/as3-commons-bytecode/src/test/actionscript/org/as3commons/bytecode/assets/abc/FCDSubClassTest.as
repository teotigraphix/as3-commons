/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.assets.abc {
	import assets.abc.FCDSubClass;
	import assets.abc.custom_namespace;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.template.MethodInvocation;

	use namespace as3commons_bytecode;
	use namespace custom_namespace;

	//TODO: Come up with crafty ways around the setter/getter problem
	public class FCDSubClassTest extends TestCase {

		private var _fixture:FCDSubClass;


		public function FCDSubClassTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_fixture = new FCDSubClass();
		}

		public function testMethodWithOptionalArguments():void {
			_fixture.as3commons_bytecode::setHandler("methodWithOptionalArguments", function(invocation:MethodInvocation):void {
					assertEquals(3, invocation.args.length);
				});
			_fixture.methodWithOptionalArguments("Required");
		}

		public function testMethodWithRestArguments():void {
			_fixture.as3commons_bytecode::setHandler("methodWithRestArguments", function(invocation:MethodInvocation):void {
					assertTrue(invocation.args[0] is String);
					assertTrue(invocation.args[1] is Array);
					assertEquals(2, invocation.args[1].length);
				});
			_fixture.methodWithRestArguments("arg1", "arg2", "arg3");
		}

		public function testSetterWithoutHandler():void {
			_fixture.setterForInternalValue = "newValue";
			assertEquals("newValue", _fixture.getterForInternalValue);
		}

		public function testSetterWithHandler():void {
			_fixture.as3commons_bytecode::setHandler("setterForInternalValue", function(invocation:MethodInvocation):* {
					assertNull(invocation.originalMethodReference);
					return true;
				});
			_fixture.setterForInternalValue = "newValue";
		}

		public function testGetterWithoutHandler():void {
			assertNull(_fixture.getterForInternalValue);
		}

		public function testCustomNamespaceFunction():void {
			_fixture.as3commons_bytecode::setHandler("customNamespaceFunction", function(invocation:MethodInvocation):void {
					assertEquals("customNamespaceFunction", invocation.methodName);
				});
			_fixture.custom_namespace::customNamespaceFunction();
		}
	}
}