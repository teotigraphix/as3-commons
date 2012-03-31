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
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.util.CloneUtils;

	/**
	 * Anything that can have metadata attached to it uses <code>Annotatable</code> as a base class.
	 */
	public class Annotatable implements ICloneable {

		protected static const NOT_IMPLEMENTED_ERROR:String = "Not implemented in base class";

		private var _metadata:Vector.<Metadata>;

		public function Annotatable() {
			super();
			_metadata = new Vector.<Metadata>();
		}

		/**
		 * Adds a <code>Metadata</code> entry to this object instance.
		 */
		public function addMetadata(metadata:Metadata):void {
			if (_metadata.indexOf(metadata) < 0) {
				_metadata[_metadata.length] = metadata;
			}
		}

		/**
		 * Adds a <code>Metadata</code> entry to this object instance.
		 */
		public function addMetadataList(metadataList:Vector.<Metadata>):void {
			for each (var metadata:Metadata in metadataList) {
				addMetadata(metadata);
			}
		}

		/**
		 * Gets all the metadata entries for this object instance.
		 */
		public function get metadata():Vector.<Metadata> {
			return _metadata;
		}

		public function clone():* {
			throw new IllegalOperationError(NOT_IMPLEMENTED_ERROR);
		}

		protected function populateClone(annotatable:Annotatable):void {
			annotatable.addMetadataList(AbcFileUtil.cloneVector(metadata));
		}
	}
}
