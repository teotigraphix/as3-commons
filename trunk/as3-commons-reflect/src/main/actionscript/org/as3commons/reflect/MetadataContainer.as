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
	 * Basic implementation of the IMetaDataContainer interface.
	 *
	 * @author Christophe Herreman
	 */
	public class MetaDataContainer implements IMetaDataContainer {
		private static const METADATA_NAME_PROPERTY:String = 'name';

		// -------------------------------------------------------------------------
		//
		//  Constructor
		//
		// -------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function MetaDataContainer(metaData:HashArray = null) {
			_metaData = (metaData == null ? new HashArray(METADATA_NAME_PROPERTY, true) : metaData);
		}

		// -------------------------------------------------------------------------
		//
		//  Properties
		//
		// -------------------------------------------------------------------------

		// ----------------------------
		// metaData
		// ----------------------------

		private var _metaData:HashArray;

		/**
		 * @inheritDoc
		 */
		public function get metaData():Array {
			return _metaData.getArray();
		}

		// -------------------------------------------------------------------------
		//
		//  Methods
		//
		// -------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function addMetaData(metaData:MetaData):void {
			_metaData.push(metaData);
		}

		/**
		 * @inheritDoc
		 */
		public function getMetaData(key:String):Array {
			var result:* = _metaData.get(key);
			return (result is Array) ? result : (result != null) ? [result] : result;
		}

		/**
		 * @inheritDoc
		 */
		public function hasMetaData(key:String):Boolean {
			return (getMetaData(key) != null);
		}

		/**
		 * @inheritDoc
		 */
		public function hasExactMetaData(otherMetaData:MetaData):Boolean {
			var metaDatas:Array = getMetaData(otherMetaData.name);
			for each (var metaData:MetaData in metaDatas) {
				if (metaData.equals(otherMetaData)) {
					return true;
				}
			}
			return false;
		}
	}

}