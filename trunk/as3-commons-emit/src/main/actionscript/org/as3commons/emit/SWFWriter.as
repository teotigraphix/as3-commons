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
	import flash.utils.Endian;
	import flash.utils.IDataOutput;

	import org.as3commons.emit.tags.AbstractTag;
	import org.as3commons.lang.Assert;

	public class SWFWriter {

		private static const PRE_HEADER_SIZE:int = 8; // FWS[VERSION][FILESIZE]

		// Right now I can't be bothered implementing framesize, framework or framecount
		private var _hardCodedHeader:Array = [0x78, 0x00, 0x04, 0xE2, 0x00, 0x00, 0x0E, 0xA6, 0x00, 0x00, 0x18, 0x01, 0x00];

		private var _compress:Boolean = false;
		private var _tagDataBuffer:ByteArray;
		private var _tagDataWriter:SWFOutput;

		public function SWFWriter() {
			super();
			initSWFWriter();
		}

		protected function initSWFWriter():void {
			_tagDataBuffer = new ByteArray();
			_tagDataWriter = new SWFOutput(_tagDataBuffer);
		}

		public function get compress():Boolean {
			return _compress;
		}

		public function set compress(value:Boolean):void {
			_compress = value;
		}

		public function write(output:IDataOutput, header:SWFHeader, tags:Array):void {
			Assert.notNull(output, "output argument must not be null");
			Assert.notNull(header, "header argument must not be null");
			Assert.notNull(tags, "tags argument must not be null");

			output.endian = Endian.BIG_ENDIAN;

			var buffer:ByteArray = new ByteArray();

			var swfOutput:SWFOutput = new SWFOutput(buffer);
			writeInternal(swfOutput, header, tags);
			buffer.position = 0;

			// FileSize is uncompressed
			var fileSize:int = buffer.bytesAvailable + SWFConstant.PRE_HEADER_SIZE;

			swfOutput = new SWFOutput(output);

			if (_compress) {
				buffer.compress();
				swfOutput.writeUI8(SWFConstant.COMPRESSED_SWF_IDENTIFIER.charCodeAt(0));
			} else {
				swfOutput.writeUI8(SWFConstant.UNCOMPRESSED_SWF_IDENTIFIER.charCodeAt(0));
			}

			swfOutput.writeUI8("W".charCodeAt(0));
			swfOutput.writeUI8("S".charCodeAt(0));
			swfOutput.writeUI8(header.version);

			swfOutput.writeUI32(fileSize);

			buffer.position = 0;
			output.writeBytes(buffer, 0, buffer.bytesAvailable);
		}

		private function writeInternal(swfOutput:SWFOutput, header:SWFHeader, tags:Array):void {
			Assert.notNull(swfOutput, "swfOutput argument must not be null");
			Assert.notNull(header, "header argument must not be null");
			Assert.notNull(tags, "tags argument must not be null");
			// TODO: Write the actual header here
			for each (var byte:int in _hardCodedHeader) {
				swfOutput.writeUI8(byte);
			}

			for each (var tag:AbstractTag in tags) {
				writeTag(swfOutput, tag);
			}
		}

		private function writeTag(output:ISWFOutput, tag:AbstractTag):void {
			Assert.notNull(output, "output argument must not be null");
			Assert.notNull(tag, "tag argument must not be null");

			_tagDataBuffer.position = 0;

			tag.writeData(_tagDataWriter);

			var tagLength:uint = _tagDataBuffer.position;

			if (tagLength >= 63) {
				output.writeUI16((tag.tagId << 6) | 0x3F);
				output.writeUI32(tagLength);
			} else {
				output.writeUI16((tag.tagId << 6) | tagLength);
			}

			_tagDataBuffer.position = 0;

			if (tagLength > 0) {
				output.writeBytes(_tagDataBuffer, 0, tagLength);
			}
		}
	}
}