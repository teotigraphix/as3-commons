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
package org.as3commons.bytecode.abc {
	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.enum.NamespaceKind;

	public class ConstantPoolTest extends TestCase {
		private var _fixture:ConstantPool;


		public function ConstantPoolTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_fixture = new ConstantPool();
		}

		public function testAddInt():void {
			assertEquals(1, _fixture.addInt(1));
			assertEquals(2, _fixture.addInt(2));
			assertEquals(1, _fixture.addInt(1));
			assertEquals(2, _fixture.addInt(2));
			assertEquals(3, _fixture.integerPool.length);
		}

		public function testAddNamespace():void {
			// First item should already be present in the pool
			assertEquals(0, _fixture.addNamespace(new LNamespace(NamespaceKind.NAMESPACE, "*")));

			// Add additional namespaces
			assertEquals(1, _fixture.addNamespace(new LNamespace(NamespaceKind.NAMESPACE, "namespaceOne")));
			assertEquals(2, _fixture.addNamespace(new LNamespace(NamespaceKind.NAMESPACE, "namespaceTwo")));

			// Test matching names with different kinds
			assertEquals(3, _fixture.addNamespace(new LNamespace(NamespaceKind.EXPLICIT_NAMESPACE, "namespaceOne")));

			// Tets length
			assertEquals(4, _fixture.namespacePool.length);
		}

		public function testAddString():void {
			assertEquals(1, _fixture.addString("stringOne"));
			assertEquals(2, _fixture.addString("stringTwo"));
			assertEquals(1, _fixture.addString("stringOne"));
			assertEquals(2, _fixture.addString("stringTwo"));
			assertEquals(3, _fixture.stringPool.length);
		}
	}
}