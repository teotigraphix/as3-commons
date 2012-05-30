/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.swc {
	import flash.utils.ByteArray;

	import org.as3commons.zip.ZipFile;

	public class SWCFile {

		private var _path:String;
		private var _mod:Number;
		private var _zipFile:ZipFile;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWCFile(path:String, mod:Number) {
			_path = path;
			_mod = mod;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get path():String {
			return _path;
		}

		public function get mod():Number {
			return _mod;
		}

		public function get content():ByteArray {
			return _zipFile.content;
		}

		as3commons_swc function set zipFile(value:ZipFile):void {
			_zipFile = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function getContentAsString(charset:String = "utf-8"):String {
			return _zipFile.getContentAsString(false, charset);
		}

	}
}
