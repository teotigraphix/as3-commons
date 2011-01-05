/*
* Copyright 2007-2010 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.bytecode.emit.asm {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public final class TokenKind {

		private static var _enumCreated:Boolean = false;
		private static const _items:Dictionary = new Dictionary();

		public static const INSTRUCTION:TokenKind = new TokenKind(INSTRUCTION_NAME);
		public static const LABEL:TokenKind = new TokenKind(LABEL_NAME);
		public static const OPERAND:TokenKind = new TokenKind(OPERAND_NAME);

		private static const INSTRUCTION_NAME:String = "instruction";
		private static const LABEL_NAME:String = "label";
		private static const OPERAND_NAME:String = "operand";

		private static const TOSTRING:String = "TokenKind[_value:\"{0}\"]";
		private static const CREATED_ERROR:String = "TokenKind enumeration has already been created";

		private var _value:String;

		public function get value():String {
			return _value;
		}

		{
			_enumCreated = true;
		}

		public function TokenKind(v:String) {
			Assert.state(!_enumCreated, CREATED_ERROR);
			_value = v;
			_items[_value] = this;
		}

		public static function determineKind(v:String):TokenKind {
			return _items[v] as TokenKind;
		}

		public function toString():String {
			return StringUtils.substitute(TOSTRING, _value);
		}


	}
}