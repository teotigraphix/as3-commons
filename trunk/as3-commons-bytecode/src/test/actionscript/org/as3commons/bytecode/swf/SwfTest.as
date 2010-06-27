/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.swf {
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.util.AbcDeserializer;

	public class SwfTest extends TestCase {

		private var _bitbuff:uint;
		private var _bitleft:uint;

		[Embed(source="../../../../../../test/resources/assets/AbcFlex.swf", mimeType="application/octet-stream")]
		private static var abcFlexSwf:Class;

		[Embed(source="../../../../../../test/resources/assets/as3commons-lang.swf", mimeType="application/octet-stream")]
		private static var langSwf:Class;

		[Embed(source="../../../../../../test/resources/assets/library.swf", mimeType="application/octet-stream")]
		private static var librarySwf:Class;

		[Embed(source="../../../../../../test/resources/assets/framework_4.0.0.14159.swf", mimeType="application/octet-stream")]
		private static var flexFrameworkSwf:Class;


		public function SwfTest(methodName:String = null) {
			super(methodName);
		}

		public function testDumpSwf():void {
			var swfBytes:ByteArray = new langSwf as ByteArray;
			swfBytes.endian = Endian.LITTLE_ENDIAN;

			// Read header
//			Signature UI8 Signature byte: "F" indicates uncompressed, “C” indicates compressed (SWF 6 and later only) 
//			Signature UI8 Signature byte always “W” 
//			Signature UI8 Signature byte always “S” 
//			Version UI8 Single byte file version (for example, 0x06 for SWF 6) 
//			FileLength UI32 Length of entire file in bytes 
//			FrameSize RECT Frame size in twips 
//			FrameRate UI16 Frame delay in 8.8 fixed number of frames per second 
//			FrameCount UI16 Total number of frames in file
			var signature:String = swfBytes.readUTFBytes(3);
			var version:int = swfBytes.readUnsignedByte();
			var fileLength:Number = swfBytes.readUnsignedInt();

			// Assert against constants:
			//  Signature should be CWS
			//  Version should be 9
			//  File Length should be 574960
			assertEquals("CWS", signature);
			//assertEquals(9, version);
//            assertEquals(574960, fileLength);
			trace("Compressed? " + (signature.charAt(0) == "C"));

			// TODO: Handle both compressed and uncompressed cases
			// TODO: Stop dead if the SWF format is not high enough and/or the AVM2 flag is not set

			// An FWS signature indicates an uncompressed SWF file; CWS indicates that
			// the entire file after the first 8 bytes (that is, after the FileLength field)
			// was compressed by using the ZLIB open standard

			// Skip the header, and decompress everything else
			var SWF_HEADER_LENGTH:int = 8;
			var numberOfBytesToRead:int = (swfBytes.length - SWF_HEADER_LENGTH);
			var bodyBytes:ByteArray = new ByteArray();
			bodyBytes.endian = Endian.LITTLE_ENDIAN;

			// This method reads from whatever position the bytearray the method is being
			// called on is at (in this case, the end of the header or position 8).
			swfBytes.readBytes(bodyBytes, 0, numberOfBytesToRead);
			bodyBytes.position = 0;
			bodyBytes.uncompress();
			bodyBytes.position = 0;

			// The uncompressed length including the header should be the same size as the
			// fileLength parsed from the header  
			assertEquals(fileLength, (bodyBytes.length + SWF_HEADER_LENGTH));

			// Read framesize (RECT), framerate, framecount
			var frameSize:Rectangle = readBitRect(bodyBytes);
			var frameRate:int = readFixed8(bodyBytes);
			var frameCount:int = bodyBytes.readShort();

			// Assert against constants:
			//  Rect should be at (0, 0) with a width of 16000 twips and a height of 12000 twips
			//  Frame rate should be 30 
			//  Frame count should be 2 
			assertEquals(0, frameSize.x);
			assertEquals(0, frameSize.y);
//            assertEquals(16000, frameSize.width);
//            assertEquals(12000, frameSize.height);
//            assertEquals(30, frameRate);
//            assertEquals(2, frameCount);

			// Read tags. SWF8 and up start off with a FileAttributes tag
			do {
				var tagPosition:int = bodyBytes.position;
				var tag:uint = bodyBytes.readUnsignedShort();

				var tagSize:uint = tag & 0x3F;
				if (tagSize == 0x3F) {
					tagSize = bodyBytes.readUnsignedInt();
				}
				var tagType:uint = (tag >> 6);
//	            trace("Tag " + tagType + " found at position " + tagPosition + " with length of " + tagSize);
				if (tagType == 82) {
					parseAbcTag(bodyBytes, tagSize);
				}

				// The tag length does not include the recordheader, allowing programs to just
				// skip the entire block by the length specified in the record header
				bodyBytes.position += tagSize;
			} while (bodyBytes.bytesAvailable);

			assertEquals(fileLength, bodyBytes.length, bodyBytes.position);
		}

		public function parseAbcTag(byteArray:ByteArray, length:int):void {
			var positionBeforeParsing:int = byteArray.position;

			var flags:int = byteArray.readInt();
			trace(flags);
			var name:String = readString(byteArray);
			trace(name);

			// AbcDeserializer moves the position of the ByteArray back to zero since it assumes that the bytecode block
			// it is given is a lone ABC block. We need to tell it where to read from in order to avoid this.

			//TODO:    private namespaces are guaranteed to be considered unique (AVM2 spec, page 20):
			//			"If there is more than one entry in one of these arrays for the same entity, such as a name, the
			//			AVM may or may not consider those two entries to mean the same thing. The AVM currently guarantees
			//			that names flagged as belonging to the “private” namespace are treated as unique."
			//  Fix the LNamespace equals() method to not treat private namespaces as unique.   
			var deserializer:AbcDeserializer = new AbcDeserializer(byteArray);
			var startTime:Date = new Date();
			var startPosition:int = byteArray.position;
			var abcFile:AbcFile = deserializer.deserialize(byteArray.position);
			trace("Parse Time: " + (new Date().getTime() - startTime.getTime()));
			trace("Size in Bytes: " + (byteArray.position - startPosition));
//        	trace(abcFile);

			byteArray.position = positionBeforeParsing;
		}

		public function readString(dataInput:ByteArray):String {
			var str:String = "";

			var chr:uint = dataInput.readUnsignedByte();
			while (chr > 0) {
				str += String.fromCharCode(chr);
				chr = dataInput.readUnsignedByte();
			}
			;

			return str;
		}
		;

		/**
		 * Converts the frame rate from "Frame delay in 8.8 fixed number of frames per second" to
		 * a "frames per second" value.
		 */
		public function readFixed8(dataInput:ByteArray):Number {
			var rawFrameRate:int = dataInput.readUnsignedShort();
			var valueConvertedToFramesPerSecond:Number = Number(((rawFrameRate >> 8) & 0xff) * 1.0 + ((rawFrameRate & 0xff) * 0.1));

			return valueConvertedToFramesPerSecond;
		}
		;

		/**
		 * Reads the RECT entry out of the bit field in the SWF header. This entry contains the dimensions
		 * of the SWF.
		 */
		public function readBitRect(dataInput:ByteArray):Rectangle {
			var bits:uint = readUB(5, dataInput);
			var r:Rectangle = new Rectangle();
			r.x = int(readSB(bits, dataInput));
			r.width = int(readSB(bits, dataInput));
			r.y = int(readSB(bits, dataInput));
			r.height = int(readSB(bits, dataInput));
			flushBits();
			return r;
		}
		;

		public function flushBits():void {
			_bitbuff = _bitleft = 0;
		}
		;

		/**
		 * Reads signed bit values.
		 */
		public function readSB(bits:uint, dataInput:ByteArray):int {
			var num:int = readUB(bits, dataInput);
			var shift:int = 32 - bits;
			num = (num << shift) >> shift;
			return num;
		}
		;

		/**
		 * Reads unsigned bit values.
		 */
		public function readUB(bits:uint, dataInput:ByteArray):uint {
			if (bits > 64 || bits == 0)
				return 0;

			var r:uint = (_bitbuff >> (8 - _bitleft));
			if (_bitleft >= bits) {
				_bitleft -= bits;
				_bitbuff <<= bits;
				return (r >> (8 - bits));
			}
			;
			bits -= _bitleft;
			while (bits > 7) {
				_bitbuff = dataInput.readUnsignedByte();

				r = (r << 8) | _bitbuff;
				bits -= 8;
				_bitleft = 0;
			}
			;
			_bitbuff = 0;
			if (bits) {
				_bitbuff = dataInput.readUnsignedByte();
				_bitleft = 8 - bits;
				r = (r << bits) | (_bitbuff >> _bitleft);
				_bitbuff <<= bits;
			}
			;
			_bitbuff &= 0xff;
			return r;
		}
		;
	}
}