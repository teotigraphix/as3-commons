package org.as3commons.bytecode.util {
	import flash.utils.Dictionary;

	public class StringLookup {

		private static const reservedWords:Array = ['hasOwnProperty', 'isPrototypeOf', 'propertyIsEnumerable', 'setPropertyIsEnumerable', 'toLocaleString', 'toString', 'valueOf', 'prototype', 'constructor'];
		private var _internalLookup:Dictionary = new Dictionary();

		private static const suffix:String = (9999 + Math.floor(Math.random() * 9999)).toString();
		private static const prefix:String = (9999 + Math.floor(Math.random() * 9999)).toString();

		public function StringLookup() {
			super();
		}

		protected function makeValidKey(value:String):String {
			if (reservedWords.indexOf(value) > -1) {
				return prefix + value + suffix;
			}
			return value;
		}

		public function contains(str:String):Boolean {
			var key:String = makeValidKey(str);
			return (_internalLookup[key] != null);
		}

		public function set(str:String, index:int):void {
			var key:String = makeValidKey(str);
			_internalLookup[key] = index;
		}

		public function get(str:String):* {
			var key:String = makeValidKey(str);
			return _internalLookup[key];
		}

		public function remove(str:String):void {
			var key:String = makeValidKey(str);
			delete _internalLookup[key];
		}

	}
}