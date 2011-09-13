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

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AbstractAbcDeserializer2 implements IAbcDeserializer {
		private static const UTF8_BAD_PREFIX:String = "UTF8_BAD";

		var _byteArray:ByteArray;
		private var _constantPoolEndPosition:uint = 0;
		private var _illegalCount:uint = 0;

		/**
		 * Creates a new <code>AbstractAbcDeserializer2</code> instance.
		 */
		public function AbstractAbcDeserializer2(byteArray:ByteArray) {
			super();
			_byteArray = byteArray;
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
			var nextByte:int;
			var result:int = _byteArray.readUnsignedByte();
			if ((result & 0x00000080)) {
				nextByte = _byteArray.readUnsignedByte() << 7;
				result = result & 0x0000007f | nextByte;
				if ((result & 0x00004000)) {
					nextByte = _byteArray.readUnsignedByte() << 14;
					result = result & 0x00003fff | nextByte;
					if ((result & 0x00200000)) {
						nextByte = _byteArray.readUnsignedByte() << 21;
						result = result & 0x001fffff | nextByte;
						if ((result & 0x10000000)) {
							nextByte = _byteArray.readUnsignedByte() << 28;
							result = result & 0x0fffffff | nextByte;
						}
					}
				}
			}
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				result = _byteArray.readUnsignedByte();
				if ((result & 0x00000080)) {
					nextByte = _byteArray.readUnsignedByte() << 7;
					result = result & 0x0000007f | nextByte;
					if ((result & 0x00004000)) {
						nextByte = _byteArray.readUnsignedByte() << 14;
						result = result & 0x00003fff | nextByte;
						if ((result & 0x00200000)) {
							nextByte = _byteArray.readUnsignedByte() << 21;
							result = result & 0x001fffff | nextByte;
							if ((result & 0x10000000)) {
								nextByte = _byteArray.readUnsignedByte() << 28;
								result = result & 0x0fffffff | nextByte;
							}
						}
					}
				}
				pool.integerPool[pool.integerPool.length] = result;
			}
			/* END:READ integerpool */

			/* READ uintpool */
			result = _byteArray.readUnsignedByte();
			if ((result & 0x00000080)) {
				nextByte = _byteArray.readUnsignedByte() << 7;
				result = result & 0x0000007f | nextByte;
				if ((result & 0x00004000)) {
					nextByte = _byteArray.readUnsignedByte() << 14;
					result = result & 0x00003fff | nextByte;
					if ((result & 0x00200000)) {
						nextByte = _byteArray.readUnsignedByte() << 21;
						result = result & 0x001fffff | nextByte;
						if ((result & 0x10000000)) {
							nextByte = _byteArray.readUnsignedByte() << 28;
							result = result & 0x0fffffff | nextByte;
						}
					}
				}
			}
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				result = _byteArray.readUnsignedByte();
				if ((result & 0x00000080)) {
					nextByte = _byteArray.readUnsignedByte() << 7;
					result = result & 0x0000007f | nextByte;
					if ((result & 0x00004000)) {
						nextByte = _byteArray.readUnsignedByte() << 14;
						result = result & 0x00003fff | nextByte;
						if ((result & 0x00200000)) {
							nextByte = _byteArray.readUnsignedByte() << 21;
							result = result & 0x001fffff | nextByte;
							if ((result & 0x10000000)) {
								nextByte = _byteArray.readUnsignedByte() << 28;
								result = result & 0x0fffffff | nextByte;
							}
						}
					}
				}
				pool.uintPool[pool.uintPool.length] = result;
			}
			/* END:READ uintpool */

			/* READ doublepool */
			result = _byteArray.readUnsignedByte();
			if ((result & 0x00000080)) {
				nextByte = _byteArray.readUnsignedByte() << 7;
				result = result & 0x0000007f | nextByte;
				if ((result & 0x00004000)) {
					nextByte = _byteArray.readUnsignedByte() << 14;
					result = result & 0x00003fff | nextByte;
					if ((result & 0x00200000)) {
						nextByte = _byteArray.readUnsignedByte() << 21;
						result = result & 0x001fffff | nextByte;
						if ((result & 0x10000000)) {
							nextByte = _byteArray.readUnsignedByte() << 28;
							result = result & 0x0fffffff | nextByte;
						}
					}
				}
			}
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				pool.doublePool[pool.doublePool.length] = _byteArray.readDouble();
			}
			/* END:READ doublepool */

			/* READ stringpool */
			result = _byteArray.readUnsignedByte();
			if ((result & 0x00000080)) {
				nextByte = _byteArray.readUnsignedByte() << 7;
				result = result & 0x0000007f | nextByte;
				if ((result & 0x00004000)) {
					nextByte = _byteArray.readUnsignedByte() << 14;
					result = result & 0x00003fff | nextByte;
					if ((result & 0x00200000)) {
						nextByte = _byteArray.readUnsignedByte() << 21;
						result = result & 0x001fffff | nextByte;
						if ((result & 0x10000000)) {
							nextByte = _byteArray.readUnsignedByte() << 28;
							itemCount = result & 0x0fffffff | nextByte;
						}
					}
				}
			}
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				result = _byteArray.readUnsignedByte();
				if ((result & 0x00000080)) {
					nextByte = _byteArray.readUnsignedByte() << 7;
					result = result & 0x0000007f | nextByte;
					if ((result & 0x00004000)) {
						nextByte = _byteArray.readUnsignedByte() << 14;
						result = result & 0x00003fff | nextByte;
						if ((result & 0x00200000)) {
							nextByte = _byteArray.readUnsignedByte() << 21;
							result = result & 0x001fffff | nextByte;
							if ((result & 0x10000000)) {
								nextByte = _byteArray.readUnsignedByte() << 28;
								result = result & 0x0fffffff | nextByte;
							}
						}
					}
				}
				var str:String = _byteArray.readUTFBytes(result);
				if (result != str.length) {
					str = UTF8_BAD_PREFIX + (_illegalCount++).toString();
				}
				pool.stringPool[pool.stringPool.length] = str;
			}
			/* END:READ stringpool */

			/* READ namespacepool */
			result = _byteArray.readUnsignedByte();
			if ((result & 0x00000080)) {
				nextByte = _byteArray.readUnsignedByte() << 7;
				result = result & 0x0000007f | nextByte;
				if ((result & 0x00004000)) {
					nextByte = _byteArray.readUnsignedByte() << 14;
					result = result & 0x00003fff | nextByte;
					if ((result & 0x00200000)) {
						nextByte = _byteArray.readUnsignedByte() << 21;
						result = result & 0x001fffff | nextByte;
						if ((result & 0x10000000)) {
							nextByte = _byteArray.readUnsignedByte() << 28;
							result = result & 0x0fffffff | nextByte;
						}
					}
				}
			}
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				var kind:uint = 255 & _byteArray[_byteArray.position++];
				result = _byteArray.readUnsignedByte();
				if ((result & 0x00000080)) {
					nextByte = _byteArray.readUnsignedByte() << 7;
					result = result & 0x0000007f | nextByte;
					if ((result & 0x00004000)) {
						nextByte = _byteArray.readUnsignedByte() << 14;
						result = result & 0x00003fff | nextByte;
						if ((result & 0x00200000)) {
							nextByte = _byteArray.readUnsignedByte() << 21;
							result = result & 0x001fffff | nextByte;
							if ((result & 0x10000000)) {
								nextByte = _byteArray.readUnsignedByte() << 28;
								result = result & 0x0fffffff | nextByte;
							}
						}
					}
				}
				pool.namespacePool[pool.namespacePool.length] = new LNamespace(NamespaceKind.determineKind(kind), pool.stringPool[result]);
			}
			/* END:READ namespacepool */

			/* READ namespacesetpool */
			result = _byteArray.readUnsignedByte();
			if ((result & 0x00000080)) {
				nextByte = _byteArray.readUnsignedByte() << 7;
				result = result & 0x0000007f | nextByte;
				if ((result & 0x00004000)) {
					nextByte = _byteArray.readUnsignedByte() << 14;
					result = result & 0x00003fff | nextByte;
					if ((result & 0x00200000)) {
						nextByte = _byteArray.readUnsignedByte() << 21;
						result = result & 0x001fffff | nextByte;
						if ((result & 0x10000000)) {
							nextByte = _byteArray.readUnsignedByte() << 28;
							result = result & 0x0fffffff | nextByte;
						}
					}
				}
			}
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				result = _byteArray.readUnsignedByte();
				if ((result & 0x00000080)) {
					nextByte = _byteArray.readUnsignedByte() << 7;
					result = result & 0x0000007f | nextByte;
					if ((result & 0x00004000)) {
						nextByte = _byteArray.readUnsignedByte() << 14;
						result = result & 0x00003fff | nextByte;
						if ((result & 0x00200000)) {
							nextByte = _byteArray.readUnsignedByte() << 21;
							result = result & 0x001fffff | nextByte;
							if ((result & 0x10000000)) {
								nextByte = _byteArray.readUnsignedByte() << 28;
								result = result & 0x0fffffff | nextByte;
							}
						}
					}
				}
				var namespaceIndexRefCount:int = result;
				var namespaceArray:Array = [];
				while (--namespaceIndexRefCount - (-1)) {
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					namespaceArray[namespaceArray.length] = pool.namespacePool[result];
				}
				pool.namespaceSetPool[pool.namespaceSetPool.length] = new NamespaceSet(namespaceArray);
			}
			/* END:READ namespacesetpool */

			/* READ multinamepool */
			result = _byteArray.readUnsignedByte();
			if ((result & 0x00000080)) {
				nextByte = _byteArray.readUnsignedByte() << 7;
				result = result & 0x0000007f | nextByte;
				if ((result & 0x00004000)) {
					nextByte = _byteArray.readUnsignedByte() << 14;
					result = result & 0x00003fff | nextByte;
					if ((result & 0x00200000)) {
						nextByte = _byteArray.readUnsignedByte() << 21;
						result = result & 0x001fffff | nextByte;
						if ((result & 0x10000000)) {
							nextByte = _byteArray.readUnsignedByte() << 28;
							result = result & 0x0fffffff | nextByte;
						}
					}
				}
			}
			itemCount = (result > 0) ? --result : 0;
			while (itemCount--) {
				kind = 255 & _byteArray[_byteArray.position++];
				//QNAME or QNAME_A
				if ((kind == 0x07) || (kind == 0x0D)) {
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					var ns:LNamespace = pool.namespacePool[result];
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					var name:String = pool.stringPool[result];
					pool.multinamePool[pool.multinamePool.length] = new QualifiedName(name, ns, (kind == 0x07) ? MultinameKind.QNAME : MultinameKind.QNAME_A);
						//RTQName or RTQName_A
				} else if ((kind == 0x0f) || (kind == 0x10)) {
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					str = pool.stringPool[result];
					pool.multinamePool[pool.multinamePool.length] = new RuntimeQualifiedName(str, (kind == 0x0f) ? MultinameKind.RTQNAME : MultinameKind.RTQNAME_A);
				} else if ((kind == 0x11) || (kind == 0x12)) {
					//RTQNAME_L or RTQNAME_LA
					pool.multinamePool[pool.multinamePool.length] = new RuntimeQualifiedNameL((kind == 0x11) ? MultinameKind.RTQNAME_L : MultinameKind.RTQNAME_LA);
				} else if ((kind == 0x09) || (kind == 0x0E)) {
					//MULTINAME or MULTINAME_A
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					str = pool.stringPool[result];
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					var nss:NamespaceSet = pool.namespaceSetPool[result];
					pool.multinamePool[pool.multinamePool.length] = new Multiname(str, nss, (kind == 0x09) ? MultinameKind.MULTINAME : MultinameKind.MULTINAME_A);
				} else if ((kind == 0x1B) && (kind == 0x1C)) {
					//MULTINAME_L or MULTINAME_LA
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					pool.multinamePool[pool.multinamePool.length] = new MultinameL(pool.namespaceSetPool[result], (kind == 0x1B) ? MultinameKind.MULTINAME_L : MultinameKind.MULTINAME_LA);
				} else if (kind == 0x1D) {
					//GENERIC
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					var qualifiedName:QualifiedName = pool.multinamePool[result];
					result = _byteArray.readUnsignedByte();
					if ((result & 0x00000080)) {
						nextByte = _byteArray.readUnsignedByte() << 7;
						result = result & 0x0000007f | nextByte;
						if ((result & 0x00004000)) {
							nextByte = _byteArray.readUnsignedByte() << 14;
							result = result & 0x00003fff | nextByte;
							if ((result & 0x00200000)) {
								nextByte = _byteArray.readUnsignedByte() << 21;
								result = result & 0x001fffff | nextByte;
								if ((result & 0x10000000)) {
									nextByte = _byteArray.readUnsignedByte() << 28;
									result = result & 0x0fffffff | nextByte;
								}
							}
						}
					}
					var paramCount:uint = result;
					var params:Array = [];
					while (paramCount--) {
						result = _byteArray.readUnsignedByte();
						if ((result & 0x00000080)) {
							nextByte = _byteArray.readUnsignedByte() << 7;
							result = result & 0x0000007f | nextByte;
							if ((result & 0x00004000)) {
								nextByte = _byteArray.readUnsignedByte() << 14;
								result = result & 0x00003fff | nextByte;
								if ((result & 0x00200000)) {
									nextByte = _byteArray.readUnsignedByte() << 21;
									result = result & 0x001fffff | nextByte;
									if ((result & 0x10000000)) {
										nextByte = _byteArray.readUnsignedByte() << 28;
										result = result & 0x0fffffff | nextByte;
									}
								}
							}
						}
						params[params.length] = pool.multinamePool[result];
					}
					pool.multinamePool[pool.multinamePool.length] = new MultinameG(qualifiedName, paramCount, params, MultinameKind.GENERIC)
				}
			}
			/* END:READ multinamepool */

			pool.initializeLookups();

			_constantPoolEndPosition = _byteArray.position;

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
