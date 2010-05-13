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
package org.as3commons.emit {

	public class SWFHeader {

		private var _version:uint;
		private var _compressed:Boolean;
		private var _filesize:int;
		private var _width:Number;
		private var _height:Number;
		private var _frameRate:Number;
		private var _frameCount:uint;

		public function SWFHeader(version:uint = 9, compressed:Boolean = false, filesize:Number = -1, width:Number = 100, height:Number = 100, frameRate:Number = 25, frameCount:int = 1) {
			super();
			_version = version;
			_compressed = compressed;
			_filesize = filesize;
			_width = width;
			_height = height;
			_frameRate = frameRate;
			_frameCount = frameCount;
		}

		public function get version():uint {
			return _version;
		}

		public function get compressed():Boolean {
			return _compressed;
		}

		public function get filesize():Number {
			return _filesize;
		}

		public function get width():Number {
			return _width;
		}

		public function get height():Number {
			return _height;
		}

		public function get frameRate():Number {
			return _frameRate;
		}

		public function get frameCount():int {
			return _frameCount;
		}
	}
}