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
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SimpleConstantPool;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ClassConstant;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitAttributes;
	import org.as3commons.bytecode.io.AbstractAbcDeserializer;
	import org.as3commons.bytecode.swf.SWFWeaverFileIO;
	import org.as3commons.bytecode.tags.serialization.RecordHeaderSerializer;
	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.bytecode.util.SWFSpec;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.MetadataContainer;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.as3commons_reflect;

	public class ReflectionDeserializer extends AbstractAbcDeserializer {
		private static const DOUBLE_COLON:String = ':';
		private static const FORWARD_SLASH:String = '/';
		private static const GETTER_SIGNATURE:String = "get";
		private static const HTTP_PREFIX:String = 'http:';
		private static const SETTER_SIGNATURE:String = "set";
		private static const PROTECTED_NAMESPACE_NAME_PREFIX:String = "protectedNamespace::";
		private static const PRIVATE_NAMESPACE_NAME_PREFIX:String = "private::";

		public function ReflectionDeserializer() {
			super();
			_recordHeaderSerializer = new RecordHeaderSerializer();
		}

		private var _applicationDomain:ApplicationDomain;
		protected var _recordHeaderSerializer:RecordHeaderSerializer;

		public function read(typeCache:ByteCodeTypeCache, input:ByteArray, applicationDomain:ApplicationDomain=null, isLoaderBytes:Boolean=true):void {
			_applicationDomain = applicationDomain ||= Type.currentApplicationDomain;
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

		public function readMetadata(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain):Array {
			var result:int;
			include "../io/readU32.as.tmpl";
			var metadataCount:int = result;
			var metadatas:Array = [];
			var metadataInstance:Metadata;
			var keyValuePairCount:int;
			var keys:Array;
			var i:int;
			var len:int;
			var key:String;
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
				metadataInstance = new Metadata("");
				metadatas[metadatas.length] = metadataInstance;

				include "../io/readU32.as.tmpl";
				metadataInstance.as3commons_reflect::setName(constantPool.stringPool[result]);

				include "../io/readU32.as.tmpl";
				keyValuePairCount = result;
				keys = [];

				// Suck out the keys first
				while (keyValuePairCount--) {
					include "../io/readU32.as.tmpl";
					key = constantPool.stringPool[result];
					keys[keys.length] = key;
				}

				len = keys.length;
				// Map keys to values in another loop
				for (i = 0; i < len; ++i) {
					include "../io/readU32.as.tmpl";
					metadataInstance.arguments[metadataInstance.arguments.length] = new MetadataArgument(key, constantPool.stringPool[result]);
				}
			}
			return metadatas;
		}

		public function readMethods(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain):Array {
			var methods:Array = [];
			var result:int;
			include "../io/readU32.as.tmpl";
			var itemCount:int = result;
			var methodInfo:ByteCodeMethod;
			var paramCount:int;
			var classMultiname:BaseMultiname;
			var fullName:String;
			var classMultinameAsMultiname:Multiname;
			var ns:LNamespace;
			var params:Array;
			var newParam:ByteCodeParameter;
			var flags:uint;
			var optionInfoCount:int;
			var optionInfoIndex:int;
			var defaultValue:*;
			var param:ByteCodeParameter;
			var nameIndex:int;
			var nameCount:uint;
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
				methodInfo = new ByteCodeMethod(null, "", false, [], null, applicationDomain);
				methods[methods.length] = methodInfo;

				include "../io/readU32.as.tmpl";
				paramCount = result;
				include "../io/readU32.as.tmpl";
				classMultiname = constantPool.multinamePool[result];
				//convertToQualifiedName:
				include "convertToQualifiedName.as.tmpl";
				methodInfo.as3commons_reflect::setReturnType(fullName);
				params = [];
				while (paramCount--) {
					include "../io/readU32.as.tmpl";

					//MultinameUtil.convertToQualifiedName():
					classMultiname = constantPool.multinamePool[result];
					fullName = "";
					include "convertToQualifiedName.as.tmpl";
					newParam = new ByteCodeParameter(fullName, applicationDomain);
					params[params.length] = newParam;
				}

				include "../io/readU32.as.tmpl";

				flags = (255 & _byteStream[_byteStream.position++]);
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
					include "../io/readU32.as.tmpl";
					optionInfoCount = result;
					for (optionInfoIndex = 0; optionInfoIndex < optionInfoCount; ++optionInfoIndex) {
						include "../io/readU32.as.tmpl";
						defaultValue = constantPool.getConstantPoolItem((255 & _byteStream[_byteStream.position++]), result);
						param = params[params.length - (optionInfoCount - optionInfoIndex)];
						param.as3commons_reflect::setIsOptional(true);
						param.as3commons_reflect::setDefaultValue(defaultValue);
					}
				}

				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_PARAM_NAMES) == true) {
					nameIndex = 0;
					nameCount = params.length;
					while (nameCount--) {
						include "../io/readU32.as.tmpl";
						ByteCodeParameter(params[nameIndex++]).as3commons_reflect::setName(constantPool.stringPool[result]);
					}
				}

				methodInfo.as3commons_reflect::setParameters(params);
				methodInfo.as3commons_reflect::setHasRestArguments(MethodFlag.flagPresent(flags, MethodFlag.NEED_REST));

			}
			return methods;
		}

		public function readTraitsInfo(instanceInfos:Array, instanceInfo:ByteCodeType, pool:IConstantPool, methodInfos:Array, metadata:Array, isStatic:Boolean, typeCache:ByteCodeTypeCache, applicationDomain:ApplicationDomain):Array {
			var result:int;
			include "../io/readU32.as.tmpl";
			var traitCount:int = result;
			var methods:Array = [];
			var traitName:BaseMultiname;
			var traitMultiname:QualifiedName;
			var traitKindValue:int;
			var namedMultiname:BaseMultiname;
			var metaDataContainer:MetadataContainer;
			var qualifiedName:QualifiedName;
			var fullName:String;
			var multinamePool:Vector.<BaseMultiname> = pool.multinamePool;
			var lastIdx:int;
			var fullNSName:Array;
			var getterSetterSignature:String;
			var kindMasked:int;
			var classMultiname:BaseMultiname;
			var typeFullName:String;
			var classMultinameAsMultiname:Multiname;
			var ns:LNamespace;
			var variable:ByteCodeVariable;
			var constant:ByteCodeConstant;
			var method:ByteCodeMethod;
			var accAccess:AccessorAccess;
			var accessorType:String;
			var accessorMethod:ByteCodeMethod;
			var numberOfTraitMetadataItems:int;
			var md:Metadata;
			var accessor:ByteCodeAccessor;
			var member:Object;
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
				include "../io/readU32.as.tmpl";
				traitName = multinamePool[result];
				traitMultiname = MultinameUtil.convertToQualifiedName(traitName);
				traitKindValue = (255 & _byteStream[_byteStream.position++]);
				namedMultiname = null;
				metaDataContainer = null;
				fullName = ((instanceInfo != null)) ? instanceInfo.fullName : "";
				if (traitMultiname.nameSpace.name == "*") {
					lastIdx = fullName.lastIndexOf(MultinameUtil.PERIOD);
					fullNSName = fullName.split("");
					fullNSName[lastIdx] = MultinameUtil.SINGLE_COLON;
					traitMultiname.nameSpace.name = fullNSName.join("");
				}
				getterSetterSignature = "";
				kindMasked = traitKindValue & 0xF;
				if (kindMasked == 0) {
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
					classMultiname = multinamePool[result];
					if (!(classMultiname is QualifiedName)) {
						if (classMultiname is Multiname) {
							classMultinameAsMultiname = classMultiname as Multiname;
							ns = classMultinameAsMultiname.namespaceSet.namespaces[0];
							if (classMultinameAsMultiname.namespaceSet.namespaces.length == 1) {
								if (classMultinameAsMultiname.name != '*') {
									if ((ns.name != null) && (ns.name.length > 0)) {
										typeFullName = ns.name + '.' + classMultinameAsMultiname.name;
									} else {
										typeFullName = classMultinameAsMultiname.name;
									}
								} else {
									typeFullName = '*';
								}
							}
						} else if (classMultiname is MultinameG) {
							typeFullName = (classMultiname as MultinameG).qualifiedName.fullName;
						}
					} else {
						typeFullName = (classMultiname as QualifiedName).fullName;
					}

					variable = new ByteCodeVariable(traitMultiname.name, typeFullName, fullName, false, applicationDomain);
					variable.as3commons_reflect::setIsStatic(isStatic);
					variable.as3commons_reflect::setScopeName(MultinameUtil.extractInterfaceScopeFromFullName(traitMultiname.name));
					metaDataContainer = variable;
					if (instanceInfo != null) {
						instanceInfo.variables[instanceInfo.variables.length] = variable;
					}
					include "../io/readU32.as.tmpl";
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
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
					namedMultiname = pool.multinamePool[result];
					if (!(namedMultiname is QualifiedName)) {
						if (namedMultiname is Multiname) {
							// A QualifiedName can only have one namespace, so we ensure that this is the case
							// before attempting conversion
							classMultinameAsMultiname = namedMultiname as Multiname;
							if (classMultinameAsMultiname.namespaceSet.namespaces.length == 1) {
								qualifiedName = new QualifiedName(classMultinameAsMultiname.name, classMultinameAsMultiname.namespaceSet.namespaces[0]);
							}
						} else if (namedMultiname is MultinameG) {
							qualifiedName = (namedMultiname as MultinameG).qualifiedName;
						} else {
							qualifiedName = null;
						}
					} else {
						qualifiedName = namedMultiname as QualifiedName;
					}

					constant = new ByteCodeConstant(traitMultiname.name, qualifiedName.fullName, fullName, false, applicationDomain);
					constant.as3commons_reflect::setIsStatic(isStatic);
					metaDataContainer = constant;
					if (instanceInfo != null) {
						instanceInfo.constants[instanceInfo.constants.length] = constant;
					}
					include "../io/readU32.as.tmpl";
					if (result != 0) {
						constant.as3commons_reflect::setInitializedValue(pool.getConstantPoolItem((255 & _byteStream[_byteStream.position++]), result));
					}
				} else if ((kindMasked == 1) || (kindMasked == 5)) {
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
					method = methodInfos[result];
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
					getterSetterSignature = (kindMasked == 2) ? GETTER_SIGNATURE : SETTER_SIGNATURE;
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
					accessorMethod = methodInfos[result];
					if (instanceInfo != null) {
						for each (var acc:ByteCodeAccessor in instanceInfo.accessors) {
							if (acc.name == traitMultiname.name) {
								acc.as3commons_reflect::setAccess(AccessorAccess.READ_WRITE);
								if (getterSetterSignature == GETTER_SIGNATURE) {
									acc.as3commons_reflect::setGetterMethod(accessorMethod);
								} else {
									acc.as3commons_reflect::setSetterMethod(accessorMethod);
								}
								metaDataContainer = acc;
								break;
							}
						}
						if (metaDataContainer == null) {
							accAccess = (getterSetterSignature == GETTER_SIGNATURE) ? AccessorAccess.READ_ONLY : AccessorAccess.WRITE_ONLY;
							accessorType = '';
							if (accAccess === AccessorAccess.READ_ONLY) {
								accessorType = accessorMethod.as3commons_reflect::returnTypeName;
							} else {
								if (accessorMethod.parameters.length > 0) {
									accessorType = ByteCodeParameter(accessorMethod.parameters[0]).as3commons_reflect::typeName;
								}
							}
							accessor = new ByteCodeAccessor(traitMultiname.name, accAccess, accessorType, instanceInfo.fullName, false, instanceInfo.applicationDomain);
							if (getterSetterSignature == GETTER_SIGNATURE) {
								accessor.as3commons_reflect::setGetterMethod(accessorMethod);
							} else {
								accessor.as3commons_reflect::setSetterMethod(accessorMethod);
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
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
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
					include "../io/readU32.as.tmpl";
					numberOfTraitMetadataItems = result;
					while (numberOfTraitMetadataItems--) {
						include "../io/readU32.as.tmpl";
						md = metadata[result];
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
						if (isCustomNamespace(traitMultiname.nameSpace)) {
							visibleMember.as3commons_reflect::setNamespaceURI(traitMultiname.nameSpace.name);
						}
					}
				}

				if ((metaDataContainer is ByteCodeMethod) || (metaDataContainer is ByteCodeAccessor) || (metaDataContainer is ByteCodeConstant) || (metaDataContainer is ByteCodeVariable)) {
					member = Object(metaDataContainer);
					member.as3commons_reflect::setIsFinal(Boolean((traitKindValue >> 4) & TraitAttributes.FINAL.bitMask));
					member.as3commons_reflect::setIsOverride(Boolean((traitKindValue >> 4) & TraitAttributes.OVERRIDE.bitMask));
				}
			}
			return methods;
		}

		private function isCustomNamespace(namespace:LNamespace):Boolean {
			if (namespace.name == LNamespace.PUBLIC.name) {
				return false;
			}
			if (namespace.name.substr(0, PROTECTED_NAMESPACE_NAME_PREFIX.length) == PROTECTED_NAMESPACE_NAME_PREFIX) {
				return false;
			}
			if (namespace.name.substr(0, PRIVATE_NAMESPACE_NAME_PREFIX.length) == PRIVATE_NAMESPACE_NAME_PREFIX) {
				return false;
			}

			return true;
		}

		public function readTypes(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain, methods:Array, metadatas:Array, typeCache:ByteCodeTypeCache):void {
			var result:int;
			include "../io/readU32.as.tmpl";
			var classCount:int = result;
			var classCount2:int = result;
			var instances:Array = [];
			var instanceInfo:ByteCodeType;
			var classMultiname:BaseMultiname;
			var fullName:String;
			var instanceName:String;
			var classMultinameAsMultiname:Multiname;
			var superName:QualifiedName;
			var ns:LNamespace;
			var instanceInfoFlags:uint;
			var interfaceCount:int;
			var classNames:Array;
			var method:ByteCodeMethod;
			var constr:ByteCodeConstructor;
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
				instanceInfo = new ByteCodeType(applicationDomain, input, constantPool);

				// The AVM2 spec dictates that this should always be a QualifiedName, but when parsing SWFs I have come across
				// Multinames with single namespaces (which are essentially QualifiedNames - the only reason to be a multiname
				// is to have multiple namespaces to search within to resolve a name). I haven't heard back from the Tamarin
				// list yet on this anomaly so I'm going to convert single-namespace Multinames to QualifiedNames here.
				//
				// From the spec (Section 4.7 "Instance", page 28):
				//  name 
				//      The name field is an index into the multiname array of the constant pool; it provides a name for the 
				//      class. The entry specified must be a QName.
				include "../io/readU32.as.tmpl";
				//MultinameUtil.convertToQualifiedName():
				classMultiname = constantPool.multinamePool[result];
				if (!(classMultiname is QualifiedName)) {
					if (classMultiname is Multiname) {
						classMultinameAsMultiname = classMultiname as Multiname;
						ns = classMultinameAsMultiname.namespaceSet.namespaces[0];
						if (classMultinameAsMultiname.namespaceSet.namespaces.length == 1) {
							if (classMultinameAsMultiname.name != '*') {
								if ((ns.name != null) && (ns.name.length > 0)) {
									fullName = ns.name + '.' + classMultinameAsMultiname.name;
								} else {
									fullName = classMultinameAsMultiname.name;
								}
								instanceName = classMultinameAsMultiname.name;
							} else {
								fullName = '*';
								instanceName = fullName;
							}
						}
					} else if (classMultiname is MultinameG) {
						fullName = (classMultiname as MultinameG).qualifiedName.fullName;
						instanceName = (classMultiname as MultinameG).qualifiedName.name;
					}
				} else {
					var qname:QualifiedName = (classMultiname as QualifiedName);
					fullName = qname.fullName;
					instanceName = qname.name;
				}

				instanceInfo.fullName = fullName;
				typeCache.as3commons_reflect::addDefinitionName(instanceInfo.fullName);
				instanceInfo.name = instanceName;
				typeCache.put(instanceInfo.fullName, instanceInfo, applicationDomain);
				instances[instances.length] = instanceInfo;

				include "../io/readU32.as.tmpl";
				superName = QualifiedName(constantPool.multinamePool[result]);
				instanceInfo.extendsClasses[instanceInfo.extendsClasses.length] = QualifiedName(superName).fullName;
				instanceInfoFlags = (255 & _byteStream[_byteStream.position++]);
				instanceInfo.isFinal = ClassConstant.FINAL.present(instanceInfoFlags);
				instanceInfo.isInterface = ClassConstant.INTERFACE.present(instanceInfoFlags);
				instanceInfo.as3commons_reflect::setIsProtected(ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags));
				instanceInfo.as3commons_reflect::setIsSealed(ClassConstant.SEALED.present(instanceInfoFlags));
				if (instanceInfo.isProtected) {
					include "../io/readU32.as.tmpl";
					instanceInfo.as3commons_reflect::setProtectedNamespace(LNamespace(constantPool.namespacePool[result]).name);
				}
				include "../io/readU32.as.tmpl";
				interfaceCount = result;
				while (interfaceCount--) {
					include "../io/readU32.as.tmpl";
					classMultiname = constantPool.multinamePool[result];
					fullName = null;
					include "convertToQualifiedName.as.tmpl";
					if (fullName != null) {
						instanceInfo.interfaces[instanceInfo.interfaces.length] = fullName;
						if (!typeCache.interfaceLookup.hasOwnProperty(fullName)) {
							classNames = [];
							typeCache.interfaceLookup[fullName] = classNames;
						} else {
							classNames = typeCache.interfaceLookup[fullName];
						}
						classNames[classNames.length] = AbcFileUtil.normalizeFullName(instanceInfo.fullName);
					}
				}
				include "../io/readU32.as.tmpl";
				method = methods[result];
				constr = new ByteCodeConstructor(instanceInfo.fullName, applicationDomain, method.parameters);
				instanceInfo.as3commons_reflect::setInstanceConstructor(method);
				instanceInfo.constructor = constr;
				instanceInfo.methods = readTraitsInfo(instances, instanceInfo, constantPool, methods, metadatas, false, typeCache, applicationDomain);
			}

			var classIndex:int = 0;
			var classInfo:ByteCodeType;
			while (classCount2--) {
				// class_info  
				// { 
				//  u30 cinit 
				//  u30 trait_count 
				//  traits_info traits[trait_count] 
				// }
				classInfo = instances[classIndex++];
				include "../io/readU32.as.tmpl";
				classInfo.as3commons_reflect::setStaticConstructor(methods[result]);
				classInfo.methods = classInfo.methods.concat(readTraitsInfo(instances, classInfo, constantPool, methods, metadatas, true, typeCache, applicationDomain));
			}

			include "../io/readU32.as.tmpl";
			var scriptCount:int = result;
			while (scriptCount--) {
				include "../io/readU32.as.tmpl";
				readTraitsInfo(instances, null, constantPool, methods, metadatas, true, typeCache, applicationDomain);
			}

			include "../io/readU32.as.tmpl";
			var methodBodyCount:int = result;
			var exceptionCount:int;
			while (methodBodyCount--) {
				include "../io/readU32.as.tmpl";
				method = methods[result];
				include "../io/readU32.as.tmpl";
				method.as3commons_reflect::setMaxStack(result);
				include "../io/readU32.as.tmpl";
				method.as3commons_reflect::setLocalCount(result);
				include "../io/readU32.as.tmpl";
				method.as3commons_reflect::setInitScopeDepth(result);
				include "../io/readU32.as.tmpl";
				method.as3commons_reflect::setMaxScopeDepth(result);
				include "../io/readU32.as.tmpl";
				method.as3commons_reflect::setBodyLength(result);
				method.as3commons_reflect::setBodyStartPosition(_byteStream.position);
				_byteStream.position += method.bodyLength;

				include "../io/readU32.as.tmpl";
				exceptionCount = result;
				while (exceptionCount--) {
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
					include "../io/readU32.as.tmpl";
				}
				//Completely skip traits info
				include "../io/readU32.as.tmpl";
				var traitCount:int = result;
				var traitKindValue:uint;
				var vindex:uint;
				var vkind:uint;
				while (traitCount--) {
					include "../io/readU32.as.tmpl";
					traitKindValue = (255 & _byteStream[_byteStream.position++]) & 0xF;
					vindex = 0;
					vkind = 0;
					if ((traitKindValue == 0) || (traitKindValue == 6)) {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						if (result != 0) {
							_byteStream.position++;
						}
					} else {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
					}
				}
			}
		}

		protected function readHeader(input:ByteArray):void {
			skipRectangle(input);
			input.readUnsignedByte();
			input.readUnsignedByte();
			input.readUnsignedShort();
		}

		protected function readTags(typeCache:ByteCodeTypeCache, input:ByteArray):void {
			var recordHeader:RecordHeader = _recordHeaderSerializer.read(input) as RecordHeader;
			if ((recordHeader.length > 0) && ((recordHeader.id == 82) || (recordHeader.id == 72))) { //Only parse DoABCTag
				var endpos:int = input.position + recordHeader.length;
				if (recordHeader.id == 82) {
					input.readInt(); //skip flags
					SWFSpec.skipString(input); //skip name
				}
				readABCTag(typeCache, input);
				if (input.position < endpos) {
					input.position = endpos;
				}
			} else {
				input.position += recordHeader.length;
			}
		}

		protected function skipRectangle(input:ByteArray):void {
			var current:uint = input.readUnsignedByte();
			var size:uint = current >> 3;
			var off:int = 3;
			var i:int;
			for (i = 0; i < 4; ++i) {
				off -= size;
				while (off < 0) {
					current = input.readUnsignedByte();
					off += 8;
				}
			}
		}
	}
}
