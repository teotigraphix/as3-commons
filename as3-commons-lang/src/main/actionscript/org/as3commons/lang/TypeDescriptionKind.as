/*
 * Copyright (c) 2007-2013 the original author or authors
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
package org.as3commons.lang {
import flash.utils.Dictionary;

public final class TypeDescriptionKind {

	private static var _enumCreated:Boolean = false;
	private static const _items:Dictionary = new Dictionary();

	public static const JSON:TypeDescriptionKind = new TypeDescriptionKind(JSON_NAME);
	public static const XML:TypeDescriptionKind = new TypeDescriptionKind(XML_NAME);

	private static const JSON_NAME:String = "JSONTypeDescription";
	private static const XML_NAME:String = "XMLTypeDescription";

	private var _value:String;

	{
		_enumCreated = true;
	}

	public function TypeDescriptionKind(value:String) {
		Assert.state(!_enumCreated, "TypeDescriptionKind enumeration has already been created");
		_value = value;
		_items[_value] = this;
	}

	public function get value():String {
		return _value;
	}

	public static function fromValue(value:String):TypeDescriptionKind {
		return _items[value] as TypeDescriptionKind;
	}

	public function toString():String {
		return StringUtils.substitute("[TypeDescriptionKind(value='{0}')]", value);
	}
}
}
