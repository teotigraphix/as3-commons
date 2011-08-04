/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.abc {
	import org.as3commons.bytecode.typeinfo.Annotatable;
	import org.as3commons.lang.StringUtils;


	/**
	 * as3commons-bytecode representation of <code>trait_class</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Class traits" in the AVM Spec (page 30)
	 */
	public final class ClassTrait extends TraitInfo {
		public var classSlotId:int;
		public var classIndex:int;
		public var classInfo:ClassInfo;

		public function ClassTrait() {
			super();
		}

		public function toString():String {
			return StringUtils.substitute("ClassTrait[name={0}, classSlotId={1}, classIndex={2}, metadata={3}]", traitMultiname, classSlotId, classIndex, metadata);
		}

		override public function clone():* {
			var clone:ClassTrait = new ClassTrait();
			populateClone(clone);
			return clone;
		}

		override protected function populateClone(annotatable:Annotatable):void {
			super.populateClone(annotatable);
			ClassTrait(annotatable).classSlotId = classSlotId;
			ClassTrait(annotatable).classIndex = classIndex;
		}

	}
}