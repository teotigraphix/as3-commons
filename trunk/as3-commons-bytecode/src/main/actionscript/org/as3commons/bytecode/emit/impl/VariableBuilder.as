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
package org.as3commons.bytecode.emit.impl {

	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.emit.IVariableBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;

	public class VariableBuilder extends EmitMember implements IVariableBuilder {

		public function VariableBuilder() {
			super();
		}

		private var _type:String;

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function build():Object {
			return buildTrait();
		}

		override protected function buildTrait():TraitInfo {
			var trait:SlotOrConstantTrait = new SlotOrConstantTrait();
			trait.addMetadataList(buildMetadata());
			trait.isFinal = isFinal;
			trait.isOverride = isOverride;
			trait.traitKind = (isConstant) ? TraitKind.CONST : TraitKind.SLOT;
			return trait;
		}

	}
}