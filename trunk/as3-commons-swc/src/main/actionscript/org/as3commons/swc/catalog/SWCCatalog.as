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
package org.as3commons.swc.catalog {
	import org.as3commons.swc.SWCComponent;
	import org.as3commons.swc.SWCFile;
	import org.as3commons.swc.SWCLibrary;
	import org.as3commons.swc.SWCVersions;

	public class SWCCatalog {

		private var _versions:SWCVersions;
		private var _components:Vector.<SWCComponent>;
		private var _libraries:Vector.<SWCLibrary>;
		private var _files:Vector.<SWCFile>;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWCCatalog(versions:SWCVersions, components:Vector.<SWCComponent>, libraries:Vector.<SWCLibrary>, files:Vector.<SWCFile>) {
			_versions = versions;
			_components = components;
			_libraries = libraries;
			_files = files;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get versions():SWCVersions {
			return _versions;
		}

		public function get components():Vector.<SWCComponent> {
			return _components;
		}

		public function get libraries():Vector.<SWCLibrary> {
			return _libraries;
		}

		public function get files():Vector.<SWCFile> {
			return _files;
		}
	}
}
