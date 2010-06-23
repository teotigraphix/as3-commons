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

	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.IDataInput;

	import loom.abc.AbcFile;
	import loom.util.AbcDeserializer;

	import org.as3commons.emit.tags.AbstractTag;
	import org.as3commons.emit.tags.DoABCTag;
	import org.as3commons.emit.tags.EndTag;
	import org.as3commons.emit.tags.FileAttributesTag;
	import org.as3commons.emit.tags.FrameLabelTag;
	import org.as3commons.emit.tags.RecordHeader;
	import org.as3commons.emit.tags.ScriptLimitsTag;
	import org.as3commons.emit.tags.SetBackgroundColorTag;
	import org.as3commons.emit.tags.ShowFrameTag;
	import org.as3commons.emit.util.BitReader;
	import org.as3commons.lang.Assert;

	public class SWFReader {

		private var tagIDLookup:Dictionary;

		public function SWFReader() {
			super();
			initSWFReader();
		}

		protected function initSWFReader():void {
			tagIDLookup = new Dictionary();
			tagIDLookup[DoABCTag.TAG_ID] = DoABCTag;
			tagIDLookup[EndTag.TAG_ID] = EndTag;
			tagIDLookup[FileAttributesTag.TAG_ID] = FileAttributesTag;
			tagIDLookup[FrameLabelTag.TAG_ID] = FrameLabelTag;
			tagIDLookup[ScriptLimitsTag.TAG_ID] = ScriptLimitsTag;
			tagIDLookup[SetBackgroundColorTag.TAG_ID] = SetBackgroundColorTag;
			tagIDLookup[ShowFrameTag.TAG_ID] = ShowFrameTag;
		}

		public function read(input:ByteArray):SWF {
			Assert.notNull(input, "input argument must not be null");
			input.endian = Endian.LITTLE_ENDIAN;
			var swfIdentifier:String = input.readUTFBytes(3);
			var compressed:Boolean = (swfIdentifier == SWFConstant.COMPRESSED_SWF_SIGNATURE);
			var version:uint = input.readByte();
			var filesize:uint = input.readUnsignedInt();

			//input.readBytes(data, 0, filesize - SWFConstant.PRE_HEADER_SIZE);
			input.readBytes(input);
			input.length -= 8;

			if (compressed) {
				input.uncompress();
			}
			input.position = 0;

			var header:SWFHeader = readHeader(input, compressed, version, filesize);

			return new SWF(header, readTags(input));
		}

		private function readTags(input:ByteArray):Array {
			var tag:AbstractTag = readTag(input);
			var result:Array = [];
			if (tag != null) {
				result[result.length] = tag;
			}
			while (input.bytesAvailable) {
				tag = readTag(input);
				if (tag != null) {
					result[result.length] = tag;
				}
			}
			return result;
		}

		private function readTag(input:ByteArray):AbstractTag {
			Assert.notNull(input, "input argument must not be null");
			var header:RecordHeader = readRecordHeader(input);
			var cls:Class = tagIDLookup[header.id];
			var tag:AbstractTag = null;
			if (cls != null) {
				if (cls === DoABCTag) {
					tag = new cls();
					var swfInput:SWFInput = new SWFInput(input);
					tag.readData(swfInput);
					var b:ByteArray = new ByteArray();
					input.readBytes(b, input.position);
					var deserializer:AbcDeserializer = new AbcDeserializer(b);
					var abc:AbcFile = deserializer.deserialize();
					var f:int = 0;
				} else {
					input.position += header.length;
				}
			} else {
				input.position += header.length;
			}
			return tag;
		}

		private function readRecordHeader(input:IDataInput):RecordHeader {
			Assert.notNull(input, "input argument must not be null");
			var tagCL:uint = input.readUnsignedShort();
			var tagId:uint = tagCL >> 6;
			var tagLength:uint = tagCL & 0x3F;
			var longTag:Boolean = false;
			if (tagLength == 0x3f) {
				tagLength = input.readUnsignedInt();
				longTag = (tagLength <= 127);
			}
			return new RecordHeader(tagId, tagLength, longTag);
		}

		private function readHeader(input:IDataInput, compressed:Boolean, version:uint, filesize:uint):SWFHeader {
			Assert.notNull(input, "input argument must not be null");
			var frameSize:Rectangle = readRectangle(input);

			var width:Number = (frameSize.width - frameSize.x) / 15;
			var height:Number = (frameSize.height - frameSize.y) / 15;

			var frameRateA:Number = input.readUnsignedByte();
			var frameRateB:Number = input.readUnsignedByte();

			var frameRate:Number = parseFloat(frameRateB.toString() + SWFConstant.PERIOD + frameRateA.toString());

			var frameCount:uint = input.readUnsignedShort();

			return new SWFHeader(version, compressed, filesize, width, height, frameRate, frameCount);
		}

		private function readRectangle(input:IDataInput):Rectangle {
			Assert.notNull(input, "input argument must not be null");
			var current:uint = input.readUnsignedByte();
			var size:uint = current >> 3;
			var off:int = 3;
			for (var i:int = 0; i < 4; i += 1) {
				off -= size;
				while (off < 0) {
					current = input.readUnsignedByte();
					off += 8;
				}
			}
			return new Rectangle();
		}

		private function readAsciiChars(input:IDataInput, count:uint):String {
			Assert.notNull(input, "input argument must not be null");
			var charCodes:Array = new Array(count);

			for (var i:int = 0; i < count; i++) {
				charCodes[i] = input.readByte();
			}

			return String.fromCharCode.apply(charCodes);
		}
	}
}