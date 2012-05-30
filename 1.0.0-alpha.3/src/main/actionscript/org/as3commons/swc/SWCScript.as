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

	public class SWCScript {

		private var _name:String;
		private var _mod:Number;
		private var _signatureChecksum:Number;
		private var _dependencies:Vector.<SWCScriptDependency>;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWCScript(name:String, mod:Number, signatureChecksum:Number, dependencies:Vector.<SWCScriptDependency>) {
			_name = name;
			_mod = mod;
			_signatureChecksum = signatureChecksum;
			_dependencies = dependencies;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get name():String {
			return _name;
		}

		public function get mod():Number {
			return _mod;
		}

		public function get signatureChecksum():Number {
			return _signatureChecksum;
		}

		public function get dependencies():Vector.<SWCScriptDependency> {
			return _dependencies;
		}
	}
}
