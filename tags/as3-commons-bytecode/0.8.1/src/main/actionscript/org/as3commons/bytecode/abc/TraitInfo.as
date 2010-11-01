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

	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.typeinfo.Annotatable;
	import org.as3commons.lang.ICloneable;

	/**
	 * as3commons-bytecode representation of <code>traits_info</code> in the ABC file format, which is the base type for all kinds of object traits
	 * (both class and instance traits).
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Trait" in the AVM Spec (page 29)
	 */
	public class TraitInfo extends Annotatable {

		public var traitMultiname:QualifiedName;
		public var traitKind:TraitKind;
		public var isFinal:Boolean;
		public var isOverride:Boolean;

		public function TraitInfo() {
			super();
		}

		override public function clone():* {
			throw new IllegalOperationError(NOT_IMPLEMENTED_ERROR);
		}

		override protected function populateClone(annotatable:Annotatable):void {
			super.populateClone(annotatable);
			var traitInfo:TraitInfo = TraitInfo(annotatable);
			traitInfo.traitMultiname = this.traitMultiname.clone();
			traitInfo.traitKind = this.traitKind;
			traitInfo.isFinal = this.isFinal;
			traitInfo.isOverride = this.isOverride;
		}

		public function get hasMetadata():Boolean {
			return (metadata.length > 0);
		}
	}
}