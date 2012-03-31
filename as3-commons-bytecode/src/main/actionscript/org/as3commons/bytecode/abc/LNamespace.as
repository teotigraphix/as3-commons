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
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;

	/**
	 * as3commons-bytecode representation of <code>namespace_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Namespace" in the AVM Spec (page 22)
	 */
	public final class LNamespace implements ICloneable, IEquals {

		public static const PUBLIC:LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, ""); // Namespace[public::*]
		public static const ASTERISK:LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "*"); //  Namespace[namespace::*]
		public static const FLASH_UTILS:LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "flash.utils"); //  Namespace[public::flash.utils]
		public static const BUILTIN:LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "http://adobe.com/AS3/2006/builtin"); // Namespace[namespace::http://adobe.com/AS3/2006/builtin]

		public var kind:NamespaceKind;
		public var name:String;

		public function LNamespace(kindValue:NamespaceKind, nameValue:String) {
			CONFIG::debug {
				Assert.notNull(kindValue, "kindValue argument must not be null");
			}
			kind = kindValue;
			name = nameValue;
		}

		public function clone():* {
			return new LNamespace(this.kind, this.name);
		}

		public function equals(other:Object):Boolean {
			var namespacesMatch:Boolean = false;
			var namespaze:LNamespace = LNamespace(other);

			var thisNamespaceIsPrivate:Boolean = (this.kind == NamespaceKind.PRIVATE_NAMESPACE);
			var comparingNamespaceIsPrivate:Boolean = (namespaze.kind == NamespaceKind.PRIVATE_NAMESPACE);
			if ((thisNamespaceIsPrivate && comparingNamespaceIsPrivate) && (!as3commons_bytecode::semanticEquality)) {
				namespacesMatch = (namespaze == this);
			} else {
				namespacesMatch = (this.kind == namespaze.kind) && (this.name == namespaze.name);
			}

			return namespacesMatch;
		}

		as3commons_bytecode static var semanticEquality:Boolean = false;

		public function toString():String {
			var string:String = "Namespace[" + kind.description;
			string += (name != "") ? "::" : "";
			string += name;
			string += "]";

			return string;
		}
	}
}
