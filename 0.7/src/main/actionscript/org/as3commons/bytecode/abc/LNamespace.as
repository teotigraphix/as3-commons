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

	/**
	 * as3commons-bytecode representation of <code>namespace_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Namespace" in the AVM Spec (page 22)
	 */
	public class LNamespace {

		public static const PUBLIC:LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, ""); // Namespace[public::*]
		public static const ASTERISK:LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "*"); //  Namespace[namespace::*]
		public static const FLASH_UTILS:LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "flash.utils"); //  Namespace[public::flash.utils]

		public var kind:NamespaceKind;
		public var name:String;

		public function LNamespace(kindValue:NamespaceKind, nameValue:String) {
			super();
			kind = kindValue;
			name = nameValue;
		}

		public function equals(namespaze:LNamespace):Boolean {
			var namespacesMatch:Boolean = false;

			var thisNamespaceIsPrivate:Boolean = (this.kind == NamespaceKind.PRIVATE_NAMESPACE);
			var comparingNamespaceIsPrivate:Boolean = (namespaze.kind == NamespaceKind.PRIVATE_NAMESPACE);
			if (thisNamespaceIsPrivate && comparingNamespaceIsPrivate) {
				namespacesMatch = (namespaze == this);
			} else {
				namespacesMatch = (this.kind == namespaze.kind) && (this.name == namespaze.name);
			}

			return namespacesMatch;
		}

		public function toString():String {
			var string:String = "Namespace[" + kind.description;
			string += (name != "") ? "::" : "";
			string += name;
			string += "]";

			return string;
		}
	}
}