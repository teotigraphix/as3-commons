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
package org.as3commons.bytecode.util {
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.typeinfo.Annotatable;
	import org.as3commons.bytecode.typeinfo.ClassDefinition;
	import org.as3commons.bytecode.typeinfo.Field;
	import org.as3commons.bytecode.typeinfo.Getter;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.typeinfo.Method;
	import org.as3commons.bytecode.typeinfo.Setter;

	/**
	 * (Unfinished) Class for converting a <code>ClassDefinition</code> in to an <code>AbcFile</code> (and vice versa).
	 */
	public class ClassConverter {
		private var _classDefinition:ClassDefinition;
		private var _abcFile:AbcFile;

		public function ClassConverter(classDefinition:ClassDefinition) {
			_classDefinition = classDefinition;
		}

		public function convert():AbcFile {
			_abcFile = new AbcFile();
			_abcFile.minorVersion = 16;
			_abcFile.majorVersion = 46;

			createInstanceInfo();

			return _abcFile;
		}

		private function createInstanceInfo():void {
			var instanceInfo:InstanceInfo = new InstanceInfo();
			instanceInfo.classMultiname = _classDefinition.className;
			instanceInfo.superclassMultiname = _classDefinition.superClass;
			instanceInfo.protectedNamespace = new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, _classDefinition.className.nameSpace + ":" + _classDefinition.className.name);
			instanceInfo.isFinal = _classDefinition.isFinal;
			instanceInfo.isInterface = _classDefinition.isInterface;
			instanceInfo.isProtected = _classDefinition.isProtectedNamespace;
			instanceInfo.isSealed = _classDefinition.isSealed;
			instanceInfo.instanceInitializer; //TODO: need a way to register this method on the AbcFile and get a reference back

			for each (var interfaceMultiname:BaseMultiname in _classDefinition.interfaces) {
				instanceInfo.interfaceMultinames.push(interfaceMultiname);
			}

			// Every field gets a SlotOrConstantTrait
			for each (var field:Field in _classDefinition.instanceFields) {
				var fieldTrait:SlotOrConstantTrait = new SlotOrConstantTrait();
				fieldTrait.slotId = 0; // this is the way it always came out when dumping code from the compiler
				fieldTrait.vindex = 0; // same here - always 0
				fieldTrait.vkind = null; // same here - always null. Per the spec (page 30), this is null if vindex is 0
				fieldTrait.traitKind = TraitKind.SLOT; //TODO: what about const?
				fieldTrait.traitMultiname = field.fieldName;
				fieldTrait.typeMultiname = field.type;
				createMetadata(field, fieldTrait);

				instanceInfo.traits.push(fieldTrait);
			}

			// Every method gets a MethodTrait, MethodInfo, and MethodBody
			for each (var method:Method in _classDefinition.instanceMethods) {
				var methodTrait:MethodTrait = new MethodTrait();
				methodTrait.dispositionId = 0; // always this way in the compiler
				methodTrait.isFinal = method.isFinal;
				methodTrait.isOverride = method.isOverride;
				methodTrait.traitMultiname = method.methodName;
				methodTrait.traitMethod
				createMetadata(field, methodTrait);

				// Default to METHOD and clobber assignment if this is a GETTER or SETTER
				var kind:TraitKind = TraitKind.METHOD;
				if (method is Getter) {
					kind = TraitKind.GETTER;
				}
				if (method is Setter) {
					kind = TraitKind.SETTER;
				}
				methodTrait.traitKind = kind;

				instanceInfo.traits.push(methodTrait);
			}

			_abcFile.addInstanceInfo(instanceInfo);
		}

		private function createMetadata(source:Annotatable, target:Annotatable):void {
			for each (var metadata:Metadata in source.metadata) {
				target.addMetadata(metadata);
			}
		}
	}
}