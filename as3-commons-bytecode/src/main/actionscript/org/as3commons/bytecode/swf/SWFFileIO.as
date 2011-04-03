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
package org.as3commons.bytecode.swf
{
	import org.as3commons.bytecode.tags.EndTag;
	import org.as3commons.bytecode.tags.FileAttributesTag;
	import org.as3commons.bytecode.tags.FrameLabelTag;
	import org.as3commons.bytecode.tags.MetadataTag;
	import org.as3commons.bytecode.tags.ProductInfoTag;
	import org.as3commons.bytecode.tags.ScriptLimitsTag;
	import org.as3commons.bytecode.tags.SetBackgroundColorTag;
	import org.as3commons.bytecode.tags.ShowFrameTag;
	import org.as3commons.bytecode.tags.SymbolClassTag;
	import org.as3commons.bytecode.tags.serialization.EndTagSerializer;
	import org.as3commons.bytecode.tags.serialization.FileAttributesSerializer;
	import org.as3commons.bytecode.tags.serialization.FrameLabelSerializer;
	import org.as3commons.bytecode.tags.serialization.MetadataSerializer;
	import org.as3commons.bytecode.tags.serialization.ProductInfoSerializer;
	import org.as3commons.bytecode.tags.serialization.ScriptLimitsSerializer;
	import org.as3commons.bytecode.tags.serialization.SetBackgroundColorSerializer;
	import org.as3commons.bytecode.tags.serialization.ShowFrameSerializer;
	import org.as3commons.bytecode.tags.serialization.SymbolClassSerializer;

	public class SWFFileIO extends SWFWeaverFileIO
	{
		public function SWFFileIO()
		{
			super();
		}
		
		override protected function initSWFWeaverFileIO():void {
			super.initSWFWeaverFileIO();
			tagSerializers[EndTag.TAG_ID] = EndTagSerializer;
			tagSerializers[FileAttributesTag.TAG_ID] = FileAttributesSerializer;
			tagSerializers[FrameLabelTag.TAG_ID] = FrameLabelSerializer;
			tagSerializers[MetadataTag.TAG_ID] = MetadataSerializer;
			tagSerializers[ProductInfoTag.TAG_ID] = ProductInfoSerializer;
			tagSerializers[ScriptLimitsTag.TAG_ID] = ScriptLimitsSerializer;
			tagSerializers[SetBackgroundColorTag.TAG_ID] = SetBackgroundColorSerializer;
			tagSerializers[ShowFrameTag.TAG_ID] = ShowFrameSerializer;
			tagSerializers[SymbolClassTag.TAG_ID] = SymbolClassSerializer;
		}

	}
}