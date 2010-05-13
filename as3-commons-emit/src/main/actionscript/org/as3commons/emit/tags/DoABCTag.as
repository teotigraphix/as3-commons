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
	import flash.utils.ByteArray;

	import org.as3commons.emit.*;
	import org.as3commons.emit.bytecode.IByteCodeLayout;

	/**
	 * Represents an AVM2 bytecode tag
	 */
	public class DoABCTag extends AbstractTag {
		public static const TAG_ID:int = 0x52;

		private var _layout:IByteCodeLayout;
		private var _name:String;
		private var _lazy:Boolean;

		public function DoABCTag(lazy:Boolean, name:String, layout:IByteCodeLayout) {
			super(TAG_ID);

			_layout = layout;
			_name = name;
			_lazy = lazy;
		}

		public override function writeData(output:ISWFOutput):void {
			var flags:uint = getFlags();

			// flags
			output.writeUI32(flags);

			// name
			output.writeString(_name);

			var byteArray:ByteArray = new ByteArray();

			_layout.write(byteArray);

			byteArray.position = 0;
			output.writeBytes(byteArray, 0, byteArray.bytesAvailable);
		}

		public override function readData(input:ISWFInput):void {
			_lazy = (input.readUI8() == 0x01);
			_name = input.readString();

		}

		private function getFlags():uint {
			return (_lazy) ? FLAGS_LAZY : FLAGS_NONE;
		}

		private static const FLAGS_NONE:uint = 0x0;
		private static const FLAGS_LAZY:uint = 0x1;
	}
}