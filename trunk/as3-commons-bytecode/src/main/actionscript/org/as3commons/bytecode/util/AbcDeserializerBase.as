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
	import flash.utils.ByteArray;

	import mx.formatters.SwitchSymbolFormatter;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.FunctionTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.MultinameL;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedNameL;
	import org.as3commons.bytecode.abc.ScriptInfo;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ClassConstant;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.abc.enum.TraitAttributes;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.lang.StringUtils;

	/**
	 * Takes an ABC bytecode block as a stream of bytes and converts it in to a Loom representation of the ABC file format. This
	 * class is the symmetric opposite of <code>AbcSerializer</code>.
	 *
	 * <p>
	 * Bytecode can be loaded either from the file system or a SWF file and handed to this object for deserialization.
	 * </p>
	 *
	 * @see    AbcSerializer
	 */
	//TODO: Capture ranges for bytecode blocks so they can be checked in unit tests
	public class AbcDeserializerBase {
		protected var _byteStream:ByteArray;

		public function AbcDeserializerBase(byteStream:ByteArray = null) {
			_byteStream = byteStream;
		}

		protected function get byteStream():ByteArray {
			return _byteStream;
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
					throw new Error(StringUtils.substitute("Expected {0} elements in {1}, actual count is {2}", expectedCount, collectionName, collectionLength));
				}
			}
		}

		public function deserializeConstantPool(pool:ConstantPool):ConstantPool {
			extract(_byteStream, pool.integerPool, readS32);
			extract(_byteStream, pool.uintPool, readU32);
			extract(_byteStream, pool.doublePool, readD64);
			extract(_byteStream, pool.stringPool, readStringInfo);

			// extract namespaces
			extract(_byteStream, pool.namespacePool, function():LNamespace {
					return new LNamespace(NamespaceKind.determineKind(readU8()), pool.stringPool[readU30()]);
				});

			// extract namespace sets
			extract(_byteStream, pool.namespaceSetPool, function():NamespaceSet {
					var namespaceIndexRefCount:int = readU30();
					var namespaceArray:Array = [];
					for (var nssetNamespaceIndex:int = 0; nssetNamespaceIndex < namespaceIndexRefCount; nssetNamespaceIndex++) {
						namespaceArray.push(pool.namespacePool[readU30()]);
					}
					return new NamespaceSet(namespaceArray);
				});

			// extract multinames
			extract(_byteStream, pool.multinamePool, function():BaseMultiname {
					var multiname:BaseMultiname = null;

					var kind:MultinameKind = MultinameKind.determineKind(readU8());
					switch (kind) {
						case MultinameKind.QNAME:
						case MultinameKind.QNAME_A:
							// multiname_kind_QName 
							// { 
							//  u30 ns 
							//  u30 name 
							// }
							var nameSpace:LNamespace = pool.namespacePool[readU30()];
							multiname = new QualifiedName(pool.stringPool[readU30()], nameSpace, kind);
							break;

						case MultinameKind.MULTINAME:
						case MultinameKind.MULTINAME_A:
							// multiname_kind_Multiname 
							// { 
							//  u30 name 
							//  u30 ns_set 
							// }
							multiname = new Multiname(pool.stringPool[readU30()], pool.namespaceSetPool[readU30()], kind);
							break;

						case MultinameKind.MULTINAME_L:
						case MultinameKind.MULTINAME_LA:
							// multiname_kind_MultinameL 
							// { 
							//  u30 ns_set 
							// }
							multiname = new MultinameL(pool.namespaceSetPool[readU30()], kind);
							break;

						case MultinameKind.RTQNAME:
						case MultinameKind.RTQNAME_A:
							// multiname_kind_RTQName 
							// { 
							//  u30 name 
							// }
							multiname = new RuntimeQualifiedName(pool.stringPool[readU30()], kind);
							break;

						case MultinameKind.RTQNAME_L:
						case MultinameKind.RTQNAME_LA:
							// multiname_kind_RTQNameL 
							// { 
							// }
							multiname = new RuntimeQualifiedNameL(kind);
							break;
						case MultinameKind.GENERIC:
							var qualifiedName:QualifiedName = pool.multinamePool[readU30()];
							var paramCount:uint = readU30();
							var params:Array = [];
							for (var i:uint = 0; i < paramCount; i++) {
								params[params.length] = pool.multinamePool[readU30()];
							}
							multiname = new MultinameG(qualifiedName, paramCount, params, kind);
							break;
					}

					return multiname;
				});

			return pool;
		}

		public function convertToQualifiedName(classMultiname:BaseMultiname):QualifiedName {
			if (classMultiname is QualifiedName) {
				return classMultiname as QualifiedName;
			}

			var qualifiedName:QualifiedName = null;
			if (classMultiname is Multiname) {
				// A QualifiedName can only have one namespace, so we ensure that this is the case
				// before attempting conversion
				var classMultinameAsMultiname:Multiname = classMultiname as Multiname;
				if (classMultinameAsMultiname.namespaceSet.namespaces.length == 1) {
					qualifiedName = new QualifiedName(classMultinameAsMultiname.name, classMultinameAsMultiname.namespaceSet.namespaces[0]);
				} else {
					trace("Multiname " + classMultiname + " has more than 1 namespace in its namespace set - unable to convert to QualifiedName.");
				}
			} else if (classMultiname is MultinameG) {
				qualifiedName = (classMultiname as MultinameG).qualifiedName;
			}

			return qualifiedName;
		}

		public function extract(byteStream:ByteArray, pool:Array, extractionMethod:Function):void {
			var itemCount:int = readU30();
			for (var itemIndex:int = 1; itemIndex < itemCount; itemIndex++) {
				var result:* = extractionMethod.apply(this);
				pool.push(result);
			}
			assertExtraction(itemCount, pool, "");
		}

		public function readU16():uint {
			return AbcSpec.readU16(_byteStream);
		}

		public function readU30():uint {
			return AbcSpec.readU30(_byteStream);
		}

		public function readU32():uint {
			return AbcSpec.readU32(_byteStream);
		}

		public function readD64():Number {
			return AbcSpec.readD64(_byteStream);
		}

		public function readS32():int {
			return AbcSpec.readS32(_byteStream);
		}

		public function readU8():uint {
			return AbcSpec.readU8(_byteStream);
		}

		public function readStringInfo():String {
			return AbcSpec.readStringInfo(_byteStream);
		}
	}
}