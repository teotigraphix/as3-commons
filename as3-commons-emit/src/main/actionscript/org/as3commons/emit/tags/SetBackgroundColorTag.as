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

	import org.as3commons.emit.ISWFOutput;

	public class SetBackgroundColorTag extends AbstractTag {
		public static const TAG_ID:int = 0x9;

		private var _red:uint;
		private var _green:uint;
		private var _blue:uint;

		public function SetBackgroundColorTag(red:uint = 0, green:uint = 0, blue:uint = 0) {
			super(TAG_ID);

			_red = red;
			_green = green;
			_blue = blue;
		}

		public override function writeData(output:ISWFOutput):void {
			output.writeUI8(_red);
			output.writeUI8(_green);
			output.writeUI8(_blue);
		}

		public function get red():uint {
			return _red;
		}

		public function set red(value:uint):void {
			_red = value;
		}

		public function get green():uint {
			return _green;
		}

		public function set green(value:uint):void {
			_green = value;
		}

		public function get blue():uint {
			return _blue;
		}

		public function set blue(value:uint):void {
			_blue = value;
		}
	}
}