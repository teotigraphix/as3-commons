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
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.swf.SWFFile;
	import org.as3commons.bytecode.tags.DoABCTag;

	public final class AbcFileUtil {

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
	}
}