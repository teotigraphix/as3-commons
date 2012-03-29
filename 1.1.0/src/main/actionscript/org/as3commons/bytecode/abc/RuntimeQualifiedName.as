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
	 * as3commons-bytecode representation of <code>RTQName</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "RTQName" in the AVM Spec (page 8)
	 */
	public final class RuntimeQualifiedName extends NamedMultiname {

		public function RuntimeQualifiedName(name:String, kindValue:MultinameKind = null) {
			kindValue = (kindValue) ? kindValue : MultinameKind.RTQNAME;
			super(kindValue, name);
			assertAppropriateMultinameKind([MultinameKind.RTQNAME, MultinameKind.RTQNAME_A], kindValue);
		}

		override public function clone():* {
			return new RuntimeQualifiedName(name, kind);
		}

		override public function toString():String {
			return StringUtils.substitute("{0}[name={1}]", kind.description, name);
		}
	}
}