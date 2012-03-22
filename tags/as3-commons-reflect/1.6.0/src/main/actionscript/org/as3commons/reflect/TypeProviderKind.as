/*
* Copyright (c) 2007-2009-2010 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
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
