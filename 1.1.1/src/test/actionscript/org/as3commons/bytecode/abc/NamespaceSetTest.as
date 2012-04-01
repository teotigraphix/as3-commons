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

	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class NamespaceSetTest {

		private var _fixture:NamespaceSet;

		public function NamespaceSetTest() {
		}

		[Before]
		public function setUp():void {
			_fixture = new NamespaceSet();
		}

		[Test]
		public function testEquals():void {
			var namespaceArray:Array = [new LNamespace(NamespaceKind.NAMESPACE, "namespaceOne"), new LNamespace(NamespaceKind.NAMESPACE, "namespaceTwo")];
			_fixture = new NamespaceSet(namespaceArray);
			var matchingSet:NamespaceSet = new NamespaceSet(namespaceArray);
			assertTrue(_fixture.equals(matchingSet));

			var notMatchingSet:NamespaceSet = new NamespaceSet([new LNamespace(NamespaceKind.EXPLICIT_NAMESPACE, "namespaceThree")]);
			assertFalse(_fixture.equals(notMatchingSet));
		}
	}
}