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
package org.as3commons.bytecode.emit.impl {
public class MethodArgument {
	private var _name:String;
	private var _isOptional:Boolean;
	private var _type:String;
	private var _defaultValue:String;

	public function MethodArgument() {
		super();
	}

	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
	}

	public function get isOptional():Boolean {
		return _isOptional;
	}

	public function set isOptional(value:Boolean):void {
		_isOptional = value;
	}

	public function get type():String {
		return _type;
	}

	public function set type(value:String):void {
		_type = value;
	}

	public function get defaultValue():String {
		return _defaultValue;
	}

	public function set defaultValue(value:String):void {
		_defaultValue = value;
	}
}
}