package org.as3commons.swc {
	public class SWCLibrary {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWCLibrary(path:String, classNames:Vector.<String>, metadata:Vector.<String>) {
			_path = path;
			_classNames = classNames;
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

		private var _classNames:Vector.<String> = new Vector.<String>();

		public function get classNames():Vector.<String> {
			return _classNames;
		}

		// ----------------------------

		private var _metadata:Vector.<String> = new Vector.<String>();

		public function get metadata():Vector.<String> {
			return _metadata;
		}

	}
}
