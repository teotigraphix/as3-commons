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
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.lang.IEquals;

	public class BaseTypeInfo implements IEquals {

		public var traits:Vector.<TraitInfo>;

		public function BaseTypeInfo() {
			super();
			traits = new Vector.<TraitInfo>();
		}

		public function addTrait(trait:TraitInfo):void {
			if (traits.indexOf(trait) < 0) {
				traits[traits.length] = trait;
			}
		}

		public function removeTrait(trait:TraitInfo):void {
			var idx:int = traits.indexOf(trait);
			if (idx > -1) {
				traits.splice(idx, 1);
			}
		}

		public function getSlotTraitByName(name:String):SlotOrConstantTrait {
			var slots:Array = slotOrConstantTraits;
			for each (var slot:SlotOrConstantTrait in slots) {
				if (slot.traitMultiname.name == name) {
					return slot;
				}
			}
			return null;
		}

		public function getMethodTraitByName(name:String):MethodTrait {
			var methods:Vector.<TraitInfo> = methodTraits;
			for each (var method:MethodTrait in methods) {
				if (method.traitMultiname.name == name) {
					return method;
				}
			}
			return null;
		}

		public function removeMethodTrait(trait:MethodTrait):void {
			var idx:int = traits.indexOf(trait);
			if (idx > -1) {
				traits.splice(idx, 1);
			}
		}

		public function get slotOrConstantTraits():Array {
			var matchingTraits:Array = [];
			for each (var trait:TraitInfo in traits) {
				if (trait is SlotOrConstantTrait) {
					matchingTraits[matchingTraits.length] = trait;
				}
			}
			return matchingTraits;
		}

		public function getTraitsByKind(traitKind:TraitKind):Vector.<TraitInfo> {
			return traits.filter(function(trait:TraitInfo, index:int, array:Vector.<TraitInfo>):Boolean {
				return (trait.traitKind === traitKind);
			});
		}

		public function get methodTraits():Vector.<TraitInfo> {
			return getTraitsByKind(TraitKind.METHOD);
		}

		public function get methodInfo():Vector.<MethodInfo> {
			var traits:Vector.<TraitInfo> = methodTraits.concat(getterTraits).concat(setterTraits);
			var result:Vector.<MethodInfo> = new Vector.<MethodInfo>();
			for each (var trait:MethodTrait in traits) {
				result[result.length] = trait.traitMethod;
			}
			return result;
		}

		public function get getterTraits():Vector.<TraitInfo> {
			return getTraitsByKind(TraitKind.GETTER);
		}

		public function get setterTraits():Vector.<TraitInfo> {
			return getTraitsByKind(TraitKind.SETTER);
		}

		public function equals(other:Object):Boolean {
			var otherTypeInfo:BaseTypeInfo = other as BaseTypeInfo;
			if (otherTypeInfo != null) {
				if (traits.length != otherTypeInfo.traits.length) {
					return false;
				}
				var len:int = traits.length;
				var i:int;
				var trait:TraitInfo;
				var otherTrait:TraitInfo;
				for (i = 0; i < len; ++i) {
					trait = traits[i];
					otherTrait = otherTypeInfo.traits[i];
					if (!trait.equals(otherTrait)) {
						return false;
					}
				}
				return true;
			}
			return false;
		}

	}
}
