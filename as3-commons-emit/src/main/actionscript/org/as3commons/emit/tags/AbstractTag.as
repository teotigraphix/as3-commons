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
package org.as3commons.emit.tags {
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	import org.as3commons.emit.ISWFInput;
	import org.as3commons.emit.ISWFOutput;
	import org.as3commons.lang.Assert;

	public class AbstractTag {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor.
		 *
		 * @param tagId the id of the tag
		 */
		public function AbstractTag(tagId:uint) {
			super();
			initAbstractTag(tagId);
		}

		protected function initAbstractTag(tagId:uint):void {
			Assert.notAbstract(this, AbstractTag);
			_tagId = tagId;
		}


		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  tagId
		//----------------------------------

		private var _tagId:uint;

		public function get tagId():uint {
			return _tagId;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function readData(input:ISWFInput):void {
			throw new IllegalOperationError("Abstract method must be overridden in subclass");
		}

		public function writeData(output:ISWFOutput):void {
			throw new IllegalOperationError("Abstract method must be overridden in subclass");
		}
	}
}