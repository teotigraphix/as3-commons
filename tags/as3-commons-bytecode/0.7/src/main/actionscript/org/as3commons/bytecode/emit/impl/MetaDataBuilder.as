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
	import org.as3commons.bytecode.emit.*;
	import org.as3commons.bytecode.typeinfo.Metadata;

	public class MetaDataBuilder implements IMetaDataBuilder {

		private var _name:String = "";
		private var _arguments:Array = [];

		public function MetaDataBuilder() {
			super();
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get arguments():Array {
			return _arguments;
		}

		public function set argument(value:Array):void {
			_arguments = value;
		}

		public function defineArgument():MetaDataArgument {
			var ma:MetaDataArgument = new MetaDataArgument();
			_arguments[_arguments.length] = ma;
			return ma;
		}

		public function build():Metadata {
			var md:Metadata = new Metadata();
			md.name = _name;
			for each (var ma:MetaDataArgument in _arguments) {
				md.properties[ma.key] = ma.value;
			}
			return md;
		}
	}
}