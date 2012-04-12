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
