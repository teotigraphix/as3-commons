/*
 * Copyright 2007-2011 the original author or authors.
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
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import org.as3commons.bytecode.swf.event.SWFFileIOEvent;
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

	/**
	 *
	 */
	[Event(name="tagSerializerCreated", type="org.as3commons.bytecode.swf.event.SWFFileIOEvent")]
	/**
	 *
	 * @author Roland Zwaga
	 */
	public class SWFFileIO extends EventDispatcher implements ISWFFileIO {

		public static const SWF_SIGNATURE_COMPRESSED:String = "CWS";
		public static const SWF_SIGNATURE_UNCOMPRESSED:String = "FWS";

		private var _tagSerializers:Dictionary;
		private var _serializerInstances:Dictionary;
		protected var unsupportedTagSerializer:UnsupportedSerializer;
		protected var recordHeaderSerializer:RecordHeaderSerializer;
		protected var structSerializerFactory:StructSerializerFactory;

		public function SWFFileIO() {
			super();
			initSWFFileIO();
		}

		public function get serializerInstances():Dictionary {
			return _serializerInstances;
		}

		public function get tagSerializers():Dictionary {
			return _tagSerializers;
		}

		protected function initSWFFileIO():void {
			unsupportedTagSerializer = new UnsupportedSerializer();
			recordHeaderSerializer = new RecordHeaderSerializer();
			structSerializerFactory = new StructSerializerFactory();
			_tagSerializers = new Dictionary();
			_serializerInstances = new Dictionary();
			tagSerializers[EndTag.TAG_ID] = EndTagSerializer;
			tagSerializers[FileAttributesTag.TAG_ID] = FileAttributesSerializer;
			tagSerializers[FrameLabelTag.TAG_ID] = FrameLabelSerializer;
			tagSerializers[MetadataTag.TAG_ID] = MetadataSerializer;
			tagSerializers[ProductInfoTag.TAG_ID] = ProductInfoSerializer;
			tagSerializers[ScriptLimitsTag.TAG_ID] = ScriptLimitsSerializer;
			tagSerializers[SetBackgroundColorTag.TAG_ID] = SetBackgroundColorSerializer;
			tagSerializers[ShowFrameTag.TAG_ID] = ShowFrameSerializer;
			tagSerializers[SymbolClassTag.TAG_ID] = SymbolClassSerializer;
			tagSerializers[DoABCTag.TAG_ID] = DoABCSerializer;
		}

		public function createTagSerializer(tagId:uint):ITagSerializer {
			var serializer:ITagSerializer;
			if (serializerInstances[tagId] == null) {
				if (tagSerializers[tagId] != null) {
					serializer = new tagSerializers[tagId](structSerializerFactory);
					var evt:SWFFileIOEvent = new SWFFileIOEvent(SWFFileIOEvent.TAG_SERIALIZER_CREATED, serializer);
					dispatchEvent(evt);
					serializer = evt.tagSerializer;
					serializerInstances[tagId] = serializer;
				} else {
					serializer = unsupportedTagSerializer;
				}
			}
			return serializer;
		}

		/**
		 * @inheritDoc
		 */
		public function read(input:ByteArray):SWFFile {
			var originalPosition:int = input.position;
			var swfFile:SWFFile = new SWFFile();
			try {
				input.position = 0;
				var bytes:ByteArray = AbcSpec.newByteArray();
				input.endian = Endian.LITTLE_ENDIAN;
				swfFile.signature = input.readUTFBytes(3);
				var compressed:Boolean = (swfFile.signature == SWF_SIGNATURE_COMPRESSED);
				swfFile.version = SWFSpec.readSI8(input);
				swfFile.fileLength = SWFSpec.readUI32(input);
				input.readBytes(bytes);
				bytes.position = 0;

				if (compressed) {
					bytes.uncompress();
					bytes.position = 0;
				}

				readHeader(bytes, swfFile);
				while (bytes.bytesAvailable) {
					var tag:ISWFTag = readTag(bytes);
					if (tag != null) {
						swfFile.addTag(tag);
					}
				}
			} finally {
				input.position = originalPosition;
			}
			return swfFile;
		}

		/**
		 * @inheritDoc
		 */
		public function write(output:ByteArray, swf:SWFFile):void {
			output.endian = Endian.LITTLE_ENDIAN;
			output.position = 0;
			output.writeUTFBytes(swf.signature);
			SWFSpec.writeSI8(output, swf.version);
			var ba:ByteArray = AbcSpec.newByteArray();
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
			var recordHeader:RecordHeader = recordHeaderSerializer.read(input) as RecordHeader;
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
			recordHeaderSerializer.write(output, recordHeader);
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