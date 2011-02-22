package org.as3commons.bytecode.swf {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.tags.DoABCTag;
	import org.as3commons.bytecode.tags.DoABCWeaverSerializer;
	import org.as3commons.bytecode.tags.serialization.RecordHeaderSerializer;
	import org.as3commons.bytecode.tags.serialization.UnsupportedSerializer;

	public class SWFWeaverIO extends SWFFileIO {

		public function SWFWeaverIO() {
			super();
			initSWFFileIO();
		}

		override protected function initSWFFileIO():void {
			unsupportedTagSerializer = new UnsupportedSerializer();
			recordHeaderSerializer = new RecordHeaderSerializer();
			tagSerializers = new Dictionary();
			serializerInstances = new Dictionary();
			tagSerializers[DoABCTag.TAG_ID] = DoABCWeaverSerializer;
		}

	}
}