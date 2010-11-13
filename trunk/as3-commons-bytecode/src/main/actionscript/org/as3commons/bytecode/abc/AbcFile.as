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
	import org.as3commons.bytecode.emit.asm.ClassInfoReference;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.typeinfo.ClassDefinition;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.typeinfo.Method;
	import org.as3commons.lang.Assert;

	/**
	 * as3commons-bytecode representation of the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "abcFile" in the AVM Spec (page 19)
	 */
	public class AbcFile {

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

		public function addClassInfoReference(classInfoReference:ClassInfoReference):int {
			var idx:int = 0;
			for each (var classInfo:ClassInfo in _classInfo) {
				if (classInfo.classMultiname.equals(classInfoReference.classMultiName)) {
					return idx;
				}
				idx++;
			}
			return -1;
		}


		public function addClassInfo(classInfo:ClassInfo):int {
			Assert.notNull(classInfo);
			return addUniquely(classInfo, _classInfo);
		}

		public function addClassInfos(classInfos:Array):void {
			Assert.notNull(classInfos);
			addCollection(addClassInfo, classInfos);
		}

		public function addMetadataInfo(metadata:Metadata):int {
			Assert.notNull(metadata);
			return addUniquely(metadata, _metadataInfo);
		}

		public function addMetadataInfos(metadatas:Array):void {
			Assert.notNull(metadatas);
			addCollection(addMetadataInfo, metadatas);
		}

		public function addMethodInfo(methodInfo:MethodInfo):int {
			Assert.notNull(methodInfo);
			return addUniquely(methodInfo, _methodInfo);
		}

		public function addMethodInfos(methodInfos:Array):void {
			Assert.notNull(methodInfos);
			addCollection(addMethodInfo, methodInfo);
		}

		public function addUniquely(itemToAdd:Object, collectionToAddTo:Array):int {
			var indexOfItem:int = collectionToAddTo.indexOf(itemToAdd);
			if (indexOfItem == -1) {
				indexOfItem = (collectionToAddTo.push(itemToAdd) - 1);
			}

			return indexOfItem;
		}

		public function addInstanceInfo(instanceInfo:InstanceInfo):int {
			Assert.notNull(instanceInfo);
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
			//Interface initializers don't have a method body, so check for null:
			if (instanceInfo.instanceInitializer.methodBody != null) {
				addMethodBody(instanceInfo.instanceInitializer.methodBody);
			}

			return addUniquely(instanceInfo, _instanceInfo);
		}

		public function addInstanceInfos(instanceInfos:Array):void {
			Assert.notNull(instanceInfos);
			addCollection(addInstanceInfo, instanceInfos);
		}

		public function addScriptInfo(scriptInfo:ScriptInfo):int {
			Assert.notNull(scriptInfo);
			return addUniquely(scriptInfo, _scriptInfo);
		}

		public function addScriptInfos(scriptInfos:Array):void {
			Assert.notNull(scriptInfos);
			addCollection(addScriptInfo, scriptInfos);
		}

		public function addMethodBody(methodBody:MethodBody):int {
			Assert.notNull(methodBody);
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

		protected function addCollection(addFunction:Function, collection:Array):void {
			for each (var obj:Object in collection) {
				addFunction(obj);
			}
		}

		public function toString():String {
			var strings:Array = [constantPool, "Method Signatures (MethodInfo):", "\t" + _methodInfo.join("\n\t"), metadataInfo.join("\n"), _instanceInfo.join("\n"), _classInfo.join("\n"), _scriptInfo.join("\n"), _methodBodies.join("\n")];

			return strings.join("\n");
		}
	}
}