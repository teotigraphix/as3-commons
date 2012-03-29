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

	public class LNamespaceTest {

		public function LNamespaceTest() {

		}

		[Test]
		public function testEquals():void {
			var starName:String = "*";
			for each (var starKind:NamespaceKind in NamespaceKind.types) {
				var firstStarNamespace:LNamespace = new LNamespace(starKind, starName);
				var secondStarNamespace:LNamespace = new LNamespace(starKind, starName);

				if (starKind == NamespaceKind.PRIVATE_NAMESPACE) {
					assertFalse(firstStarNamespace.equals(secondStarNamespace));
				} else {
					assertTrue(firstStarNamespace.equals(secondStarNamespace));
				}
			}

			var privateNamespace:LNamespace = new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, "whatever");
			assertTrue(privateNamespace.equals(privateNamespace));
		}
	}
}