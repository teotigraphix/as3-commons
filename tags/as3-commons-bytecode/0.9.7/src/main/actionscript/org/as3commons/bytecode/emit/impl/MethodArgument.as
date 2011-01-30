/*
 * Copyright 2007-2011 the original author or authors.
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
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.util.BuildUtil;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;

	public class MethodArgument {
		private var _name:String;
		private var _isOptional:Boolean;
		private var _type:String;
		private var _defaultValue:Object;
		private var _argument:Argument;

		public function MethodArgument() {
			super();
		}

		as3commons_bytecode function setArgument(argument:Argument):void {
			Assert.notNull(argument, "argument argument must not be null");
			_argument = argument;
			_name = argument.name;
			_isOptional = argument.isOptional;
			_type = argument.type.fullName;
			_defaultValue = argument.defaultValue;
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

		public function get defaultValue():Object {
			return _defaultValue;
		}

		public function set defaultValue(value:Object):void {
			_defaultValue = value;
		}

		public function build():Argument {
			var argument:Argument = (_argument != null) ? _argument : new Argument();
			var qname:QualifiedName = MultinameUtil.toQualifiedName(_type);
			if ((argument.type == null) || (argument.type.fullName != qname.fullName)) {
				argument.type = qname;
			}
			argument.isOptional = _isOptional;
			argument.defaultValue = _defaultValue;
			argument.kind = BuildUtil.defaultValueToConstantKind(_defaultValue);
			return argument;
		}
	}
}