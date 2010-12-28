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

	import org.as3commons.bytecode.tags.struct.Symbol;
	import org.as3commons.bytecode.util.SWFSpec;

	public class SymbolSerializer extends AbstractStructSerializer {

		public function SymbolSerializer() {
			super();
		}

		override public function read(input:ByteArray):Object {
			var struct:Symbol = new Symbol();
			struct.tagId = SWFSpec.readUI16(input);
			struct.symbolClassName = SWFSpec.readString(input);
			return struct;
		}

		override public function write(output:ByteArray, struct:Object):void {
			var symbol:Symbol = struct as Symbol;
			SWFSpec.writeUI16(output, symbol.tagId);
			SWFSpec.writeString(output, symbol.symbolClassName);
		}

	}
}