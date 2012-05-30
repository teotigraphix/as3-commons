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

	public class SWCVersions {

		private var _libVersion:String;
		private var _flexVersion:String;
		private var _flexMinimumSupportedVersion:String;
		private var _flexBuild:String;
		private var _flashVersion:String;
		private var _flashBuild:String;
		private var _flashPlatform:String;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWCVersions(libVersion:String, flexVersion:String, flexMinimumSupportedVersion:String, flexBuild:String, flashVersion:String, flashBuild:String, flashPlatform:String) {
			_libVersion = libVersion;
			_flexVersion = flexVersion;
			_flexMinimumSupportedVersion = flexMinimumSupportedVersion;
			_flexBuild = flexBuild;
			_flashVersion = flashVersion;
			_flashBuild = flashBuild;
			_flashPlatform = flashPlatform;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

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
