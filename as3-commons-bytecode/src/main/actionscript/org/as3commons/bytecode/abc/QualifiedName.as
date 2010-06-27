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
	 * Loom representation of <code>QName</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "QName" in the AVM Spec (page 23)
	 */
	public class QualifiedName extends NamedMultiname {
		private var _namespace:LNamespace;

		public function QualifiedName(name:String, nameSpace:LNamespace, kindValue:MultinameKind = null) {
			_namespace = nameSpace;
			kindValue = (kindValue) ? kindValue : MultinameKind.QNAME;

			super(kindValue, name);
			if (assertAppropriateMultinameKind([MultinameKind.QNAME, MultinameKind.QNAME_A], kindValue)) {
				throw new Error("Invalid multiname kind: " + kindValue);
			}
		}

		public function get nameSpace():LNamespace {
			return _namespace;
		}

		public function set nameSpace(value:LNamespace):void {
			_namespace = value;
		}

		public function get fullName():String {
			if (this.name != '*') {
				if (StringUtils.hasText(_namespace.name)) {
					return StringUtils.substitute("{0}.{1}", _namespace.name, this.name);
				} else {
					return this.name;
				}
			} else {
				return '*';
			}
		}

		public function toString():String {
			return StringUtils.substitute("{0}[{1}:{2}]", kind.description, nameSpace, name);
		}
	}
}