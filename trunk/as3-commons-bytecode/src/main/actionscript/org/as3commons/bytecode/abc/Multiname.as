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
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Multiname" in the AVM Spec (page 23)
	 */
	public final class Multiname extends NamedMultiname {
		private var _namespaceSet:NamespaceSet;

		public function Multiname(multiname:String, namespaceSet:NamespaceSet, kind:MultinameKind = null) {
			kind = (kind) ? kind : MultinameKind.MULTINAME;
			super(kind, multiname);

			assertAppropriateMultinameKind([MultinameKind.MULTINAME, MultinameKind.MULTINAME_A], kind);
			_namespaceSet = namespaceSet;
		}

		public function get namespaceSet():NamespaceSet {
			return _namespaceSet;
		}

		override public function equals(other:Object):Boolean {
			var matches:Boolean = false;
			if (other is Multiname) {
				var cMultiname:Multiname = Multiname(other);
				if (cMultiname.namespaceSet) {
					if (cMultiname.namespaceSet.equals(this.namespaceSet)) {
						if (super.equals(other)) {
							matches = true;
						}
					}
				}
			}

			return matches;
		}

		override public function toString():String {
			return StringUtils.substitute("{0}[name={1}, nsset={2}]", kind.description, name, namespaceSet);
		}
	}
}