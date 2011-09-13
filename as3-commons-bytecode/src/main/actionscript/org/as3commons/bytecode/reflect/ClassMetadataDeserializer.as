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
package org.as3commons.bytecode.reflect {
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.ClassConstant;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.TraitAttributes;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.as3commons_reflect;

	public class ClassMetadataDeserializer extends ReflectionDeserializer {

		public function ClassMetadataDeserializer() {
			super();
		}

		override public function readMethods(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain):Array {
			var result:int = byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var methodCount:int = result;

			while (methodCount--) {
				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var paramCount:uint = result; //paramcount;
				var paramCount2:uint = paramCount; //paramcount;

				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				} //returnTypeQName

				while (paramCount--) {
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
				}

				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				} //methodNameIndex
				var flags:uint = 255 & byteStream[byteStream.position++];
				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_OPTIONAL) == true) {
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var optionInfoCount:int = result;
					while (optionInfoCount--) {
						result = byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						input.position++;
					}
				}

				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_PARAM_NAMES) == true) {
					while (paramCount2--) {
						result = byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
					}
				}
			}
			return null;
		}

		override public function readTypes(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain, methods:Array, metadatas:Array, typeCache:ByteCodeTypeCache):void {
			var result:int = byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var classCount:int = result;
			var classCount2:int = classCount;
			var classNames:Array = [];
			while (classCount--) {
				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var classMultiname:BaseMultiname = constantPool.multinamePool[result];
				var qualifiedName:QualifiedName = MultinameUtil.convertToQualifiedName(classMultiname);
				classNames[classNames.length] = qualifiedName.fullName;
				typeCache.as3commons_reflect::addDefinitionName(qualifiedName.fullName);

				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var instanceInfoFlags:uint = 255 & byteStream[byteStream.position++]; //instanceInfoFlags
				if (ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags)) {
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
				}
				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var interfaceCount:int = result;
				while (interfaceCount--) {
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var mn:BaseMultiname = constantPool.multinamePool[result];
					var qName:QualifiedName = MultinameUtil.convertToQualifiedName(mn);
					var impls:Array;
					if (!typeCache.interfaceLookup.hasOwnProperty(qName.fullName)) {
						impls = [];
						typeCache.interfaceLookup[qName.fullName] = impls;
					} else {
						impls = typeCache.interfaceLookup[qName.fullName] as Array;
					}
					impls[impls.length] = AbcFileUtil.normalizeFullName(qualifiedName.fullName);
				}
				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				gatherMetaData(classNames, constantPool, methods, metadatas, false, typeCache);
			}

			var classIndex:int = 0;
			while (classCount2--) {
				// class_info  
				// { 
				//  u30 cinit 
				//  u30 trait_count 
				//  traits_info traits[trait_count] 
				// }
				var className:String = classNames[classIndex++];
				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				gatherMetaData(classNames, constantPool, methods, metadatas, true, typeCache);
			}

			result = byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var scriptCount:int = result;
			while (scriptCount--) {
				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				gatherMetaData(classNames, constantPool, methods, metadatas, true, typeCache);
			}

		}

		public function gatherMetaData(classNames:Array, pool:IConstantPool, methodInfos:Array, metadata:Array, isStatic:Boolean, typeCache:ByteCodeTypeCache):void {
			var result:int = byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var traitCount:int = result;
			while (traitCount--) {
				var className:String = null;
				// traits_info  
				// { 
				//  u30 name 
				//  u8  kind 
				//  u8  data[] 
				//  u30 metadata_count 
				//  u30 metadata[metadata_count] 
				// }
				result = byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var traitKindValue:int = 255 & byteStream[byteStream.position++];
				var kindMasked:uint = traitKindValue & 0xF;
				if ((kindMasked == 0) || (kindMasked == 6)) {
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					if (result != 0) {
						byteStream.position++;
					}
				} else if ((kindMasked == 1) || (kindMasked == 2) || (kindMasked == 3) || (kindMasked == 5)) {
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
				} else if (kindMasked == 4) {
					// trait_class 
					// { 
					//  u30 slot_id 
					//  u30 classi 
					// }
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					className = classNames[result];
				}

				// (as listed at the top of this switch statement)
				// traits_info
				// {
				//  ...
				//  u30 metadata_count 
				//  u30 metadata[metadata_count]
				// }
				// AVM2 overview, page 29
				// "These fields are present only if ATTR_Metadata is present in the upper four bits of the kind field. 
				// The value of the metadata_count field is the number of entries in the metadata array. That array 
				// contains indices into the metadata array of the abcFile." 
				if (traitKindValue & (TraitAttributes.METADATA.bitMask << 4)) {
					result = byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var numberOfTraitMetadataItems:int = result;
					while (numberOfTraitMetadataItems--) {
						result = byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						var md:Metadata = metadata[result];
						if (className != null) {
							typeCache.as3commons_reflect::addToMetadataCache(md.name, className);
						}
					}
				}
			}
		}

	}
}
