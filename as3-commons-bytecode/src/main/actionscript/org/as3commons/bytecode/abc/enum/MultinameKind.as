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
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of possible values for the kinds of multinames in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Multiname" in the AVM Spec (page 23)
	 */
	public final class MultinameKind {
		private static var _enumCreated:Boolean = false;
		private static const _TYPES:Dictionary = new Dictionary();


		public static const QNAME:MultinameKind = new MultinameKind(0x07, "QName");
		public static const QNAME_A:MultinameKind = new MultinameKind(0x0D, "QName_A");
		public static const RTQNAME:MultinameKind = new MultinameKind(0x0F, "RTQName");
		public static const RTQNAME_A:MultinameKind = new MultinameKind(0x10, "RTQName_A");
		public static const RTQNAME_L:MultinameKind = new MultinameKind(0x11, "RTQName_L");
		public static const RTQNAME_LA:MultinameKind = new MultinameKind(0x12, "RTQName_LA");
		public static const MULTINAME:MultinameKind = new MultinameKind(0x09, "Multiname");
		public static const MULTINAME_A:MultinameKind = new MultinameKind(0x0E, "Multiname_A");
		public static const MULTINAME_L:MultinameKind = new MultinameKind(0x1B, "Multiname_L");
		public static const MULTINAME_LA:MultinameKind = new MultinameKind(0x1C, "Multiname_LA");
		public static const GENERIC:MultinameKind = new MultinameKind(0x1D, "Generic");

		private var _byteValue:int;
		private var _description:String;

		{
			_enumCreated = true;
		}

		public function MultinameKind(byteValue:int, descriptionValue:String) {
			CONFIG::debug {
				Assert.state((!_enumCreated), "MultinameKind enum has already been created");
			}
			_byteValue = byteValue;
			_description = descriptionValue;
			_TYPES[_byteValue] = this;
		}

		public function get byteValue():int {
			return _byteValue;
		}

		public function get description():String {
			return _description;
		}
		
		public function toString():String {
			return StringUtils.substitute("MultinameKind[description={0}]",_description);
		}

		public static function determineKind(kind:int):MultinameKind {
			var result:MultinameKind = _TYPES[kind];
			if (result) {
				return result;
			} else {
				throw new Error("No match for MultinameKind: " + kind);
			}
		}
	}
}