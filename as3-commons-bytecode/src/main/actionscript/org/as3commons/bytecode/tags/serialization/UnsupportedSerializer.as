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

	import org.as3commons.bytecode.tags.ISWFTag;
	import org.as3commons.bytecode.tags.UnsupportedTag;
	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.SWFSpec;

	public class UnsupportedSerializer extends AbstractTagSerializer {

		public function UnsupportedSerializer() {
			super(null);
		}

		override public function read(input:ByteArray, recordHeader:RecordHeader):ISWFTag {
			var tag:UnsupportedTag = new UnsupportedTag(recordHeader.id);
			tag.tagBody = AbcSpec.byteArray();
			input.readBytes(tag.tagBody, 0, recordHeader.length);
			tag.tagBody.position = 0;
			return tag;
		}

		override public function write(output:ByteArray, tag:ISWFTag):void {
			var unsupportedTag:UnsupportedTag = tag as UnsupportedTag;
			unsupportedTag.tagBody.position = 0;
			output.writeBytes(unsupportedTag.tagBody);
		}

	}
}