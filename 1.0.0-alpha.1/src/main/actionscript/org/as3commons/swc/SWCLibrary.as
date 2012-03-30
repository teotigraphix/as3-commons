package org.as3commons.swc {
	public class SWCLibrary {

		public function SWCLibrary() {
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

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function addClassName(name:String):void {
			_classNames.push(name);
		}
	}
}
