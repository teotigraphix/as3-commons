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
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.typeinfo.Annotatable;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of <code>Trait_Slot</code> or <code>Trait_Const</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Slot and const traits" in the AVM Spec (page 30)
	 */
	public final class SlotOrConstantTrait extends TraitInfo {

		public var slotId:int;
		public var typeMultiname:BaseMultiname;
		public var vindex:int = 0;
		public var vkind:ConstantKind = null;
		public var isStatic:Boolean;
		public var defaultValue:*;

		public function SlotOrConstantTrait() {
			super();
		}

		override public function clone():* {
			var slot:SlotOrConstantTrait = new SlotOrConstantTrait();
			populateClone(slot);
		}

		override protected function populateClone(annotatable:Annotatable):void {
			super.populateClone(annotatable);
			var slot:SlotOrConstantTrait = SlotOrConstantTrait(annotatable);
			slot.slotId = slotId;
			slot.typeMultiname = typeMultiname.clone();
			slot.vindex = vindex;
			slot.vkind = vkind;
			slot.isStatic = isStatic;
			slot.defaultValue = (defaultValue is ICloneable) ? ICloneable(defaultValue).clone() : defaultValue;
		}

		public function toString():String {
			return StringUtils.substitute("SlotOrConstantTrait[name={0}, metadata={1}, kind={2}, slot={3}, typeName={4}, vindex={5}, vkind={6}]", ((traitMultiname) ? traitMultiname : ""), metadata, traitKind.description, slotId, typeMultiname, vindex, ((vkind) ? vkind : ""));
		}

		override public function equals(other:Object):Boolean {
			var result:Boolean = super.equals(other);
			if (result) {
				var otherTrait:SlotOrConstantTrait = other as SlotOrConstantTrait;
				if (otherTrait != null) {
					if (slotId != otherTrait.slotId) {
						return false;
					}
					if (!typeMultiname.equals(otherTrait.typeMultiname)) {
						return false;
					}
					if (vindex != otherTrait.vindex) {
						return false;
					}
					if (vkind !== otherTrait.vkind) {
						return false;
					}
					if (isStatic != otherTrait.isStatic) {
						return false;
					}
					if (!isNaN(defaultValue)) {
						if (defaultValue !== otherTrait.defaultValue) {
							return false;
						}
					} else if (isNaN(defaultValue) && isNaN(otherTrait.defaultValue) == false) {
						return false;
					}
				} else {
					return false;
				}
			}
			return result;
		}
	}
}
