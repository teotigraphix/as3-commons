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

	public class BaseTypeInfo {

		public var traits:Array;

		public function BaseTypeInfo() {
			super();
			traits = [];
		}

		public function addTrait(trait:TraitInfo):void {
			if (traits.indexOf(trait) < 0) {
				traits[traits.length] = trait;
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

		public function getTraitsByKind(traitKind:TraitKind):Array {
			return traits.filter(function(trait:TraitInfo, index:int, array:Array):Boolean {
				return (trait.traitKind == traitKind);
			});
		}

		public function get methodTraits():Array {
			return getTraitsByKind(TraitKind.METHOD);
		}

		public function get methodInfo():Array {
			var traits:Array = methodTraits.concat(getterTraits).concat(setterTraits);
			var result:Array = [];
			for each (var trait:MethodTrait in traits) {
				result[result.length] = trait.traitMethod;
			}
			return result;
		}

		public function get getterTraits():Array {
			return getTraitsByKind(TraitKind.GETTER);
		}

		public function get setterTraits():Array {
			return getTraitsByKind(TraitKind.SETTER);
		}

	}
}