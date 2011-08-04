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

	/**
	 * as3commons-bytecode representation of possible values for the flags passed to compiler describing state required by the
	 * opcodes within a particular method body, confirming to the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "flags" in the AVM Spec (page 25)
	 */
	public final class MethodFlag {
		public static const NEED_ARGUMENTS:MethodFlag = new MethodFlag(0x01, "need arguments");
		public static const NEED_ACTIVATION:MethodFlag = new MethodFlag(0x02, "need activation");
		public static const NEED_REST:MethodFlag = new MethodFlag(0x04, "need rest");
		public static const HAS_OPTIONAL:MethodFlag = new MethodFlag(0x08, "has optional");
		public static const SET_DXNS:MethodFlag = new MethodFlag(0x40, "set dxns");
		public static const HAS_PARAM_NAMES:MethodFlag = new MethodFlag(0x80, "has param names");

		// These last two were present in some code ported from Tamarin, but are not documented in the AVM2 spec. Thought I'd add them just in case 
		public static const IGNORE_REST:MethodFlag = new MethodFlag(0x10, "ignore rest");
		public static const NATIVE:MethodFlag = new MethodFlag(0x20, "native");

		private var _value:uint;
		private var _description:String;

		public function MethodFlag(flagValue:uint, flagDescription:String) {
			_value = flagValue;
			_description = flagDescription;
		}

		public static function flagPresent(flagsValueFromMethodInfo:uint, flagBeingCheckedFor:MethodFlag):Boolean {
			return Boolean(flagsValueFromMethodInfo & flagBeingCheckedFor.value);
		}

		public static function addFlag(flagsValueFromMethodInfo:uint, flagToAdd:MethodFlag):uint {
			return (!flagPresent(flagsValueFromMethodInfo, flagToAdd)) ? (flagsValueFromMethodInfo |= flagToAdd.value) : flagsValueFromMethodInfo;
		}

		public static function removeFlag(flagsValueFromMethodInfo:uint, flagToAdd:MethodFlag):uint {
			return (flagPresent(flagsValueFromMethodInfo, flagToAdd)) ? (flagsValueFromMethodInfo &= flagToAdd.value) : flagsValueFromMethodInfo;
		}

		public function get value():uint {
			return _value;
		}

		public function get description():String {
			return _description;
		}
	}
}