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

	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.typeinfo.ClassDefinition;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.typeinfo.Method;

	/**
	 * as3commons-bytecode representation of the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "abcFile" in the AVM Spec (page 19)
	 */
	public class AbcFile {
		private static const INSTANCE_INITIALIZER_QNAME:String = "{instance initializer (constructor?)}";
		private var _methodInfo:Array;
		private var _metadataInfo:Array;
		private var _instanceInfo:Array;
		private var _classInfo:Array;
		private var _scriptInfo:Array;
		private var _methodBodies:Array;

		public var minorVersion:int;
		public var majorVersion:int;
		public var constantPool:ConstantPool;

		public function AbcFile() {
			super();
			initAbcFile();
		}

		protected function initAbcFile():void {
			constantPool = new ConstantPool();
			_methodInfo = [];
			_metadataInfo = [];
			_instanceInfo = [];
			_classInfo = [];
			_scriptInfo = [];
			_methodBodies = [];
		}


		public function addClassInfo(classInfo:ClassInfo):int {
			return addUniquely(classInfo, _classInfo);
		}

		public function addMetadataInfo(metadata:Metadata):int {
			return addUniquely(metadata, _metadataInfo);
		}

		public function addMethodInfo(methodInfo:MethodInfo):int {
			return addUniquely(methodInfo, _methodInfo);
		}

		public function addUniquely(itemToAdd:Object, collectionToAddTo:Array):int {
			var indexOfItem:int = collectionToAddTo.indexOf(itemToAdd);
			if (indexOfItem == -1) {
				indexOfItem = collectionToAddTo.push(itemToAdd);
			}

			return indexOfItem;
		}

		public function addInstanceInfo(instanceInfo:InstanceInfo):int {
			constantPool.addMultiname(instanceInfo.classMultiname);
			for each (var name:BaseMultiname in instanceInfo.interfaceMultinames) {
				constantPool.addMultiname(name);
			}

			// The protected namespace might be null if the isProtected flag is false, so
			// we only add this if the isProtected flag is true 
			if (instanceInfo.isProtected) {
				constantPool.addNamespace(instanceInfo.protectedNamespace);
			}

			constantPool.addMultiname(instanceInfo.superclassMultiname);
			addMethodInfo(instanceInfo.instanceInitializer);

			return addUniquely(instanceInfo, _instanceInfo);
		}

		public function addScriptInfo(scriptInfo:ScriptInfo):int {
			return addUniquely(scriptInfo, _scriptInfo);
		}

		public function addMethodBody(methodBody:MethodBody):int {
			return addUniquely(methodBody, _methodBodies);
		}

		public function get metadataInfo():Array {
			return _metadataInfo;
		}

		as3commons_bytecode function setMetadataInfo(value:Array):void {
			_metadataInfo = value;
		}

		public function get methodInfo():Array {
			return _methodInfo;
		}

		as3commons_bytecode function setMethodInfo(value:Array):void {
			_methodInfo = value;
		}

		public function get instanceInfo():Array {
			return _instanceInfo;
		}

		as3commons_bytecode function setInstanceInfo(value:Array):void {
			_instanceInfo = value;
		}

		public function get classInfo():Array {
			return _classInfo;
		}

		as3commons_bytecode function setClassInfo(value:Array):void {
			_classInfo = value;
		}

		public function get scriptInfo():Array {
			return _scriptInfo;
		}

		as3commons_bytecode function setScriptInfo(value:Array):void {
			_scriptInfo = value;
		}

		public function get methodBodies():Array {
			return _methodBodies;
		}

		as3commons_bytecode function setMethodBodies(value:Array):void {
			_methodBodies = value;
		}

		//TODO: This would do better in a utility class that converts AbcFiles to ClassDefinitions
		public function get classDefinitions():Array {
			var classDefinitions:Array = [];

			for each (var currentInstanceInfo:InstanceInfo in instanceInfo) {
				var classDefinition:ClassDefinition = new ClassDefinition();
				classDefinition.className = currentInstanceInfo.classMultiname as QualifiedName;
				classDefinition.superClass = currentInstanceInfo.superclassMultiname as QualifiedName;
				classDefinition.isFinal = currentInstanceInfo.isFinal;
				classDefinition.isSealed = currentInstanceInfo.isSealed;
				classDefinition.isProtectedNamespace = currentInstanceInfo.isProtected;
				classDefinition.isInterface = currentInstanceInfo.isInterface;

				var instanceInitializer:MethodInfo = currentInstanceInfo.instanceInitializer;
				classDefinition.instanceInitializer = new Method(new QualifiedName(INSTANCE_INITIALIZER_QNAME, new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "")), instanceInitializer.returnType);
				classDefinition.instanceInitializer.setMethodBody(instanceInitializer.methodBody);

				for each (var methodTrait:MethodTrait in currentInstanceInfo.methodTraits) {
					var associatedMethodInfo:MethodInfo = methodTrait.traitMethod;
					var method:Method;
					switch (methodTrait.traitKind) {
						case TraitKind.GETTER:
							method = classDefinition.addGetter(methodTrait.traitMultiname, associatedMethodInfo.returnType, false, methodTrait.isOverride, methodTrait.isFinal);
							break;
						case TraitKind.SETTER:
							method = classDefinition.addSetter(methodTrait.traitMultiname, associatedMethodInfo.returnType, false, methodTrait.isOverride, methodTrait.isFinal);
							break;
						case TraitKind.METHOD:
							method = classDefinition.addMethod(methodTrait.traitMultiname, associatedMethodInfo.returnType, false, methodTrait.isOverride, methodTrait.isFinal);
							break;
						default:
							throw new Error("Unknown method trait kind: " + methodTrait.traitKind);
							break;
					}

					for each (var argument:Argument in associatedMethodInfo.argumentCollection) {
						method.addArgument(argument);
					}

					method.setMethodBody(associatedMethodInfo.methodBody);
				}

				for each (var slotOrConstant:SlotOrConstantTrait in currentInstanceInfo.slotOrConstantTraits) {
					classDefinition.addField(slotOrConstant.traitMultiname as QualifiedName, slotOrConstant.typeMultiname as QualifiedName);
				}

				var interfaces:Array = classDefinition.interfaces;
				for each (var interfaceMultiname:BaseMultiname in currentInstanceInfo.interfaceMultinames) {
					interfaces[interfaces.length] = interfaceMultiname;
				}

				classDefinitions[classDefinitions.length] = classDefinition;
			}

			return classDefinitions;
		}

		public function toString():String {
			var strings:Array = [constantPool, "Method Signatures (MethodInfo):", "\t" + _methodInfo.join("\n\t"), metadataInfo.join("\n"), _instanceInfo.join("\n"), _classInfo.join("\n"), _scriptInfo.join("\n"), _methodBodies.join("\n"),
				// classDefinitions.join("\n")
				];

			return strings.join("\n");
		}
	}
}