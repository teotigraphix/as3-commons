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
	import flash.utils.getTimer;

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

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AbstractAbcDeserializer implements IAbcDeserializer {
		private static const UTF8_BAD_PREFIX:String = "UTF8_BAD";

		private var _illegalCount:uint = 0;

		/**
		 * Creates a new <code>AbstractAbcDeserializer2</code> instance.
		 */
		public function AbstractAbcDeserializer(byteArray:ByteArray = null) {
			_byteStream = byteArray;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		protected var _byteStream:ByteArray;

		public function get byteStream():ByteArray {
			return _byteStream;
		}

		public function set byteStream(value:ByteArray):void {
			_byteStream = value;
		}

		// ----------------------------

		public function get methodBodyExtractionMethod():MethodBodyExtractionKind {
			return null;
		}

		public function set methodBodyExtractionMethod(value:MethodBodyExtractionKind):void {
		}

		// ----------------------------

		private var _constantPoolEndPosition:uint = 0;

		public function get constantPoolEndPosition():uint {
			return _constantPoolEndPosition;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function deserializeConstantPool(pool:IConstantPool):IConstantPool {
			CONFIG::debug {
				var startTime:Number = getTimer();
				trace("Deserialize constant pool");
			}

			var itemCount:int;
			var i:uint;
			var result:int;
			var kind:uint;
			var ints:Array = pool.integerPool;
			var uints:Array = pool.uintPool;
			var doubles:Array = pool.doublePool;
			var strings:Array = pool.stringPool;
			var namespaces:Array = pool.namespacePool;
			var namespaceSets:Array = pool.namespaceSetPool;
			var multiNames:Vector.<BaseMultiname> = pool.multinamePool;

			/* READ integerpool */
			include "readU32.as.tmpl";
			i = 1;
			itemCount = result;
			while (i < itemCount) {
				include "readU32.as.tmpl";
				ints[i++] = result;
			}

			CONFIG::debug {
				logConstantPoolRead("ints", startTime);
			}
			/* END:READ integerpool */

			/* READ uintpool */
			include "readU32.as.tmpl";
			i = 1;
			itemCount = result;
			while (i < itemCount) {
				include "readU32.as.tmpl";
				uints[i++] = result;
			}

			CONFIG::debug {
				logConstantPoolRead("uints", startTime);
			}

			/* END:READ uintpool */

			/* READ doublepool */
			include "readU32.as.tmpl";
			i = 1;
			itemCount = result;
			while (i < itemCount) {
				doubles[i++] = _byteStream.readDouble();
			}
			/* END:READ doublepool */

			/* READ stringpool */
			include "readU32.as.tmpl";
			i = 1;
			itemCount = result;
			while (i < itemCount) {
				include "readU32.as.tmpl";
				strings[i++] = _byteStream.readUTFBytes(result);
			}
			CONFIG::debug {
				logConstantPoolRead("strings", startTime);
			}
			/* END:READ stringpool */

			/* READ namespacepool */
			include "readU32.as.tmpl";
			i = 1;
			itemCount = result;
			while (i < itemCount) {
				kind = 0xff & _byteStream[_byteStream.position++];
				include "readU32.as.tmpl";
				namespaces[i++] = new LNamespace(NamespaceKind.determineKind(kind), strings[result]);
			}
			CONFIG::debug {
				logConstantPoolRead("namespaces", startTime);
			}
			/* END:READ namespacepool */

			/* READ namespacesetpool */
			include "readU32.as.tmpl";
			i = 1;
			itemCount = result;
			while (i < itemCount) {
				include "readU32.as.tmpl";
				var namespaceIndexRefCount:int = result;
				var namespaceArray:Array = [];
				while (--namespaceIndexRefCount - (-1)) {
					include "readU32.as.tmpl";
					namespaceArray[namespaceArray.length] = namespaces[result];
				}
				namespaceSets[i++] = new NamespaceSet(namespaceArray);
			}
			CONFIG::debug {
				logConstantPoolRead("namespace sets", startTime);
			}
			/* END:READ namespacesetpool */

			/* READ multiNames */
			var name:String;
			include "readU32.as.tmpl";
			i = 1;
			itemCount = result;
			while (i < itemCount) {
				kind = 0xff & _byteStream[_byteStream.position++];
				//QNAME or QNAME_A
				if ((kind == 0x07) || (kind == 0x0D)) {
					include "readU32.as.tmpl";
					var ns:LNamespace = namespaces[result];
					include "readU32.as.tmpl";
					multiNames[i] = new QualifiedName(strings[result], ns, (kind == 0x07) ? MultinameKind.QNAME : MultinameKind.QNAME_A);
					//RTQName or RTQName_A
				} else if ((kind == 0x0f) || (kind == 0x10)) {
					include "readU32.as.tmpl";
					multiNames[i] = new RuntimeQualifiedName(strings[result], (kind == 0x0f) ? MultinameKind.RTQNAME : MultinameKind.RTQNAME_A);
				} else if ((kind == 0x11) || (kind == 0x12)) {
					//RTQNAME_L or RTQNAME_LA
					multiNames[i] = new RuntimeQualifiedNameL((kind == 0x11) ? MultinameKind.RTQNAME_L : MultinameKind.RTQNAME_LA);
				} else if ((kind == 0x09) || (kind == 0x0E)) {
					//MULTINAME or MULTINAME_A
					include "readU32.as.tmpl";
					name = strings[result];
					include "readU32.as.tmpl";
					var nss:NamespaceSet = namespaceSets[result];
					multiNames[i] = new Multiname(name, nss, (kind == 0x09) ? MultinameKind.MULTINAME : MultinameKind.MULTINAME_A);
				} else if ((kind == 0x1B) || (kind == 0x1C)) {
					//MULTINAME_L or MULTINAME_LA
					include "readU32.as.tmpl";
					multiNames[i] = new MultinameL(namespaceSets[result], (kind == 0x1B) ? MultinameKind.MULTINAME_L : MultinameKind.MULTINAME_LA);
				} else if (kind == 0x1D) {
					//GENERIC
					include "readU32.as.tmpl";
					var qualifiedName:QualifiedName = multiNames[result] as QualifiedName;
					include "readU32.as.tmpl";
					var paramCount:uint = result;
					var params:Array = [];
					while (paramCount--) {
						include "readU32.as.tmpl";
						params[params.length] = multiNames[result];
					}
					multiNames[i] = new MultinameG(qualifiedName, paramCount, params, MultinameKind.GENERIC)
				}
				i++;
			}

			CONFIG::debug {
				logConstantPoolRead("multinames", startTime);
			}

			/* END:READ multiNames */

			_constantPoolEndPosition = _byteStream.position;

			CONFIG::debug {
				trace("Constants pool deserialized")
			}

			return pool;
		}

		public function deserialize(positionInByteArrayToReadFrom:int = 0):AbcFile {
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

		public function deserializeTraitsInfo(abcFile:AbcFile, byteStream:ByteArray, isStatic:Boolean = false, className:String = ""):Array {
			return null;
		}

		CONFIG::debug {
			private static function logConstantPoolRead(name:String, startTime:Number):void {
				trace(" - " + name + " read at " + (getTimer() - startTime) + " ms");
			}
		}

	}
}
