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
	import flash.utils.Endian;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SimpleConstantPool;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ClassConstant;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitAttributes;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.io.AbstractAbcDeserializer2;
	import org.as3commons.bytecode.swf.SWFWeaverFileIO;
	import org.as3commons.bytecode.tags.serialization.RecordHeaderSerializer;
	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.bytecode.util.SWFSpec;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.MetadataContainer;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.as3commons_reflect;

	public class ReflectionDeserializer2 extends AbstractAbcDeserializer2 {

		private static const GETTER_SIGNATURE:String = "get";
		private static const SETTER_SIGNATURE:String = "set";
		private static const FORWARD_SLASH:String = '/';
		private static const DOUBLE_COLON:String = ':';
		private static const HTTP_PREFIX:String = 'http:';

		private var _recordHeaderSerializer:RecordHeaderSerializer;

		private var _applicationDomain:ApplicationDomain;

		public function ReflectionDeserializer2() {
			super();
			_recordHeaderSerializer = new RecordHeaderSerializer();
		}


		public function read(typeCache:ByteCodeTypeCache, input:ByteArray, applicationDomain:ApplicationDomain=null, isLoaderBytes:Boolean=true):void {
			_applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			_byteStream = AbcSpec.newByteArray();
			input.endian = Endian.LITTLE_ENDIAN;
			var swfIdentifier:String = input.readUTFBytes(3);
			var compressed:Boolean = (swfIdentifier == SWFWeaverFileIO.SWF_SIGNATURE_COMPRESSED);
			var version:uint = input.readByte();
			var filesize:uint = input.readUnsignedInt();

			input.readBytes(_byteStream);
			if (isLoaderBytes) {
				_byteStream.length -= 8;
			}

			if (compressed) {
				_byteStream.uncompress();
			}
			_byteStream.position = 0;
			readHeader(_byteStream);
			while (_byteStream.bytesAvailable) {
				readTags(typeCache, _byteStream);
			}
		}

		private function readTags(typeCache:ByteCodeTypeCache, input:ByteArray):void {
			var recordHeader:RecordHeader = _recordHeaderSerializer.read(input) as RecordHeader;
			if ((recordHeader.length > 0) && ((recordHeader.id == 82) || (recordHeader.id == 72))) { //Only parse DoABCTag
				var endpos:int = input.position + recordHeader.length;
				if (recordHeader.id == 82) {
					input.readInt(); //skip flags
					SWFSpec.readString(input); //skip name
				}
				readABCTag(typeCache, input);
				if (input.position < endpos) {
					input.position = endpos;
				}
			} else {
				input.position += recordHeader.length;
			}
		}

		private function readHeader(input:ByteArray):void {
			Assert.notNull(input, "input argument must not be null");
			skipRectangle(input);
			input.readUnsignedByte();
			input.readUnsignedByte();
			input.readUnsignedShort();
		}

		private function skipRectangle(input:ByteArray):void {
			Assert.notNull(input, "input argument must not be null");
			var current:uint = input.readUnsignedByte();
			var size:uint = current >> 3;
			var off:int = 3;
			for (var i:int = 0; i < 4; ++i) {
				off -= size;
				while (off < 0) {
					current = input.readUnsignedByte();
					off += 8;
				}
			}
		}

		public function readABCTag(typeCache:ByteCodeTypeCache, input:ByteArray):void {
			AbcSpec.skipU16(_byteStream);
			AbcSpec.skipU16(_byteStream);
			var constantPool:IConstantPool = new SimpleConstantPool();
			constantPool.dupeCheck = false;
			deserializeConstantPool(constantPool);
			var methods:Array = readMethods(input, constantPool, _applicationDomain);
			var metaData:Array = readMetadata(input, constantPool, _applicationDomain);
			readTypes(input, constantPool, _applicationDomain, methods, metaData, typeCache);
			if (methods != null) {
				methods.length = 0;
			}
			if (metaData != null) {
				metaData.length = 0;
			}
			methods = null;
			metaData = null;
		}

		public function readMethods(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain):Array {
			var methods:Array = [];
			var result:int = _byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var itemCount:int = result;
			while (itemCount--) {
				// method_info 
				// { 
				//  u30 param_count 
				//  u30 return_type 
				//  u30 param_type[param_count] 
				//  u30 name 
				//  u8  flags 
				//  option_info options 
				//  param_info param_names 
				// }
				var methodInfo:ByteCodeMethod = new ByteCodeMethod(null, "", false, [], null, applicationDomain);
				methods[methods.length] = methodInfo;

				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var paramCount:int = result;
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var returnTypeQName:QualifiedName = MultinameUtil.convertToQualifiedName(constantPool.multinamePool[result]);
				methodInfo.as3commons_reflect::setReturnType(returnTypeQName.fullName);

				var params:Array = [];
				for (var argumentIndex:int = 0; argumentIndex < paramCount; ++argumentIndex) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var paramQName:QualifiedName = MultinameUtil.convertToQualifiedName(constantPool.multinamePool[result]);
					var newParam:ByteCodeParameter = new ByteCodeParameter(paramQName.fullName, applicationDomain);
					newParam.as3commons_reflect::setName("argument " + argumentIndex.toString());
					params[params.length] = newParam;
				}
				var nameCount:uint = params.length;

				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				//var methodNameIndex:int = readU30();
				//var methodName:String = (methodNameIndex > 0) ? constantPool.stringPool[methodNameIndex] : "";
				//methodInfo.as3commons_reflect::setScopeName(MultinameUtil.extractNamespaceNameFromFullName(methodName));
				//if (methodName.length > 0) {
				//	methodName = makeMethodName(methodName);
				//}
				//methodInfo.as3commons_reflect::setName(methodName);
				var flags:uint = (255 & _byteStream[_byteStream.position++]);
				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_OPTIONAL) == true) {
					// option_info  
					// { 
					//  u30 option_count 
					//  option_detail option[option_count] 
					// }
					// option_detail 
					// { 
					//  u30 val 
					//  u8  kind 
					// }
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var optionInfoCount:int = result;
					for (var optionInfoIndex:int = 0; optionInfoIndex < optionInfoCount; ++optionInfoIndex) {
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						var defaultValue:* = constantPool.getConstantPoolItem((255 & _byteStream[_byteStream.position++]), result);
						var param:ByteCodeParameter = params[params.length - (optionInfoCount - optionInfoIndex)];
						param.as3commons_reflect::setIsOptional(true);
						param.as3commons_reflect::setDefaultValue(defaultValue);
					}
				}

				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_PARAM_NAMES) == true) {
					var nameIndex:int = 0;
					while (nameCount--) {
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						ByteCodeParameter(params[nameIndex++]).as3commons_reflect::setName(constantPool.stringPool[result]);
					}
				}

				methodInfo.as3commons_reflect::setParameters(params);
				methodInfo.as3commons_reflect::setHasRestArguments(MethodFlag.flagPresent(flags, MethodFlag.NEED_REST));

			}
			return methods;
		}

		public function readMetadata(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain):Array {
			var result:int = _byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var metadataCount:int = result;
			var metadatas:Array = [];
			while (metadataCount--) {
				// metadata_info  
				// { 
				//  u30 name 
				//  u30 item_count 
				//  item_info items[item_count] 
				// }
				// item_info  
				// { 
				//  u30 key 
				//  u30 value 
				// }
				// The above is a lie... the metadata is saved with all the keys first, then all the values afterwards.
				// So, if the item_count is 3, that means you will get three keys followed by three values. The keys
				// and values match up with each other in index, so the first key matches the first value, second key
				// matches the second value, etc.
				var metadataInstance:Metadata = new Metadata("");
				metadatas[metadatas.length] = metadataInstance;

				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				metadataInstance.as3commons_reflect::setName(constantPool.stringPool[result]);

				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var keyValuePairCount:int = result;
				var keys:Array = [];

				// Suck out the keys first
				while (keyValuePairCount--) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var key:String = constantPool.stringPool[result];
					keys[keys.length] = key;
				}

				// Map keys to values in another loop
				for each (key in keys) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					metadataInstance.arguments[metadataInstance.arguments.length] = new MetadataArgument(key, constantPool.stringPool[result]);
				}
			}
			return metadatas;
		}

		public function readTypes(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain, methods:Array, metadatas:Array, typeCache:ByteCodeTypeCache):void {
			var result:int = _byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var classCount:int = result;
			var classCount2:int = result;
			var instances:Array = [];
			while (classCount--) {
				// instance_info  
				// { 
				//  u30 name 
				//  u30 super_name 
				//  u8  flags 
				//  u30 protectedNs  
				//  u30 intrf_count 
				//  u30 interface[intrf_count] 
				//  u30 iinit 
				//  u30 trait_count 
				//  traits_info trait[trait_count] 
				// }
				// trace("InstanceInfo: " + _byteStream.position);
				// The AVM2 spec dictates that this should always be a QualifiedName, but when parsing SWFs I have come across
				// Multinames with single namespaces (which are essentially QualifiedNames - the only reason to be a multiname
				// is to have multiple namespaces to search within to resolve a name). I haven't heard back from the Tamarin
				// list yet on this anomaly so I'm going to convert single-namespace Multinames to QualifiedNames here.
				//
				// From the spec (Section 4.7 "Instance", page 28):
				//  name 
				//      The name field is an index into the multiname array of the constant pool; it provides a name for the 
				//      class. The entry specified must be a QName. 
				var instanceInfo:ByteCodeType = new ByteCodeType(applicationDomain, input, constantPool);

				// The AVM2 spec dictates that this should always be a QualifiedName, but when parsing SWFs I have come across
				// Multinames with single namespaces (which are essentially QualifiedNames - the only reason to be a multiname
				// is to have multiple namespaces to search within to resolve a name). I haven't heard back from the Tamarin
				// list yet on this anomaly so I'm going to convert single-namespace Multinames to QualifiedNames here.
				//
				// From the spec (Section 4.7 "Instance", page 28):
				//  name 
				//      The name field is an index into the multiname array of the constant pool; it provides a name for the 
				//      class. The entry specified must be a QName.
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var classMultiname:BaseMultiname = constantPool.multinamePool[result];

				var qualifiedName:QualifiedName = MultinameUtil.convertToQualifiedName(classMultiname);
				instanceInfo.fullName = qualifiedName.fullName;
				typeCache.as3commons_reflect::addDefinitionName(instanceInfo.fullName);
				instanceInfo.name = qualifiedName.name;
				typeCache.put(instanceInfo.fullName, instanceInfo);
				instances[instances.length] = instanceInfo;

				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var superName:QualifiedName = constantPool.multinamePool[result];
				instanceInfo.extendsClasses[instanceInfo.extendsClasses.length] = QualifiedName(superName).fullName;
				var instanceInfoFlags:uint = (255 & _byteStream[_byteStream.position++]);
				instanceInfo.isFinal = ClassConstant.FINAL.present(instanceInfoFlags);
				instanceInfo.isInterface = ClassConstant.INTERFACE.present(instanceInfoFlags);
				instanceInfo.as3commons_reflect::setIsProtected(ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags));
				instanceInfo.as3commons_reflect::setIsSealed(ClassConstant.SEALED.present(instanceInfoFlags));
				if (instanceInfo.isProtected) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					instanceInfo.as3commons_reflect::setProtectedNamespace(LNamespace(constantPool.namespacePool[result]).name);
				}
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var interfaceCount:int = result;
				while (interfaceCount--) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var mn:BaseMultiname = constantPool.multinamePool[result];
					var qName:QualifiedName = MultinameUtil.convertToQualifiedName(mn);
					if (qName != null) {
						instanceInfo.interfaces[instanceInfo.interfaces.length] = qName.fullName;
						var classNames:Array;
						if (!typeCache.interfaceLookup.hasOwnProperty(qName.fullName)) {
							classNames = [];
							typeCache.interfaceLookup[qName.fullName] = classNames;
						} else {
							classNames = typeCache.interfaceLookup[qName.fullName] as Array;
						}
						classNames[classNames.length] = AbcFileUtil.normalizeFullName(instanceInfo.fullName);
					}
				}
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var method:ByteCodeMethod = methods[result];
				var constr:Constructor = new Constructor(instanceInfo.fullName, applicationDomain, method.parameters);
				instanceInfo.as3commons_reflect::setInstanceConstructor(method);
				instanceInfo.constructor = constr;
				instanceInfo.methods = readTraitsInfo(instances, instanceInfo, constantPool, methods, metadatas, false, typeCache, applicationDomain);
			}

			var classIndex:int = 0;
			while (classCount2--) {
				// class_info  
				// { 
				//  u30 cinit 
				//  u30 trait_count 
				//  traits_info traits[trait_count] 
				// }
				var classInfo:ByteCodeType = instances[classIndex++];
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				classInfo.as3commons_reflect::setStaticConstructor(methods[result]);
				classInfo.methods = classInfo.methods.concat(readTraitsInfo(instances, classInfo, constantPool, methods, metadatas, true, typeCache, applicationDomain));
			}

			result = _byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var scriptCount:int = result;
			while (scriptCount--) {
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				readTraitsInfo(instances, null, constantPool, methods, metadatas, true, typeCache, applicationDomain);
			}

			result = _byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var methodBodyCount:int = result;
			while (methodBodyCount--) {
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				method = methods[result];
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				method.as3commons_reflect::setMaxStack(result);
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				method.as3commons_reflect::setLocalCount(result);
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				method.as3commons_reflect::setInitScopeDepth(result);
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				method.as3commons_reflect::setMaxScopeDepth(result);
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				method.as3commons_reflect::setBodyLength(result);
				method.as3commons_reflect::setBodyStartPosition(_byteStream.position);
				_byteStream.position += method.bodyLength;

				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var exceptionCount:int = result;
				while (exceptionCount--) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
				}
				//Completely skip traits info
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var traitCount:int = result;
				while (traitCount--) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var traitKindValue:uint = (255 & _byteStream[_byteStream.position++]) & 0xF;
					var vindex:uint = 0;
					var vkind:uint = 0;
					if ((traitKindValue == 0) || (traitKindValue == 6)) {
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						if (result != 0) {
							_byteStream.position++;
						}
					} else {
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
					}
				}
			}
		}

		public function readTraitsInfo(instanceInfos:Array, instanceInfo:ByteCodeType, pool:IConstantPool, methodInfos:Array, metadata:Array, isStatic:Boolean, typeCache:ByteCodeTypeCache, applicationDomain:ApplicationDomain):Array {
			var result:int = _byteStream.readUnsignedByte();
			if ((result & 0x00000080)) {
				result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
				if ((result & 0x00004000)) {
					result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
					if ((result & 0x00200000)) {
						result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
						if ((result & 0x10000000)) {
							result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
						}
					}
				}
			}
			var traitCount:int = result;
			var methods:Array = [];
			while (traitCount--) {
				var trait:TraitInfo;
				// traits_info  
				// { 
				//  u30 name 
				//  u8  kind 
				//  u8  data[] 
				//  u30 metadata_count 
				//  u30 metadata[metadata_count] 
				// }
				result = _byteStream.readUnsignedByte();
				if ((result & 0x00000080)) {
					result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
					if ((result & 0x00004000)) {
						result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
						if ((result & 0x00200000)) {
							result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
							if ((result & 0x10000000)) {
								result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
							}
						}
					}
				}
				var traitName:BaseMultiname = pool.multinamePool[result];
				var traitMultiname:QualifiedName = MultinameUtil.convertToQualifiedName(traitName);
				var traitKindValue:int = (255 & _byteStream[_byteStream.position++]);
				var namedMultiname:BaseMultiname = null;
				var metaDataContainer:MetadataContainer = null;
				var qualifiedName:QualifiedName;
				var fullName:String = ((instanceInfo != null)) ? instanceInfo.fullName : "";
				if (traitMultiname.nameSpace.name == "*") {
					var lastIdx:int = fullName.lastIndexOf(MultinameUtil.PERIOD);
					var fullNSName:Array = fullName.split("");
					fullNSName[lastIdx] = MultinameUtil.SINGLE_COLON;
					traitMultiname.nameSpace.name = fullNSName.join("");
				}
				var getterSetterSignature:String = "";
				var kindMasked:int = traitKindValue & 0xF;
				if (kindMasked == 0) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					namedMultiname = pool.multinamePool[result];
					qualifiedName = MultinameUtil.convertToQualifiedName(namedMultiname);
					var variable:ByteCodeVariable = new ByteCodeVariable(traitMultiname.name, qualifiedName.fullName, fullName, false, applicationDomain);
					variable.as3commons_reflect::setIsStatic(isStatic);
					variable.as3commons_reflect::setScopeName(MultinameUtil.extractInterfaceScopeFromFullName(traitMultiname.name));
					metaDataContainer = variable;
					if (instanceInfo != null) {
						instanceInfo.variables[instanceInfo.variables.length] = variable;
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					if (result != 0) {
						variable.as3commons_reflect::setInitializedValue(pool.getConstantPoolItem((255 & _byteStream[_byteStream.position++]), result));
					}
				} else if (kindMasked == 6) {
					// trait_slot 
					// { 
					//  u30 slot_id 
					//  u30 type_name 
					//  u30 vindex 
					//  u8  vkind  
					// }
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					namedMultiname = pool.multinamePool[result];
					qualifiedName = MultinameUtil.convertToQualifiedName(namedMultiname);
					var constant:ByteCodeConstant = new ByteCodeConstant(traitMultiname.name, qualifiedName.fullName, fullName, false, applicationDomain);
					constant.as3commons_reflect::setIsStatic(isStatic);
					metaDataContainer = constant;
					if (instanceInfo != null) {
						instanceInfo.constants[instanceInfo.constants.length] = constant;
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					if (result != 0) {
						constant.as3commons_reflect::setInitializedValue(pool.getConstantPoolItem((255 & _byteStream[_byteStream.position++]), result));
					}
				} else if ((kindMasked == 1) || (kindMasked == 5)) {
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var method:ByteCodeMethod = methodInfos[result];
					method.as3commons_reflect::setIsStatic(isStatic);
					methods[methods.length] = method;
					method.as3commons_reflect::setName(traitMultiname.name);
					if (instanceInfo != null) {
						if (instanceInfo.isInterface) {
							method.as3commons_reflect::setScopeName(MultinameUtil.extractInterfaceScopeFromFullName(traitMultiname.fullName));
						} else {
							method.as3commons_reflect::setScopeName(MultinameUtil.createScopeNameFromQualifiedName(traitMultiname));
						}
						method.as3commons_reflect::setDeclaringType(instanceInfo.fullName);
					}
					metaDataContainer = method;
				} else if ((kindMasked == 2) || (kindMasked == 3)) {
					if (kindMasked == 2) {
						getterSetterSignature = GETTER_SIGNATURE;
					}
					// trait_method 
					// { 
					//  u30 disp_id 
					//  u30 method 
					// }
					if (getterSetterSignature.length == 0) {
						getterSetterSignature = SETTER_SIGNATURE;
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var accessorMethod:ByteCodeMethod = methodInfos[result];
					if (instanceInfo != null) {
						for each (var acc:ByteCodeAccessor in instanceInfo.accessors) {
							if (acc.name == traitMultiname.name) {
								acc.as3commons_reflect::setAccess(AccessorAccess.READ_WRITE);
								if (getterSetterSignature == GETTER_SIGNATURE) {
									acc.as3commons_reflect::setGetterMethod(method);
								} else {
									acc.as3commons_reflect::setSetterMethod(method);
								}
								metaDataContainer = acc;
							}
						}
						if (metaDataContainer == null) {
							var accAccess:AccessorAccess = (getterSetterSignature == GETTER_SIGNATURE) ? AccessorAccess.READ_ONLY : AccessorAccess.WRITE_ONLY;
							var accessorType:String = '';
							if (accAccess === AccessorAccess.READ_ONLY) {
								accessorType = accessorMethod.as3commons_reflect::returnTypeName;
							} else {
								if (accessorMethod.parameters.length > 0) {
									accessorType = ByteCodeParameter(accessorMethod.parameters[0]).as3commons_reflect::typeName;
								}
							}
							var accessor:ByteCodeAccessor = new ByteCodeAccessor(traitMultiname.name, accAccess, accessorType, instanceInfo.fullName, false, instanceInfo.applicationDomain);
							if (getterSetterSignature == GETTER_SIGNATURE) {
								accessor.as3commons_reflect::setGetterMethod(method);
							} else {
								accessor.as3commons_reflect::setSetterMethod(method);
							}
							accessor.as3commons_reflect::setScopeName(accessorMethod.scopeName);
							accessor.as3commons_reflect::setNamespaceURI(accessorMethod.namespaceURI);
							accessor.as3commons_reflect::setIsStatic(isStatic);
							accessor.as3commons_reflect::setDeclaringType(instanceInfo.fullName);
							instanceInfo.accessors[instanceInfo.accessors.length] = accessor;
							metaDataContainer = accessor;
						}
					}
				} else if (kindMasked == 4) {
					// trait_class 
					// { 
					//  u30 slot_id 
					//  u30 classi 
					// }
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					metaDataContainer = instanceInfos[result];
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
					result = _byteStream.readUnsignedByte();
					if ((result & 0x00000080)) {
						result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
						if ((result & 0x00004000)) {
							result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
							if ((result & 0x00200000)) {
								result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
								if ((result & 0x10000000)) {
									result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
								}
							}
						}
					}
					var numberOfTraitMetadataItems:int = result;
					while (numberOfTraitMetadataItems--) {
						result = _byteStream.readUnsignedByte();
						if ((result & 0x00000080)) {
							result = result & 0x0000007f | _byteStream.readUnsignedByte() << 7;
							if ((result & 0x00004000)) {
								result = result & 0x00003fff | _byteStream.readUnsignedByte() << 14;
								if ((result & 0x00200000)) {
									result = result & 0x001fffff | _byteStream.readUnsignedByte() << 21;
									if ((result & 0x10000000)) {
										result = result & 0x0fffffff | _byteStream.readUnsignedByte() << 28;
									}
								}
							}
						}
						var md:Metadata = metadata[result];
						metaDataContainer.addMetadata(md);
						if (metaDataContainer is ByteCodeType) {
							typeCache.as3commons_reflect::addToMetadataCache(md.name, ByteCodeType(metaDataContainer).fullName);
						}
					}
				}

				var visibleMember:IVisibleMember = (metaDataContainer as IVisibleMember);
				if (metaDataContainer is IVisibleMember) {
					visibleMember.as3commons_reflect::setVisibility(traitMultiname.nameSpace.kind);
					if (traitMultiname.nameSpace.kind === NamespaceKind.NAMESPACE) {
						if (traitMultiname.nameSpace.name.substr(0, 5) == HTTP_PREFIX) {
							visibleMember.as3commons_reflect::setNamespaceURI(traitMultiname.nameSpace.name);
						}
					}
				}

				if ((metaDataContainer is ByteCodeMethod) || (metaDataContainer is ByteCodeAccessor) || (metaDataContainer is ByteCodeConstant) || (metaDataContainer is ByteCodeVariable)) {
					var member:Object = Object(metaDataContainer);
					member.as3commons_reflect::setIsFinal(Boolean((traitKindValue >> 4) & TraitAttributes.FINAL.bitMask));
					member.as3commons_reflect::setIsOverride(Boolean((traitKindValue >> 4) & TraitAttributes.OVERRIDE.bitMask));
				}
			}
			return methods;
		}

	}
}
