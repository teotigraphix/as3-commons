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
package org.as3commons.bytecode.abc.enum {
	import org.as3commons.lang.Assert;

	/**
	 * as3commons-bytecode representation of possible values for the kinds of trait attributes in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Trait attributes" in the AVM Spec (page 31)
	 */
	public final class TraitAttributes {

		private static var _enumCreated:Boolean = false;
		private static const _TYPES:Array = [];

		public static const FINAL:TraitAttributes = new TraitAttributes(0x1, "final");
		public static const OVERRIDE:TraitAttributes = new TraitAttributes(0x2, "override");
		public static const METADATA:TraitAttributes = new TraitAttributes(0x4, "metadata");

		private var _bitMask:uint;
		private var _description:String;

		{
			_enumCreated = true;
		}

		public function TraitAttributes(bitMaskValue:uint, descriptionValue:String) {
			CONFIG::debug {
				Assert.state((!_enumCreated), "TraitAttributes enum has already been created");
			}
			_bitMask = bitMaskValue;
			_description = descriptionValue;
			_TYPES[_TYPES.length] = this;
		}

		public static function determineAttributes(traitAttributeValue:int):TraitAttributes {
			var matchingAttributes:TraitAttributes;
			for each (var attributes:TraitAttributes in _TYPES) {
				if ((attributes.bitMask << 4) & traitAttributeValue) {
					matchingAttributes = attributes;
					break;
				}
			}

			return matchingAttributes;
		}

		public function get bitMask():uint {
			return _bitMask;
		}

		public function get description():String {
			return _description;
		}
	}
}