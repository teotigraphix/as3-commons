/*
 * Copyright 2007-2011 the original author or authors.
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

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.swf.SWFFile;
	import org.as3commons.bytecode.tags.DoABCTag;

	/**
	 * Helper methods for modifying <code>ABCFiles</code>, <code>ConstantPools</code> and <code>SWFFile</code>.
	 * @author Roland Zwaga
	 */
	public final class AbcFileUtil {

		private static const SWF_HEADER:Array = [0x46, 0x57, 0x53, 0x10, // FWS, Version 10
			0xff, 0xff, 0xff, 0xff, // File length
			0x78, 0x00, 0x03, 0xe8, 0x00, 0x00, 0x0b, 0xb8, 0x00, // size [Rect 0 0 8000 6000]
			0x00, 0x0c, 0x01, 0x00, // 16bit le frame rate 12, 16bit be frame count 1
			0x44, 0x11, // Tag type=69 (FileAttributes), length=4
			0x08, 0x00, 0x00, 0x00];

		private static const ABC_HEADER:Array = [0x3f, 0x12]; // Tag type=72 (DoABC), length=next.]

		private static var SWF_FOOTER:Array = [0x40, 0x00]; // Tag type=1 (ShowFrame), length=0

		private static const INSTANCE_INITIALIZER_QNAME:String = "{instance initializer (constructor?)}";
		private static const PERIOD:String = '.';

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
			var abc:AbcFile = new AbcFile();
			var len:uint = files.length;
			for (var i:uint = 0; i < len; ++i) {
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
		public static function mergeConstantPools(pool1:IConstantPool, pool2:IConstantPool):IConstantPool {
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

		public static function getClassinfoByFullyQualifiedName(abcFile:AbcFile, fullName:String):ClassInfo {
			fullName = normalizeFullName(fullName);
			for each (var classInfo:ClassInfo in abcFile.classInfo) {
				if (classInfo.classMultiname.fullName == fullName) {
					return classInfo;
				}
			}
			return null;
		}

		public static function getInstanceinfoByFullyQualifiedName(abcFile:AbcFile, fullName:String):InstanceInfo {
			fullName = normalizeFullName(fullName);
			for each (var instanceInfo:InstanceInfo in abcFile.instanceInfo) {
				if (instanceInfo.classMultiname.fullName == fullName) {
					return instanceInfo;
				}
			}
			return null;
		}

		public static function normalizeFullName(fullName:String):String {
			return fullName.replace(MultinameUtil.DOUBLE_COLON_REGEXP, PERIOD);
		}

		/**
		 * Wraps the ABC bytecode inside the simplest possible SWF file, for the purpose of allowing the player
		 * VM to load it.
		 *
		 * @param   bytes an array or ABC bytecode blocks
		 * @return  a byte array containing the contents of a valid SWF file ready for loading in to the Flash Player
		 */
		public static function wrapBytecodeInSWF(arrayOfAbcByteCodeBlocks:Array):ByteArray {
			var outputStream:ByteArray = new ByteArray();
			outputStream.endian = Endian.LITTLE_ENDIAN;

			for each (var swfHeaderByte:int in SWF_HEADER) {
				outputStream.writeByte(swfHeaderByte);
			}

			for each (var abcByteCodeBlock:ByteArray in arrayOfAbcByteCodeBlocks) {
				for each (var abcHeaderByte:int in ABC_HEADER) {
					outputStream.writeByte(abcHeaderByte);
				}

				// set the length of the ABC bytecode block
				outputStream.writeInt(abcByteCodeBlock.length);
				outputStream.writeBytes(abcByteCodeBlock);
			}

			for each (var swfFooterByte:int in SWF_FOOTER) {
				outputStream.writeByte(swfFooterByte);
			}

			// set the length of the total SWF
			outputStream.position = 4;
			outputStream.writeInt(outputStream.length);

			outputStream.position = 0;
			return outputStream;
		}

	}
}