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
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.util.CloneUtils;

	/**
	 * as3commons-bytecode representation of <code>ns_set_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Namespace set" in the AVM Spec (page 22)
	 */
	public final class NamespaceSet implements ICloneable, IEquals {

		public static const PUBLIC_NSSET:NamespaceSet = new NamespaceSet([LNamespace.PUBLIC]);

		private var _namespaces:Array;

		public function NamespaceSet(namespaceArray:Array = null) {
			super();
			_namespaces = (namespaceArray) ? namespaceArray : [];
		}


		public function clone():* {
			var clone:NamespaceSet = new NamespaceSet(CloneUtils.cloneList(_namespaces));
		}

		public function get namespaces():Array {
			return _namespaces;
		}

		public function addNamespace(namespaze:LNamespace):void {
			_namespaces[_namespaces.length] = namespaze;
		}

		public function equals(other:Object):Boolean {
			var namespaceSet:NamespaceSet = NamespaceSet(other);
			var matches:Boolean = (this.namespaces.length == namespaceSet.namespaces.length);
			if (matches) {
				for (var i:int = 0; i < namespaces.length; ++i) {
					if (!namespaces[i].equals(namespaceSet.namespaces[i])) {
						matches = false;
						break;
					}
				}
			}

			return matches;
		}

		public function toString():String {
			return "[" + namespaces.join(", ") + "]";
		}
	}
}