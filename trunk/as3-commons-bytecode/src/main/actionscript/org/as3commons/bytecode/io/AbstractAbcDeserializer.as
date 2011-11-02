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

	import flash.utils.ByteArray;

	import org.as3commons.bytecode.abc.AbcFile;
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

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AbstractAbcDeserializer implements IAbcDeserializer {
		private static const UTF8_BAD_PREFIX:String = "UTF8_BAD";

		protected var _byteStream:ByteArray;
		private var _constantPoolEndPosition:uint = 0;
		private var _illegalCount:uint = 0;

		/**
		 * Creates a new <code>AbstractAbcDeserializer2</code> instance.
		 */
		public function AbstractAbcDeserializer(byteArray:ByteArray=null) {
			super();
			_byteStream = byteArray;
		}

		public function get byteStream():ByteArray {
			return _byteStream;
		}

		public function set byteStream(value:ByteArray):void {
			_byteStream = value;
		}

		public function get methodBodyExtractionMethod():MethodBodyExtractionKind {
			return null;
		}

		public function set methodBodyExtractionMethod(value:MethodBodyExtractionKind):void {
		}

		public function get constantPoolEndPosition():uint {
			return _constantPoolEndPosition;
		}

		public function deserializeConstantPool(pool:IConstantPool):IConstantPool {
			/* READ integerpool */
			var itemCount:int;

			var result:int;
			include "readU32.as.tmpl";
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				include "readU32.as.tmpl";
				pool.integerPool[pool.integerPool.length] = result;
			}
			/* END:READ integerpool */

			/* READ uintpool */
			include "readU32.as.tmpl";
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				var uresult:uint = _byteStream.readUnsignedByte();
				if ((uresult & 0x00000080)) {
					uresult = uresult & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((uresult & 0x00004000)) {
						uresult = uresult & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((uresult & 0x00200000)) {
							uresult = uresult & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((uresult & 0x10000000)) {
								uresult = uresult & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				pool.uintPool[pool.uintPool.length] = uresult;
			}
			/* END:READ uintpool */

			/* READ doublepool */
			include "readU32.as.tmpl";
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				pool.doublePool[pool.doublePool.length] = _byteStream.readDouble();
			}
			/* END:READ doublepool */

			/* READ stringpool */
			include "readU32.as.tmpl";
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				include "readU32.as.tmpl";
				var str:String = _byteStream.readUTFBytes(result);
				if (result != str.length) {
					str = UTF8_BAD_PREFIX + (_illegalCount++).toString();
				}
				pool.stringPool[pool.stringPool.length] = str;
			}
			/* END:READ stringpool */

			/* READ namespacepool */
			include "readU32.as.tmpl";
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				var kind:uint = 255 & _byteStream[_byteStream.position++];
				include "readU32.as.tmpl";
				pool.namespacePool[pool.namespacePool.length] = new LNamespace(NamespaceKind.determineKind(kind), pool.stringPool[result]);
			}
			/* END:READ namespacepool */

			/* READ namespacesetpool */
			include "readU32.as.tmpl";
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				include "readU32.as.tmpl";
				var namespaceIndexRefCount:int = result;
				var namespaceArray:Array = [];
				while (--namespaceIndexRefCount - (-1)) {
					include "readU32.as.tmpl";
					namespaceArray[namespaceArray.length] = pool.namespacePool[result];
				}
				pool.namespaceSetPool[pool.namespaceSetPool.length] = new NamespaceSet(namespaceArray);
			}
			/* END:READ namespacesetpool */

			/* READ multinamepool */
			include "readU32.as.tmpl";
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				kind = 255 & _byteStream[_byteStream.position++];
				//QNAME or QNAME_A
				if ((kind == 0x07) || (kind == 0x0D)) {
					include "readU32.as.tmpl";
					var ns:LNamespace = pool.namespacePool[result] as LNamespace;
					include "readU32.as.tmpl";
					var name:String = pool.stringPool[result] as String;
					pool.multinamePool[pool.multinamePool.length] = new QualifiedName(name, ns, (kind == 0x07) ? MultinameKind.QNAME : MultinameKind.QNAME_A);
						//RTQName or RTQName_A
				} else if ((kind == 0x0f) || (kind == 0x10)) {
					include "readU32.as.tmpl";
					str = pool.stringPool[result] as String;
					pool.multinamePool[pool.multinamePool.length] = new RuntimeQualifiedName(str, (kind == 0x0f) ? MultinameKind.RTQNAME : MultinameKind.RTQNAME_A);
				} else if ((kind == 0x11) || (kind == 0x12)) {
					//RTQNAME_L or RTQNAME_LA
					pool.multinamePool[pool.multinamePool.length] = new RuntimeQualifiedNameL((kind == 0x11) ? MultinameKind.RTQNAME_L : MultinameKind.RTQNAME_LA);
				} else if ((kind == 0x09) || (kind == 0x0E)) {
					//MULTINAME or MULTINAME_A
					include "readU32.as.tmpl";
					str = pool.stringPool[result] as String;
					include "readU32.as.tmpl";
					var nss:NamespaceSet = pool.namespaceSetPool[result] as NamespaceSet;
					pool.multinamePool[pool.multinamePool.length] = new Multiname(str, nss, (kind == 0x09) ? MultinameKind.MULTINAME : MultinameKind.MULTINAME_A);
				} else if ((kind == 0x1B) || (kind == 0x1C)) {
					//MULTINAME_L or MULTINAME_LA
					include "readU32.as.tmpl";
					pool.multinamePool[pool.multinamePool.length] = new MultinameL(pool.namespaceSetPool[result], (kind == 0x1B) ? MultinameKind.MULTINAME_L : MultinameKind.MULTINAME_LA);
				} else if (kind == 0x1D) {
					//GENERIC
					include "readU32.as.tmpl";
					var qualifiedName:QualifiedName = pool.multinamePool[result] as QualifiedName;
					include "readU32.as.tmpl";
					var paramCount:uint = result;
					var params:Array = [];
					while (paramCount--) {
						include "readU32.as.tmpl";
						params[params.length] = pool.multinamePool[result];
					}
					pool.multinamePool[pool.multinamePool.length] = new MultinameG(qualifiedName, paramCount, params, MultinameKind.GENERIC)
				}
			}
			/* END:READ multinamepool */

			_constantPoolEndPosition = _byteStream.position;

			return pool;
		}

		public function deserialize(positionInByteArrayToReadFrom:int=0):AbcFile {
			return null;
		}

		public function deserializeClassInfos(abcFile:AbcFile, pool:IConstantPool, classCount:int):void {
		}

		public function deserializeMethodBodies(abcFile:AbcFile, pool:IConstantPool):void {
		}

		public function deserializeScriptInfos(abcFile:AbcFile):void {
		}

		public function deserializeInstanceInfo(abcFile:AbcFile, pool:IConstantPool):int {
			return 0;
		}

		public function deserializeMetadata(abcFile:AbcFile, pool:IConstantPool):void {
		}

		public function deserializeMethodInfos(abcFile:AbcFile, pool:IConstantPool):void {
		}

		public function deserializeTraitsInfo(abcFile:AbcFile, byteStream:ByteArray, isStatic:Boolean=false, className:String=""):Array {
			return null;
		}

	}
}
