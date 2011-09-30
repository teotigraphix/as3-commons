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
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.*;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.lang.Assert;

	public class MetadataBuilder implements IMetadataBuilder {

		private var _argLookup:Dictionary;
		private var _metadata:Metadata;
		private var _name:String = "";
		private var _arguments:Array = [];

		public function MetadataBuilder() {
			super();
			_argLookup = new Dictionary();
		}

		as3commons_bytecode function setMetadata(metadata:Metadata):void {
			Assert.notNull(metadata, "metadata argument must not be null");
			_metadata = metadata;
			_name = metadata.name;
			for (var name:String in metadata.properties) {
				var arg:MetadataArgument = defineArgument(name);
				arg.value = metadata.properties[name];
			}
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

		public function set arguments(value:Array):void {
			_arguments = value;
		}

		public function defineArgument(name:String=null):MetadataArgument {
			_arguments ||= [];
			var ma:MetadataArgument;
			if ((name == null) || (_argLookup[name] == null)) {
				ma = new MetadataArgument();
				_arguments[_arguments.length] = ma;
				ma.key = name;
				if (name != null) {
					_argLookup[name] = ma;
				}
			} else {
				ma = _argLookup[name] as MetadataArgument;
			}
			return ma;
		}

		public function build():Metadata {
			var md:Metadata = (_metadata != null) ? _metadata : new Metadata();
			md.name = _name;
			for each (var ma:MetadataArgument in _arguments) {
				md.properties[ma.key] = ma.value;
			}
			return md;
		}
	}
}
