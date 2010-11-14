package org.as3commons.bytecode.util {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;

	public final class MethodBodyExtractionMethod {

		private static var _enumCreated:Boolean = false;
		private static const _items:Dictionary = new Dictionary();

		public static const PARSE:MethodBodyExtractionMethod = new MethodBodyExtractionMethod(PARSE_VALUE);
		public static const SKIP:MethodBodyExtractionMethod = new MethodBodyExtractionMethod(SKIP_VALUE);
		public static const BYTEARRAY:MethodBodyExtractionMethod = new MethodBodyExtractionMethod(BYTEARRAY_VALUE);

		private static const PARSE_VALUE:String = "parseMethodBody";
		private static const SKIP_VALUE:String = "skipMethodBody";
		private static const BYTEARRAY_VALUE:String = "byteArrayMethodBody";

		{
			_enumCreated = true;
		}

		private var _value:String;

		public function MethodBodyExtractionMethod(val:String) {
			Assert.state(!_enumCreated, "The MethodBodyExtractionMethod enumeration has already been created");
			Assert.hasText(val, "val argument must have text");
			_value = val;
			_items[_value] = this;
		}

		public function get value():String {
			return _value;
		}

		public static function fromValue(val:String):MethodBodyExtractionMethod {
			return _items[val] as MethodBodyExtractionMethod;
		}

		public function toString():String {
			return "MethodBodyExtractionMethod[_value:\"" + _value + "\"]";
		}

	}
}