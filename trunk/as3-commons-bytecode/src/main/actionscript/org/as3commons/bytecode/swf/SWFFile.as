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
package org.as3commons.bytecode.swf {
	import flash.geom.Rectangle;

	import org.as3commons.bytecode.tags.ISWFTag;

	public class SWFFile {

		private var _signature:String;
		private var _version:uint;
		private var _fileLength:uint;
		private var _frameSize:Rectangle;
		private var _frameRate:uint;
		private var _frameCount:uint;
		private var _tags:Array = [];

		public function SWFFile() {
			super();
		}

		public function get tags():Array {
			return _tags;
		}

		public function get frameSize():Rectangle {
			return _frameSize;
		}

		public function set frameSize(value:Rectangle):void {
			_frameSize = value;
		}

		public function get frameRate():uint {
			return _frameRate;
		}

		public function set frameRate(value:uint):void {
			_frameRate = value;
		}

		public function get frameCount():uint {
			return _frameCount;
		}

		public function set frameCount(value:uint):void {
			_frameCount = value;
		}

		public function get signature():String {
			return _signature;
		}

		public function set signature(value:String):void {
			_signature = value;
		}

		public function get version():uint {
			return _version;
		}

		public function set version(value:uint):void {
			_version = value;
		}

		public function get fileLength():uint {
			return _fileLength;
		}

		public function set fileLength(value:uint):void {
			_fileLength = value;
		}

		public function getTagsByType(tagClass:Class):Array {
			var result:Array = [];
			for each (var tag:ISWFTag in _tags) {
				if (tag is tagClass) {
					result[result.length] = tag;
				}
			}
			return result;
		}

	}
}