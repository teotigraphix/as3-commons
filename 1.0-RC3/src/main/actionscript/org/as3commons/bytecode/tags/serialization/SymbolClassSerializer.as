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
package org.as3commons.bytecode.tags.serialization {

	import flash.utils.ByteArray;

	import org.as3commons.bytecode.tags.ISWFTag;
	import org.as3commons.bytecode.tags.SymbolClassTag;
	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.tags.struct.Symbol;
	import org.as3commons.bytecode.util.SWFSpec;

	public class SymbolClassSerializer extends AbstractTagSerializer {

		public function SymbolClassSerializer(serializerFactory:IStructSerializerFactory) {
			super(serializerFactory);
		}

		override public function read(input:ByteArray, recordHeader:RecordHeader):ISWFTag {
			var numSymbols:uint = SWFSpec.readUI16(input);
			var tag:SymbolClassTag = new SymbolClassTag();
			var serializer:IStructSerializer = structSerializerFactory.createSerializer(Symbol);
			for (var i:uint = 0; i < numSymbols; ++i) {
				tag.symbols[tag.symbols.length] = serializer.read(input);
			}
			return tag;
		}

		override public function write(output:ByteArray, tag:ISWFTag):void {
			var symbolTag:SymbolClassTag = tag as SymbolClassTag;
			var serializer:IStructSerializer = structSerializerFactory.createSerializer(Symbol);
			var len:uint = symbolTag.symbols.length;
			SWFSpec.writeUI16(output, len);
			for (var i:uint = 0; i < len; ++i) {
				serializer.write(output, symbolTag.symbols[i]);
			}
		}

	}
}