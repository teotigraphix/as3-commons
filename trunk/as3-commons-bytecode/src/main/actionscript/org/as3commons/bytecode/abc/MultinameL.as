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
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of <code>multiname_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "MultinameL" in the AVM Spec (page 24)
	 */
	public final class MultinameL extends BaseMultiname {

		private var _namespaceSet:NamespaceSet;

		public function MultinameL(namespaceSet:NamespaceSet, kindValue:MultinameKind=null) {
			kindValue = (kindValue) ? kindValue : MultinameKind.MULTINAME_L;
			super(kindValue);
			initMultinameL(kindValue, namespaceSet);
		}

		protected function initMultinameL(kindValue:MultinameKind, namespaceSet:NamespaceSet):void {
			assertAppropriateMultinameKind([MultinameKind.MULTINAME_L, MultinameKind.MULTINAME_LA], kindValue);
			_namespaceSet = namespaceSet;
		}

		override public function clone():* {
			return new MultinameL(_namespaceSet, this.kind);
		}

		public function get namespaceSet():NamespaceSet {
			return _namespaceSet;
		}

		override public function equals(other:Object):Boolean {
			var matches:Boolean = false;
			if (other is MultinameL) {
				if (MultinameL(other).namespaceSet.equals(namespaceSet)) {
					if (super.equals(other)) {
						matches = true;
					}
				}
			}

			return matches;
		}

		override public function toString():String {
			return StringUtils.substitute("{0}[nsset={1}]", kind.description, namespaceSet);
		}
	}
}
