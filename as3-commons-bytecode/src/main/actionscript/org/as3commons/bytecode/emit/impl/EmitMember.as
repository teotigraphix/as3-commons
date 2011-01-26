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
	import org.as3commons.bytecode.emit.IEmitMember;
	import org.as3commons.bytecode.emit.IMetadataBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;

	public class EmitMember extends BaseBuilder implements IEmitMember {

		private var _metadata:Array = [];
		private var _isOverride:Boolean;
		private var _isFinal:Boolean;
		private var _isStatic:Boolean;

		public function EmitMember(name:String = null, visibility:MemberVisibility = null, nameSpace:String = null) {
			super(name, visibility, nameSpace);
		}

		public function get isOverride():Boolean {
			return _isOverride;
		}

		public function set isOverride(value:Boolean):void {
			_isOverride = value;
		}

		public function get isFinal():Boolean {
			return _isFinal;
		}

		public function set isFinal(value:Boolean):void {
			_isFinal = value;
		}

		public function get isStatic():Boolean {
			return _isStatic;
		}

		public function set isStatic(value:Boolean):void {
			_isStatic = value;
		}

		public function get metadata():Array {
			return _metadata;
		}

		public function set metadata(value:Array):void {
			_metadata = value;
		}

		public function defineMetadata(name:String = null, arguments:Array = null):IMetadataBuilder {
			var mdb:MetadataBuilder = new MetadataBuilder();
			mdb.name = name;
			mdb.arguments = arguments;
			_metadata[_metadata.length] = mdb;
			return mdb;
		}

		protected function buildMetadata():Array {
			var result:Array = [];
			for each (var mdb:MetadataBuilder in _metadata) {
				result[result.length] = mdb.build();
			}
			return result;
		}

	}
}