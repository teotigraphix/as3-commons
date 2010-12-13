package org.as3commons.reflect {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public final class TypeProviderKind {

		private static var _enumCreated:Boolean = false;
		private static const _items:Dictionary = new Dictionary();

		public static const JSON:TypeProviderKind = new TypeProviderKind(JSON_NAME);
		public static const XML:TypeProviderKind = new TypeProviderKind(XML_NAME);

		private static const JSON_NAME:String = "JSONTypeProvider";
		private static const XML_NAME:String = "XMLTypeProvider";

		private var _value:String;

		{
			_enumCreated = true;
		}

		public function TypeProviderKind(value:String) {
			Assert.state(!_enumCreated, "TypeProviderKind enumeration has already been created");
			_value = value;
			_items[_value] = this;
		}

		public function get value():String {
			return _value;
		}

		public static function fromValue(value:String):TypeProviderKind {
			return _items[value] as TypeProviderKind;
		}

		public function toString():String {
			return StringUtils.substitute("[TypeProviderKind(value='{0}')]", value);
		}
	}
}