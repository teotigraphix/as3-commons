package org.as3commons.swc {
	public class SWCVersions {
		private var _libVersion:String;
		private var _flexVersion:String;
		private var _flexMinimumSupportedVersion:String;
		private var _flexBuild:String;
		private var _flashVersion:String;
		private var _flashBuild:String;
		private var _flashPlatform:String;

		public function SWCVersions(libVersion:String, flexVersion:String, flexMinimumSupportedVersion:String, flexBuild:String, flashVersion:String, flashBuild:String, flashPlatform:String) {
			_libVersion = libVersion;
			_flexVersion = flexVersion;
			_flexMinimumSupportedVersion = flexMinimumSupportedVersion;
			_flexBuild = flexBuild;
			_flashVersion = flashVersion;
			_flashBuild = flashBuild;
			_flashPlatform = flashPlatform;
		}


		public function get libVersion():String {
			return _libVersion;
		}

		public function get flexVersion():String {
			return _flexVersion;
		}

		public function get flexMinimumSupportedVersion():String {
			return _flexMinimumSupportedVersion;
		}

		public function get flexBuild():String {
			return _flexBuild;
		}

		public function get flashVersion():String {
			return _flashVersion;
		}

		public function get flashBuild():String {
			return _flashBuild;
		}

		public function get flashPlatform():String {
			return _flashPlatform;
		}
	}
}
