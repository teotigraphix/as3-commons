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
	import org.as3commons.bytecode.abc.enum.MultinameKind;

	/**
	 * Loom representation of a multiname. Although I hate using the word "base" in classes, I was required to since there
	 * is a multiname type called <code>Multiname</code>.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Names" in the AVM Spec (page 8)
	 */
	public class BaseMultiname {
		private var _kind:MultinameKind;

		public function BaseMultiname(kindValue:MultinameKind) {
			_kind = kindValue;
		}

		public function assertAppropriateMultinameKind(expectedKinds:Array, givenKind:MultinameKind):void {
			if (expectedKinds.indexOf(givenKind) == -1) {
				throw new Error("Invalid Multiname Kind: " + givenKind);
			}
		}

		public function get kind():MultinameKind {
			return _kind;
		}

		public function equals(multiname:BaseMultiname):Boolean {
			var matches:Boolean = false;
			if (multiname.kind == kind) {
				matches = true;
			}

			return matches;
		}
	}
}