/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.reflect {
	import org.as3commons.lang.HashArray;
	import org.as3commons.reflect.as3commons_reflect;

	use namespace as3commons_reflect;

	/**
	 * Basic implementation of the IMetadataContainer interface.
	 *
	 * @author Christophe Herreman
	 */
	public class MetadataContainer implements IMetadataContainer {
		private static const METADATA_NAME_PROPERTY:String = 'name';

		// -------------------------------------------------------------------------
		//
		//  Constructor
		//
		// -------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function MetadataContainer(metadata:HashArray=null) {
			_metadata = (metadata == null ? new HashArray(METADATA_NAME_PROPERTY, true) : metadata);
		}

		// -------------------------------------------------------------------------
		//
		//  Properties
		//
		// -------------------------------------------------------------------------

		// ----------------------------
		// metadata
		// ----------------------------

		private var _metadata:HashArray;

		/**
		 * @inheritDoc
		 */
		public function get metadata():Array {
			return _metadata.getArray();
		}

		// -------------------------------------------------------------------------
		//
		//  Methods
		//
		// -------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function addMetadata(metadata:Metadata):void {
			_metadata.push(metadata);
		}

		/**
		 * @inheritDoc
		 */
		public function getMetadata(key:String):Array {
			var result:* = _metadata.get(key.toLowerCase());
			return (result is Array) ? result : (result != null) ? [result] : result;
		}

		/**
		 * @inheritDoc
		 */
		public function hasMetadata(key:String):Boolean {
			return (getMetadata(key.toLowerCase()) != null);
		}

		/**
		 * @inheritDoc
		 */
		public function hasExactMetadata(otherMetadata:Metadata):Boolean {
			var metadatas:Array = getMetadata(otherMetadata.name);
			var i:int;
			var len:int = metadatas.length;
			var metadata:Metadata;
			for (i = 0; i < len; ++i) {
				metadata = metadatas[i];
				if (metadata.equals(otherMetadata)) {
					return true;
				}
			}
			return false;
		}
	}

}
