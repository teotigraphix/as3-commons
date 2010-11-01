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
package org.as3commons.bytecode.util {

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.swf.SWFFile;
	import org.as3commons.bytecode.tags.DoABCTag;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.typeinfo.ClassDefinition;
	import org.as3commons.bytecode.typeinfo.Method;

	/**
	 * Helper methods for modifying <code>ABCFiles</code>, <code>ConstantPools</code> and <code>SWFFile</code>.
	 * @author Roland Zwaga
	 */
	public final class AbcFileUtil {

		private static const INSTANCE_INITIALIZER_QNAME:String = "{instance initializer (constructor?)}";

		/**
		 * Searches the specified <code>SWFFile</code> for <code>DoABCTags</code>
		 * and merges all of them into one <code>DoABCTag</code>. This will safe some
		 * memory because the constant pools for the respective ABC tags will be merged as well.
		 * @param swf The specified <code>SWFFile</code> instance.
		 */
		public static function mergeAbcFilesInSWFFile(swf:SWFFile):void {
			var abcTags:Array = swf.getTagsByType(DoABCTag);
			if (abcTags.length < 2) {
				return;
			}
			var len:uint = abcTags.length;
			for (var i:uint = 1; i < len; ++i) {
				var idx:int = swf.tags.indexOf(abcTags[i]);
				if (idx > -1) {
					swf.tags.splice(idx, 1);
				}
			}
			var abcFiles:Array = [];
			for each (var tag:DoABCTag in abcTags) {
				abcFiles[abcFiles.length] = tag.abcFile;
			}
			DoABCTag(abcTags[0]).abcFile = mergeMultipleAbcFiles(abcFiles);
		}

		/**
		 * Merges the specified <code>Array</code> of <code>AbcFiles</code> into
		 * one <code>AbcFile</code> instance.
		 * @param files The specifed <code>Array</code> of <code>AbcFiles</code>.
		 * @return The merged <code>AbcFile</code> instance.
		 */
		public static function mergeMultipleAbcFiles(files:Array):AbcFile {
			if ((!files) || (files.length == 0)) {
				return null;
			}
			if (files.length == 1) {
				return files[0];
			}
			var abc:AbcFile = files[0];
			var len:uint = files.length;
			for (var i:uint = 1; i < len; ++i) {
				abc = mergeAbcFiles(abc, files[i]);
			}
			return abc;
		}

		/**
		 * Merges the specified <code>AbcFile</code> instances into one single <code>AbcFile</code> instance.
		 * @param file1 The first <code>AbcFile</code> instance.
		 * @param file2 The second <code>AbcFile</code> instance.
		 * @return The merged <code>AbcFile</code> instance.
		 */
		public static function mergeAbcFiles(file1:AbcFile, file2:AbcFile):AbcFile {
			var result:AbcFile = new AbcFile();
			result.majorVersion = file1.majorVersion;
			result.minorVersion = file1.minorVersion;
			result.constantPool = mergeConstantPools(file1.constantPool, file2.constantPool);
			result.as3commons_bytecode::setClassInfo(file1.classInfo.concat(file2.classInfo));
			result.as3commons_bytecode::setInstanceInfo(file1.instanceInfo.concat(file2.instanceInfo));
			result.as3commons_bytecode::setMetadataInfo(file1.metadataInfo.concat(file2.metadataInfo));
			result.as3commons_bytecode::setMethodBodies(file1.methodBodies.concat(file2.methodBodies));
			result.as3commons_bytecode::setMethodInfo(file1.methodInfo.concat(file2.methodInfo));
			result.as3commons_bytecode::setScriptInfo(file1.scriptInfo.concat(file2.scriptInfo));
			return result;
		}

		/**
		 * Merges the specified <code>ConstantPool</code> instances into one single <code>ConstantPool</code> instance.
		 * @param pool1 The first <code>ConstantPool</code> instance.
		 * @param pool2 The second <code>ConstantPool</code> instance.
		 * @return The merged <code>ConstantPool</code> instance.
		 */
		public static function mergeConstantPools(pool1:ConstantPool, pool2:ConstantPool):ConstantPool {
			var result:ConstantPool = new ConstantPool();
			result.as3commons_bytecode::setDoublePool(pool1.doublePool.concat([]));
			for each (var nr:Number in pool2.doublePool) {
				if (result.doublePool.indexOf(nr) < 0) {
					result.doublePool[result.doublePool.length] = nr;
				}
			}
			result.as3commons_bytecode::setIntegerPool(pool1.integerPool.concat([]));
			for each (var i:int in pool2.integerPool) {
				if (result.integerPool.indexOf(i) < 0) {
					result.integerPool[result.integerPool.length] = i;
				}
			}
			result.as3commons_bytecode::setMultinamePool(pool1.multinamePool.concat(pool2.multinamePool));
			result.as3commons_bytecode::setNamespacePool(pool1.namespacePool.concat(pool2.namespacePool));
			result.as3commons_bytecode::setNamespaceSetPool(pool1.namespaceSetPool.concat(pool2.namespaceSetPool));
			result.as3commons_bytecode::setStringPool(pool1.stringPool.concat([]));
			for each (var s:String in pool2.stringPool) {
				if (result.stringPool.indexOf(s) < 0) {
					result.stringPool[result.stringPool.length] = s;
				}
			}
			result.as3commons_bytecode::setUintPool(pool1.uintPool.concat([]));
			for each (var u:uint in pool2.uintPool) {
				if (result.uintPool.indexOf(u) < 0) {
					result.uintPool[result.uintPool.length] = u;
				}
			}

			return result;
		}

		public static function AbcFileToClassDefinitions(abcFile:AbcFile):Array {
			var classDefinitions:Array = [];

			for each (var currentInstanceInfo:InstanceInfo in abcFile.instanceInfo) {
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

	}
}