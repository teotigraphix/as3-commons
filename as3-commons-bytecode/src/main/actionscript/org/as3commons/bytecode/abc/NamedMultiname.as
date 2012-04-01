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
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IEquals;

	/**
	 * Representation of a named multiname, which doesn't exist in the ABC spec but represents several types described
	 * within it.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "MultinameL" in the AVM Spec (page 23)
	 */
	public class NamedMultiname extends BaseMultiname {
		private var _name:String;

		public function NamedMultiname(kindValue:MultinameKind, name:String) {
			super(kindValue);
			CONFIG::debug {
				Assert.notNull(name, "name argument must not be null");
			}
			_name = name;
		}

		override public function clone():* {
			return new NamedMultiname(this.kind, _name);
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		override public function equals(other:Object):Boolean {
			var matches:Boolean = false;
			if (other is NamedMultiname) {
				if (NamedMultiname(other).name == _name) {
					if (super.equals(other)) {
						matches = true;
					}
				}
			}

			return matches;
		}
	}
}
