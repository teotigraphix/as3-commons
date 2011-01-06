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
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.emit.INamespaceBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.util.MultinameUtil;

	public class NamespaceBuilder implements INamespaceBuilder {

		private var _scopeName:String;
		private var _URI:String;
		private var _packageName:String;

		public function NamespaceBuilder() {
			super();
		}

		public function get packageName():String {
			return _packageName;
		}

		public function set packageName(value:String):void {
			_packageName = value;
		}

		public function get scopeName():String {
			return _scopeName;
		}

		public function set scopeName(value:String):void {
			_scopeName = value;
		}

		public function get URI():String {
			return _URI;
		}

		public function set URI(value:String):void {
			_URI = value;
		}

		public function build():SlotOrConstantTrait {
			var slot:SlotOrConstantTrait = new SlotOrConstantTrait();
			var ns:LNamespace = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, packageName);
			slot.traitMultiname = new QualifiedName(scopeName, ns);
			slot.defaultValue = new LNamespace(NamespaceKind.NAMESPACE, URI);
			slot.traitKind = TraitKind.SLOT;
			slot.typeMultiname = MultinameUtil.toQualifiedName(BuiltIns.ANY.fullName, NamespaceKind.NAMESPACE);
			return slot;
		}
	}
}