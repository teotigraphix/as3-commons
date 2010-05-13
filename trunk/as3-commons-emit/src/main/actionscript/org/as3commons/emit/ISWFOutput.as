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
	import flash.utils.ByteArray;

	/**
	 * Enables the writing of SWF data types to
	 * a stream
	 */
	public interface ISWFOutput {
		function writeString(value:String):void;

		function writeSI8(value:int):void;
		function writeSI16(value:int):void;
		function writeSI32(value:int):void;

		function writeUI8(value:uint):void;
		function writeUI16(value:uint):void;
		function writeUI32(value:uint):void;

		function writeBit(bit:Boolean):void;

		function writeBytes(bytes:ByteArray, offset:int = 0, length:int = 0):void;

		/**
		 * Aligns to the next available byte if not currently byte aligned
		 */
		function align():void;
	}
}