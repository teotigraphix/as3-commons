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
