/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.swf {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import org.as3commons.bytecode.tags.DefineShapeTag;
	import org.as3commons.bytecode.tags.DoABCTag;
	import org.as3commons.bytecode.tags.EndTag;
	import org.as3commons.bytecode.tags.FileAttributesTag;
	import org.as3commons.bytecode.tags.FrameLabelTag;
	import org.as3commons.bytecode.tags.ISWFTag;
	import org.as3commons.bytecode.tags.MetadataTag;
	import org.as3commons.bytecode.tags.ProductInfoTag;
	import org.as3commons.bytecode.tags.ScriptLimitsTag;
	import org.as3commons.bytecode.tags.SetBackgroundColorTag;
	import org.as3commons.bytecode.tags.ShowFrameTag;
	import org.as3commons.bytecode.tags.SymbolClassTag;
	import org.as3commons.bytecode.tags.serialization.DoABCSerializer;
	import org.as3commons.bytecode.tags.serialization.EndTagSerializer;
	import org.as3commons.bytecode.tags.serialization.FileAttributesSerializer;
	import org.as3commons.bytecode.tags.serialization.FrameLabelSerializer;
	import org.as3commons.bytecode.tags.serialization.ITagSerializer;
	import org.as3commons.bytecode.tags.serialization.MetadataSerializer;
	import org.as3commons.bytecode.tags.serialization.ProductInfoSerializer;
	import org.as3commons.bytecode.tags.serialization.RecordHeaderSerializer;
	import org.as3commons.bytecode.tags.serialization.ScriptLimitsSerializer;
	import org.as3commons.bytecode.tags.serialization.SetBackgroundColorSerializer;
	import org.as3commons.bytecode.tags.serialization.ShowFrameSerializer;
	import org.as3commons.bytecode.tags.serialization.StructSerializerFactory;
	import org.as3commons.bytecode.tags.serialization.SymbolClassSerializer;
	import org.as3commons.bytecode.tags.serialization.UnsupportedSerializer;
	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.SWFSpec;

	public class SWFFileIO implements ISWFFileIO {

		public static const SWF_SIGNATURE_COMPRESSED:String = "CWS";
		public static const SWF_SIGNATURE_UNCOMPRESSED:String = "FWS";

		private var _tagSerializers:Dictionary;
		private var _serializerInstances:Dictionary;
		private var _unsupportedTagSerializer:UnsupportedSerializer;

		private var _recordHeaderSerializer:RecordHeaderSerializer;
		private var _structSerializerFactory:StructSerializerFactory;

		public function SWFFileIO() {
			super();
			initSWFFileIO();
		}

		protected function initSWFFileIO():void {
			_unsupportedTagSerializer = new UnsupportedSerializer();
			_recordHeaderSerializer = new RecordHeaderSerializer();
			_structSerializerFactory = new StructSerializerFactory();
			_tagSerializers = new Dictionary();
			_serializerInstances = new Dictionary();
			_tagSerializers[EndTag.TAG_ID] = EndTagSerializer;
			_tagSerializers[FileAttributesTag.TAG_ID] = FileAttributesSerializer;
			_tagSerializers[FrameLabelTag.TAG_ID] = FrameLabelSerializer;
			_tagSerializers[MetadataTag.TAG_ID] = MetadataSerializer;
			_tagSerializers[ProductInfoTag.TAG_ID] = ProductInfoSerializer;
			_tagSerializers[ScriptLimitsTag.TAG_ID] = ScriptLimitsSerializer;
			_tagSerializers[SetBackgroundColorTag.TAG_ID] = SetBackgroundColorSerializer;
			_tagSerializers[ShowFrameTag.TAG_ID] = ShowFrameSerializer;
			_tagSerializers[SymbolClassTag.TAG_ID] = SymbolClassSerializer;
			_tagSerializers[DoABCTag.TAG_ID] = DoABCSerializer;
		}

		protected function createTagSerializer(tagId:uint):ITagSerializer {
			if (_serializerInstances[tagId] == null) {
				if (_tagSerializers[tagId] != null) {
					_serializerInstances[tagId] = new _tagSerializers[tagId](_structSerializerFactory);
				} else {
					return _unsupportedTagSerializer;
				}
			}
			return _serializerInstances[tagId] as ITagSerializer;
		}

		public function read(input:ByteArray):SWFFile {
			var swfFile:SWFFile = new SWFFile();
			var bytes:ByteArray = AbcSpec.byteArray();
			input.endian = Endian.LITTLE_ENDIAN;
			swfFile.signature = input.readUTFBytes(3);
			var compressed:Boolean = (swfFile.signature == SWF_SIGNATURE_COMPRESSED);
			swfFile.version = SWFSpec.readSI8(input);
			swfFile.fileLength = SWFSpec.readUI32(input);
			input.readBytes(bytes);
			bytes.position = 0;

			if (compressed) {
				bytes.uncompress();
			}
			bytes.position = 0;
			readHeader(bytes, swfFile);
			while (bytes.bytesAvailable) {
				swfFile.addTag(readTag(bytes));
			}

			return swfFile;
		}

		public function write(output:ByteArray, swf:SWFFile):void {
			output.endian = Endian.LITTLE_ENDIAN;
			output.position = 0;
			output.writeUTFBytes(swf.signature);
			SWFSpec.writeSI8(output, swf.version);
			var ba:ByteArray = AbcSpec.byteArray();
			writeHeader(ba, swf);
			for each (var tag:ISWFTag in swf.tags) {
				writeTag(ba, tag);
			}
			var fileLength:int = ba.length;
			if (swf.signature == SWF_SIGNATURE_COMPRESSED) {
				ba.position = 0;
				ba.compress();
			}
			ba.position = 0;
			SWFSpec.writeUI32(output, fileLength);
			output.writeBytes(ba);
		}

		protected function readTag(input:ByteArray):ISWFTag {
			var recordHeader:RecordHeader = _recordHeaderSerializer.read(input) as RecordHeader;
			var serializer:ITagSerializer = createTagSerializer(recordHeader.id);
			if (serializer != null) {
				return serializer.read(input, recordHeader);
			} else {
				input.position += recordHeader.length;
				return null;
			}
		}

		protected function writeTag(output:ByteArray, tag:ISWFTag):void {
			var serializer:ITagSerializer = createTagSerializer(tag.id);
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			serializer.write(ba, tag);
			ba.position = 0;

			var recordHeader:RecordHeader = new RecordHeader(tag.id, ba.length, (ba.length > RecordHeaderSerializer.LONG_TAG));
			_recordHeaderSerializer.write(output, recordHeader);
			output.writeBytes(ba);
			ba = null;
		}

		protected function readHeader(input:ByteArray, swf:SWFFile):void {
			swf.frameSize = SWFSpec.readBitRect(input);
			swf.frameRate = SWFSpec.readUI16(input);
			swf.frameCount = SWFSpec.readUI16(input);
		}

		protected function writeHeader(output:ByteArray, swf:SWFFile):void {
			SWFSpec.writeBitRect(output, swf.frameSize);
			SWFSpec.writeUI16(output, swf.frameRate);
			SWFSpec.writeUI16(output, swf.frameCount);
		}
	}
}