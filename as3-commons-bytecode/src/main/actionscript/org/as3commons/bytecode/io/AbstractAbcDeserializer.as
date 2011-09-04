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
package org.as3commons.bytecode.io {
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.MultinameL;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedNameL;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Takes an ABC bytecode block as a stream of bytes and converts it in to a as3commons-bytecode representation of the ABC file format. This
	 * class is the symmetric opposite of <code>AbcSerializer</code>.
	 *
	 * <p>
	 * Bytecode can be loaded either from the file system or a SWF file and handed to this object for deserialization.
	 * </p>
	 *
	 * @see    AbcSerializer
	 */
	//TODO: Capture ranges for bytecode blocks so they can be checked in unit tests
	public class AbstractAbcDeserializer implements IAbcDeserializer {

		private static const ASSERT_EXTRACTION_ERROR:String = "Expected {0} elements in {1}, actual count is {2}";
		private static const METHOD_NOT_IMPLEMENTED_ERROR:String = "method not implemented in abstract base class";
		protected var _byteStream:ByteArray;
		protected var extractionMethods:Dictionary;

		public function AbstractAbcDeserializer(byteStream:ByteArray=null) {
			super();
			initAbstractAbcDeserializer(byteStream);
		}

		private function initAbstractAbcDeserializer(byteStream:ByteArray):void {
			_byteStream = byteStream;
			extractionMethods = new Dictionary();
			extractionMethods[MultinameKind.QNAME] = extractQName;
			extractionMethods[MultinameKind.QNAME_A] = extractQName;
			extractionMethods[MultinameKind.MULTINAME] = extractMultiname;
			extractionMethods[MultinameKind.MULTINAME_A] = extractMultiname;
			extractionMethods[MultinameKind.MULTINAME_L] = extractMultinameL;
			extractionMethods[MultinameKind.MULTINAME_LA] = extractMultinameL;
			extractionMethods[MultinameKind.RTQNAME] = extractRuntimeQualifiedName;
			extractionMethods[MultinameKind.RTQNAME_A] = extractRuntimeQualifiedName;
			extractionMethods[MultinameKind.RTQNAME_L] = extractRuntimeQualifiedNameL;
			extractionMethods[MultinameKind.RTQNAME_LA] = extractRuntimeQualifiedNameL;
			extractionMethods[MultinameKind.GENERIC] = extractMultinameG;
		}

		private var _constantPoolEndPosition:uint = 0;

		public function get constantPoolEndPosition():uint {
			return _constantPoolEndPosition;
		}

		protected function setSonstantPoolEndPosition(value:uint):void {
			_constantPoolEndPosition = value;
		}

		public function deserialize(positionInByteArrayToReadFrom:int=0):AbcFile {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function deserializeClassInfos(abcFile:AbcFile, pool:IConstantPool, classCount:int):void {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function deserializeInstanceInfo(abcFile:AbcFile, pool:IConstantPool):int {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function deserializeMetadata(abcFile:AbcFile, pool:IConstantPool):void {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function deserializeMethodBodies(abcFile:AbcFile, pool:IConstantPool):void {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function deserializeMethodInfos(abcFile:AbcFile, pool:IConstantPool):void {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function deserializeScriptInfos(abcFile:AbcFile):void {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function deserializeTraitsInfo(abcFile:AbcFile, byteStream:ByteArray, isStatic:Boolean=false, className:String=""):Array {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function get methodBodyExtractionMethod():MethodBodyExtractionKind {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function set methodBodyExtractionMethod(value:MethodBodyExtractionKind):void {
			throw new IllegalOperationError(METHOD_NOT_IMPLEMENTED_ERROR);
		}

		public function get byteStream():ByteArray {
			return _byteStream;
		}

		public function set byteStream(value:ByteArray):void {
			_byteStream = value;
		}

		/**
		 * Acts as a guard to make sure that the expected number of items was extracted from the
		 * ABC file.
		 */
		private function assertExtraction(expectedCount:int, elementCollection:Array, collectionName:String):void {
			if (expectedCount == 0) {
				// the spec says: "Each of the count entries (for example, int_count) must be one more than
				// the number of entries in the corresponding array, and the first entry in the array is element “1”."
				// this is a lie. If the count is 0, then there are no entries in the pool in this ABC file.
			} else {
				var collectionLength:int = elementCollection.length;
				if (expectedCount != collectionLength) {
					throw new Error(StringUtils.substitute(ASSERT_EXTRACTION_ERROR, expectedCount, collectionName, collectionLength));
				}
			}
		}

		public function deserializeConstantPool(pool:IConstantPool):IConstantPool {
			extract(_byteStream, pool.integerPool, readS32);
			extract(_byteStream, pool.uintPool, readU32);
			extract(_byteStream, pool.doublePool, readD64);
			extract(_byteStream, pool.stringPool, readStringInfo);

			extractNamespaces(pool);

			extractNamespaceSets(pool);

			extractMultinames(pool);

			pool.initializeLookups();

			_constantPoolEndPosition = _byteStream.position;

			return pool;
		}

		protected function extractMultinames(pool:IConstantPool):void {
			extract(_byteStream, pool.multinamePool, function():BaseMultiname {
				var kind:MultinameKind = MultinameKind.determineKind(readU8());
				return extractionMethods[kind](pool, kind);
			});
		}

		protected function extractMultinameG(pool:IConstantPool, kind:MultinameKind):MultinameG {
			var qualifiedName:QualifiedName = pool.multinamePool[readU30()];
			var paramCount:uint = readU30();
			var params:Array = [];
			for (var idx:uint = 0; idx < paramCount; ++idx) {
				params[params.length] = pool.multinamePool[readU30()];
				CONFIG::debug {
					Assert.notNull(params[params.length - 1]);
				}
			}
			return new MultinameG(qualifiedName, paramCount, params, kind);
		}

		protected function extractRuntimeQualifiedNameL(pool:IConstantPool, kind:MultinameKind):RuntimeQualifiedNameL {
			// multiname_kind_RTQNameL 
			// { 
			// }
			return new RuntimeQualifiedNameL(kind);
		}

		protected function extractRuntimeQualifiedName(pool:IConstantPool, kind:MultinameKind):RuntimeQualifiedName {
			// multiname_kind_RTQName 
			// { 
			//  u30 name 
			// }
			return new RuntimeQualifiedName(pool.stringPool[readU30()], kind);
		}

		protected function extractMultinameL(pool:IConstantPool, kind:MultinameKind):MultinameL {
			// multiname_kind_MultinameL 
			// { 
			//  u30 ns_set 
			// }
			return new MultinameL(pool.namespaceSetPool[readU30()], kind);
		}

		protected function extractMultiname(pool:IConstantPool, kind:MultinameKind):Multiname {
			// multiname_kind_Multiname 
			// { 
			//  u30 name 
			//  u30 ns_set 
			// }
			return new Multiname(pool.stringPool[readU30()], pool.namespaceSetPool[readU30()], kind);
		}

		protected function extractQName(pool:IConstantPool, kind:MultinameKind):QualifiedName {
			// multiname_kind_QName 
			// { 
			//  u30 ns 
			//  u30 name 
			// }
			var idx:uint = readU30();
			var ns:LNamespace = pool.namespacePool[idx];
			CONFIG::debug {
				Assert.notNull(ns);
			}
			var name:String = pool.stringPool[readU30()];
			CONFIG::debug {
				Assert.notNull(name);
			}
			return new QualifiedName(name, ns, kind);
		}

		protected function extractNamespaces(pool:IConstantPool):void {
			// extract namespaces
			extract(_byteStream, pool.namespacePool, function():LNamespace {
				return new LNamespace(NamespaceKind.determineKind(readU8()), pool.stringPool[readU30()]);
			});
		}

		protected function extractNamespaceSets(pool:IConstantPool):void {
			// extract namespace sets
			extract(_byteStream, pool.namespaceSetPool, function():NamespaceSet {
				var namespaceIndexRefCount:int = readU30();
				var namespaceArray:Array = [];
				for (var nssetNamespaceIndex:int = 0; nssetNamespaceIndex < namespaceIndexRefCount; ++nssetNamespaceIndex) {
					namespaceArray[namespaceArray.length] = pool.namespacePool[readU30()];
					CONFIG::debug {
						Assert.notNull(namespaceArray[namespaceArray.length - 1]);
					}
				}
				return new NamespaceSet(namespaceArray);
			});
		}

		public function extract(byteStream:ByteArray, pool:Array, extractionMethod:Function):void {
			var itemCount:int = readU30();
			for (var itemIndex:uint = 1; itemIndex < itemCount; ++itemIndex) {
				try {
					var result:* = extractionMethod.apply(this);
					pool[pool.length] = result;
					CONFIG::debug {
						Assert.notNull(pool[pool.length - 1], "null was extracted at position " + itemIndex);
					}
				} catch (e:Error) {
					throw new Error("I choked at position: " + itemIndex);
				}
			}
			assertExtraction(itemCount, pool, "");
		}

		public function skipU16():void {
			AbcSpec.skipU16(_byteStream);
		}

		public function readU16():uint {
			return AbcSpec.readU16(_byteStream);
		}

		public function skipU30():void {
			AbcSpec.skipU30(_byteStream);
		}

		public function readU30():uint {
			return AbcSpec.readU30(_byteStream);
		}

		public function skipU32():void {
			AbcSpec.skipU32(_byteStream);
		}

		public function readU32():uint {
			return AbcSpec.readU32(_byteStream);
		}

		public function skipD64():void {
			AbcSpec.skipD64(_byteStream);
		}

		public function readD64():Number {
			return AbcSpec.readD64(_byteStream);
		}

		public function skipS32():void {
			AbcSpec.skipS32(_byteStream);
		}

		public function readS32():int {
			return AbcSpec.readS32(_byteStream);
		}

		public function skipU8():void {
			AbcSpec.skipU8(_byteStream);
		}

		public function readU8():uint {
			return AbcSpec.readU8(_byteStream);
		}

		public function skipStringInfo():void {
			AbcSpec.skipStringInfo(_byteStream);
		}

		public function readStringInfo():String {
			return AbcSpec.readStringInfo(_byteStream);
		}
	}
}
