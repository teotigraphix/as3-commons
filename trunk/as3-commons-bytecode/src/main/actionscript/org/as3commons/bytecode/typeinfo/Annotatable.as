/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.typeinfo {

	/**
	 * Anything that can have metadata attached to it uses <code>Annotatable</code> as a base class.
	 */
	public class Annotatable {
		private var _metadata:Array;

		public function Annotatable() {
			_metadata = [];
		}

		/**
		 * Adds a <code>Metadata</code> entry to this object instance.
		 */
		public function addMetadata(metadata:Metadata):void {
			_metadata.push(metadata);
		}

		/**
		 * Gets all the metadata entries for this object instance.
		 */
		public function get metadata():Array {
			return _metadata;
		}
	}
}