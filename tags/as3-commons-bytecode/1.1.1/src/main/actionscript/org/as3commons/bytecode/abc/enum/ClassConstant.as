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

	/**
	 * as3commons-bytecode representation of possible values for the instance <code>flags</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "flags" in the AVM Spec (page 28)
	 */
	public final class ClassConstant extends BaseEnum {

		private static const _items:Dictionary = new Dictionary();

		private static var _enumCreated:Boolean = false;

		public static const SEALED:ClassConstant = new ClassConstant(0x01, "sealed");
		public static const FINAL:ClassConstant = new ClassConstant(0x02, "final");
		public static const INTERFACE:ClassConstant = new ClassConstant(0x04, "interface");
		public static const PROTECTED_NAMESPACE:ClassConstant = new ClassConstant(0x08, "protected namespace");

		private var _description:String;

		{
			_enumCreated = true;
		}

		public function ClassConstant(bitMaskValue:uint, descriptionValue:String) {
			CONFIG::debug {
				Assert.state((false == _enumCreated), "The ClassConstant enum has already been created.");
			}
			super(bitMaskValue);
			_items[bitMaskValue] = this;
			_description = descriptionValue;
		}

		public function present(bitMask:uint):Boolean {
			return Boolean(this.bitMask & bitMask);
		}

		public function get bitMask():uint {
			return uint(value);
		}

		public function get description():String {
			return _description;
		}

		override public function toString():String {
			return "";
		}

		public static function fromValue(bitMaskValue:uint):ClassConstant {
			var classConstant:ClassConstant = _items[bitMaskValue];
			if (classConstant == null) {
				throw new Error("Unable to match ClassConstant to " + classConstant);
			}
			return classConstant;
		}

	}
}