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
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.StringUtils;

	public class PropertyBuilder extends EmitMember implements IPropertyBuilder {

		public function PropertyBuilder() {
			super();
		}

		private var _type:String;

		private var _initialValue:*;

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function build():Object {
			return buildTrait();
		}

		public function get initialValue():* {
			return _initialValue;
		}

		public function set initialValue(value:*):void {
			_initialValue = value;
		}

		override protected function buildTrait():TraitInfo {
			var trait:SlotOrConstantTrait = new SlotOrConstantTrait();
			trait.addMetadataList(buildMetadata());
			trait.isFinal = isFinal;
			trait.isOverride = isOverride;
			trait.traitKind = (isConstant) ? TraitKind.CONST : TraitKind.SLOT;
			trait.isStatic = isStatic;
			trait.typeMultiname = MultinameUtil.toQualifiedName(_type);
			var ns:LNamespace;
			if (!(StringUtils.hasText(namespace))) {
				ns = new LNamespace(NAMESPACEKIND_LOOKUP[visibility], "");
			} else {
				ns = new LNamespace(NamespaceKind.NAMESPACE, namespace);
			}
			trait.traitMultiname = new QualifiedName(name, ns);
			if (_initialValue === undefined) {
				trait.vindex = 0;
			} else {
				trait.vkind = ConstantKind.determineKindFromInstance(_initialValue);
				trait.defaultValue = _initialValue;
			}
			return trait;
		}

	}
}