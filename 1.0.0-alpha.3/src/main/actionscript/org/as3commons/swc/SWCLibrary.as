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
	public class SWCLibrary {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWCLibrary(path:String, scripts:Vector.<SWCScript>, metadata:Vector.<String>) {
			_path = path;
			_scripts = scripts;
			_metadata = metadata;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		private var _path:String;

		public function get path():String {
			return _path;
		}

		public function set path(value:String):void {
			_path = value;
		}

		// ----------------------------

		private var _scripts:Vector.<SWCScript> = new Vector.<SWCScript>();

		public function get scripts():Vector.<SWCScript> {
			return _scripts;
		}

		// ----------------------------

		private var _metadata:Vector.<String> = new Vector.<String>();

		public function get metadata():Vector.<String> {
			return _metadata;
		}

		// ----------------------------

		private var _classNames:Vector.<String>;

		public function get classNames():Vector.<String> {
			if (!_classNames) {
				_classNames = createClassNamesVector();
			}
			return _classNames;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function createClassNamesVector():Vector.<String> {
			var result:Vector.<String> = new Vector.<String>(_scripts.length, true);
			var numScripts:uint = _scripts.length;
			for (var i:int = 0; i < numScripts; i++) {
				_classNames[i] = _scripts[i].name;
			}
			return result;
		}

	}
}
