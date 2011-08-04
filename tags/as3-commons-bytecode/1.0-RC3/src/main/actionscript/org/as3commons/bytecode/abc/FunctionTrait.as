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
		 * as3commons-bytecode representation of <code>Trait_Function</code> in the ABC file format.
		 *
		 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Function traits" in the AVM Spec (page 31)
		 */
	public final class FunctionTrait extends TraitInfo {

		public var functionSlotId:int;
		public var functionMethod:MethodInfo;
		public var isStatic:Boolean = false;

		public function FunctionTrait() {
			super();
		}

		public function toString():String {
			return StringUtils.substitute("FunctionTrait[name={0}, functionSlotId={1}, method={2}]", traitMultiname, functionSlotId, functionMethod);
		}

		override public function clone():* {
			var clone:FunctionTrait = new FunctionTrait();
			populateClone(clone);
			return clone;
		}

		override protected function populateClone(annotatable:Annotatable):void {
			super.populateClone(annotatable);
			var functionTrait:FunctionTrait = FunctionTrait(annotatable);
			functionTrait.functionSlotId = functionSlotId;
			functionTrait.isStatic = isStatic;
		}
	}
}