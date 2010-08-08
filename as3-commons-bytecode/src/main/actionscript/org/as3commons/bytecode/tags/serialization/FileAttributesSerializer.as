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

	import org.as3commons.bytecode.tags.FileAttributesTag;
	import org.as3commons.bytecode.tags.ISWFTag;
	import org.as3commons.bytecode.util.SWFSpec;

	public class FileAttributesSerializer extends AbstractTagSerializer {

		public function FileAttributesSerializer(serializerFactory:IStructSerializerFactory) {
			super(serializerFactory);
		}

		override public function read(input:ByteArray):ISWFTag {
			var tag:FileAttributesTag = new FileAttributesTag();
			SWFSpec.readUB(input);
			tag.useDirectBlit = SWFSpec.readBoolean(input);
			tag.useGPU = SWFSpec.readBoolean(input);
			tag.hasMetadata = SWFSpec.readBoolean(input);
			tag.actionScript3 = SWFSpec.readBoolean(input);
			SWFSpec.readUB(input, 2);
			tag.useNetwork = SWFSpec.readBoolean(input);
			SWFSpec.readUB(input, 24);
			return tag;
		}

		override public function write(output:ByteArray, tag:ISWFTag):void {
			throw new Error("Method not implemented in abstract base class");
		}

	}
}