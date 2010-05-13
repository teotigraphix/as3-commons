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

	public class ScriptLimitsTag extends AbstractTag {
		public static const TAG_ID:int = 0x41;

		private var _maxRecursionDepth:int = 1000;
		private var _scriptTimeoutSeconds:int = 60;

		public function ScriptLimitsTag() {
			super(TAG_ID);
		}

		public override function writeData(output:ISWFOutput):void {
			output.writeUI16(_maxRecursionDepth);
			output.writeUI16(_scriptTimeoutSeconds);
		}

		public function get maxRecursionDepth():uint {
			return _maxRecursionDepth;
		}

		public function set maxRecursionDepth(value:uint):void {
			_maxRecursionDepth = value;
		}

		public function get scriptTimeoutSeconds():uint {
			return _scriptTimeoutSeconds;
		}

		public function set scriptTimeoutSeconds(value:uint):void {
			_scriptTimeoutSeconds = value;
		}
	}
}