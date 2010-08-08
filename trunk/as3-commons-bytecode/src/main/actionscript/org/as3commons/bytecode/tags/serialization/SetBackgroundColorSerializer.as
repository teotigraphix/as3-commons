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
	import org.as3commons.bytecode.tags.SetBackgroundColorTag;
	import org.as3commons.bytecode.tags.struct.RGB;

	public class SetBackgroundColorSerializer extends AbstractTagSerializer {

		public function SetBackgroundColorSerializer(serializerFactory:IStructSerializerFactory) {
			super(serializerFactory);
		}

		override public function read(input:ByteArray):ISWFTag {
			var tag:SetBackgroundColorTag = new SetBackgroundColorTag();
			var rgb:IStructSerializer = structSerializerFactory.createSerializer(RGB);
			tag.backgroundColor = rgb.read(input) as RGB;
			return tag;
		}

		override public function write(output:ByteArray, tag:ISWFTag):void {
			throw new Error("Not implemented yet");
		}

	}
}