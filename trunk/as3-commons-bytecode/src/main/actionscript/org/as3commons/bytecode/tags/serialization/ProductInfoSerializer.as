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
	import org.as3commons.bytecode.tags.ProductInfoTag;
	import org.as3commons.bytecode.util.SWFSpec;

	public class ProductInfoSerializer extends AbstractTagSerializer {

		public function ProductInfoSerializer(serializerFactory:IStructSerializerFactory) {
			super(serializerFactory);
		}

		override public function read(input:ByteArray):ISWFTag {
			var tag:ProductInfoTag = new ProductInfoTag();
			tag.productId = SWFSpec.readUI32(input);
			tag.edition = SWFSpec.readUI32(input);
			tag.majorVersion = SWFSpec.readUI8(input);
			tag.minorVersion = SWFSpec.readUI8(input);
			tag.minorBuild = SWFSpec.readUI32(input);
			tag.majorBuild = SWFSpec.readUI32(input);
			tag.compileDatePart1 = SWFSpec.readUI32(input);
			tag.compileDatePart2 = SWFSpec.readUI32(input);
			return tag;
		}

		override public function write(output:ByteArray, tag:ISWFTag):void {
			var productInfo:ProductInfoTag = tag as ProductInfoTag;
			SWFSpec.writeUI32(output, productInfo.productId);
			SWFSpec.writeUI32(output, productInfo.edition);
			SWFSpec.writeUI8(output, productInfo.majorVersion);
			SWFSpec.writeUI8(output, productInfo.minorVersion);
			SWFSpec.writeUI32(output, productInfo.minorBuild);
			SWFSpec.writeUI32(output, productInfo.majorBuild);
			SWFSpec.writeUI32(output, productInfo.compileDatePart1);
			SWFSpec.writeUI32(output, productInfo.compileDatePart2);
		}

	}
}