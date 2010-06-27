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

	import org.as3commons.bytecode.util.AbcSpec;

	/**
	 * Loom representation of possible values for the kinds of multinames in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Multiname" in the AVM Spec (page 23)
	 */
	public class MultinameKind {
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

		public function MultinameKind(byteValue:int, descriptionValue:String) {
			_byteValue = byteValue;
			_description = descriptionValue;
		}

		public function get byteValue():int {
			return _byteValue;
		}

		public function get description():String {
			return _description;
		}

		public static function determineKind(kind:int):MultinameKind {
			switch (kind) {
				case MultinameKind.QNAME._byteValue:
					return MultinameKind.QNAME;

				case MultinameKind.QNAME_A._byteValue:
					return MultinameKind.QNAME_A;

				case MultinameKind.RTQNAME._byteValue:
					return MultinameKind.RTQNAME;

				case MultinameKind.RTQNAME_A._byteValue:
					return MultinameKind.RTQNAME_A;

				case MultinameKind.RTQNAME_L._byteValue:
					return MultinameKind.RTQNAME_L;

				case MultinameKind.RTQNAME_LA._byteValue:
					return MultinameKind.RTQNAME_LA;

				case MultinameKind.MULTINAME._byteValue:
					return MultinameKind.MULTINAME;

				case MultinameKind.MULTINAME_A._byteValue:
					return MultinameKind.MULTINAME_A;

				case MultinameKind.MULTINAME_L._byteValue:
					return MultinameKind.MULTINAME_L;

				case MultinameKind.MULTINAME_LA._byteValue:
					return MultinameKind.MULTINAME_LA;

				case MultinameKind.GENERIC._byteValue:
					return MultinameKind.GENERIC;
			}

			throw new Error("No match for MultinameKind: " + kind);

			// This is to force the compiler to let me compile... technically we should never get to this return statement
			return null;
		}
	}
}