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
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of possible values for the kinds of traits in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Summary of trait types" in the AVM Spec (page 29)
	 */
	public final class TraitKind {
		private static var _enumCreated:Boolean = false;
		private static const _TYPES:Dictionary = new Dictionary();

		public static const SLOT:TraitKind = new TraitKind(0, "slot");
		public static const METHOD:TraitKind = new TraitKind(1, "method");
		public static const GETTER:TraitKind = new TraitKind(2, "getter");
		public static const SETTER:TraitKind = new TraitKind(3, "setter");
		public static const CLASS:TraitKind = new TraitKind(4, "class");
		public static const FUNCTION:TraitKind = new TraitKind(5, "function");
		public static const CONST:TraitKind = new TraitKind(6, "const");
		private static const UPPER_FOUR:uint = 0xF;

		private var _value:uint;
		private var _description:String;
		private var _associatedClass:Class;

		{
			_enumCreated = true;
		}

		public function TraitKind(bitValue:uint, descriptionValue:String) {
			CONFIG::debug {
				Assert.state((!_enumCreated), "TraitKind enum has already been created");
			}
			_value = bitValue;
			_description = descriptionValue;
			_TYPES[_value] = this;
		}

		public static function determineKind(traitInfoBitMask:uint):TraitKind {
			// The lower four bits determine the trait kind (AVM2 overview page 29). Since the upper four
			// bits are irrelevant for this comparison, we bitwise AND the given value with 0xF (15 or 00001111) to get
			// rid of the upper four bits. After this is done we can perform strict equality to figure out the
			// trait kind.
			var lowerFourBitsOfBitMask:int = (traitInfoBitMask & UPPER_FOUR);
			var matchingKind:TraitKind = _TYPES[lowerFourBitsOfBitMask];

			if (!matchingKind) {
				throw new Error("No match for kind: " + traitInfoBitMask);
			}

			return matchingKind;
		}

		public function get bitMask():uint {
			return _value;
		}

		public function get description():String {
			return _description;
		}

		public function toString():String {
			return StringUtils.substitute("TraitKind[bitMask={0},description={1}]", _value, _description);
		}
	}
}