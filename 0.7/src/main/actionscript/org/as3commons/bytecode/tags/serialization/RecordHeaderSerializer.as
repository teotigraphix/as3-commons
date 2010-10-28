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
package org.as3commons.bytecode.tags.serialization {
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.util.SWFSpec;

	public class RecordHeaderSerializer extends AbstractStructSerializer {

		public static const ID_SHIFT:uint = 6;
		public static const LONG_TAG:uint = 0x3F;

		public function RecordHeaderSerializer() {
			super();
		}

		override public function read(input:ByteArray):Object {
			var tag:uint = SWFSpec.readUI16(input);
			var id:int = tag >> ID_SHIFT;
			var size:int = tag & LONG_TAG;
			var isLong:Boolean = false;
			if (size == LONG_TAG) {
				size = SWFSpec.readUI32(input);
				isLong = true;
			}
			return new RecordHeader(id, size, isLong);
		}

		override public function write(output:ByteArray, struct:Object):void {
			var recordHeader:RecordHeader = RecordHeader(struct);
			if (!recordHeader.isLongTag) {
				SWFSpec.writeUI16(output, (recordHeader.id << ID_SHIFT) | recordHeader.length);
			} else {
				SWFSpec.writeUI16(output, (recordHeader.id << ID_SHIFT) | LONG_TAG);
				SWFSpec.writeUI32(output, recordHeader.length);
			}
		}

	}
}