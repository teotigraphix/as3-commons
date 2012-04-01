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
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of <code>Trait_Method</code> in the ABC file format. Also represents <code>Trait_Getter</code> and
	 * <code>Trait_Setter</code> (differentiated in the spec by the <code>kind</code> of the trait.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Method, getter, and setter traits" in the AVM Spec (page 31)
	 */
	public final class MethodTrait extends TraitInfo {

		public var dispositionId:int = 0;
		public var traitMethod:MethodInfo;
		public var isStatic:Boolean;

		public function MethodTrait() {
			super();
		}

		public function get isGetter():Boolean {
			return (traitKind == TraitKind.GETTER);
		}

		public function get isSetter():Boolean {
			return (traitKind == TraitKind.SETTER);
		}

		public function toString():String {
			return StringUtils.substitute("MethodTrait[name={0}, override={1}, metadata={2}, dispositionId={3}, method={4}]", traitMultiname, isOverride, metadata, dispositionId, traitMethod);
		}

		override public function equals(other:Object):Boolean {
			var result:Boolean = super.equals(other);
			if (result) {
				var otherTrait:MethodTrait = other as MethodTrait;
				if (otherTrait != null) {
					if (dispositionId != otherTrait.dispositionId) {
						return false;
					}
					if (!traitMethod.equals(otherTrait.traitMethod)) {
						return false;
					}
					if (isStatic != otherTrait.isStatic) {
						return false;
					}
				} else {
					return false;
				}
				return true;
			}
			return result;
		}
	}
}
