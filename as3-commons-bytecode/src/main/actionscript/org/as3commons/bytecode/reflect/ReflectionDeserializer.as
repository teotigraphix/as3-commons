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
package org.as3commons.bytecode.reflect {
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ClassConstant;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitAttributes;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.io.AbstractAbcDeserializer;
	import org.as3commons.bytecode.swf.SWFFileIO;
	import org.as3commons.bytecode.tags.serialization.RecordHeaderSerializer;
	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.bytecode.util.SWFSpec;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.MetaDataContainer;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.as3commons_reflect;

	public class ReflectionDeserializer extends AbstractAbcDeserializer {

		private static const GETTER_SIGNATURE:String = "get";
		private static const FORWARD_SLASH:String = '/';
		private static const DOUBLE_COLON:String = ':';
		private static const HTTP_PREFIX:String = 'http:';

		private var _recordHeaderSerializer:RecordHeaderSerializer;

		private var _applicationDomain:ApplicationDomain;

		public function ReflectionDeserializer() {
			super();
			_recordHeaderSerializer = new RecordHeaderSerializer();
		}

		public function read(typeCache:ByteCodeTypeCache, input:ByteArray, applicationDomain:ApplicationDomain = null, isLoaderBytes:Boolean = true):void {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			_byteStream = AbcSpec.byteArray();
			input.endian = Endian.LITTLE_ENDIAN;
			var swfIdentifier:String = input.readUTFBytes(3);
			var compressed:Boolean = (swfIdentifier == SWFFileIO.SWF_SIGNATURE_COMPRESSED);
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
			skipU16();
			skipU16();
			var constantPool:ConstantPool = new ConstantPool();
			constantPool.dupeCheck = false;
			deserializeConstantPool(constantPool);
			var methods:Array = readMethods(input, constantPool, _applicationDomain);
			var metaData:Array = readMetaData(input, constantPool, _applicationDomain);
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

		public function readMethods(input:ByteArray, constantPool:ConstantPool, applicationDomain:ApplicationDomain):Array {
			var methods:Array = [];
			var methodCount:int = readU30();

			for (var methodIndex:int = 0; methodIndex < methodCount; ++methodIndex) {
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

				var paramCount:int = readU30();

				var returnTypeQName:QualifiedName = MultinameUtil.convertToQualifiedName(constantPool.multinamePool[readU30()]);
				methodInfo.as3commons_reflect::setReturnType(returnTypeQName.fullName);

				var params:Array = [];
				for (var argumentIndex:int = 0; argumentIndex < paramCount; ++argumentIndex) {
					var paramQName:QualifiedName = MultinameUtil.convertToQualifiedName(constantPool.multinamePool[readU30()]);
					var newParam:ByteCodeParameter = new ByteCodeParameter(argumentIndex, paramQName.fullName, applicationDomain);
					newParam.as3commons_reflect::setName("argument " + argumentIndex.toString());
					params[params.length] = newParam;
				}
				var nameCount:uint = params.length;

				var methodNameIndex:int = readU30();
				var methodName:String = (methodNameIndex > 0) ? constantPool.stringPool[methodNameIndex] : "";
				methodInfo.as3commons_reflect::setScopeName(MultinameUtil.extractNamespaceNameFromMethodName(methodName));
				if (methodName.length > 0) {
					methodName = makeMethodName(methodName);
				}
				methodInfo.as3commons_reflect::setName(methodName);
				var flags:uint = readU8();
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
					var optionInfoCount:int = readU30();
					for (var optionInfoIndex:int = 0; optionInfoIndex < optionInfoCount; ++optionInfoIndex) {
						var valueIndexInConstantconstantPool:int = readU30();
						var optionalValueKind:int = readU8();
						var defaultValue:Object = constantPool.getConstantPoolItem(optionalValueKind, valueIndexInConstantconstantPool);
						var param:ByteCodeParameter = params[params.length - (optionInfoCount - optionInfoIndex)];
						param.as3commons_reflect::setIsOptional(true);
						param.as3commons_reflect::setDefaultValue(defaultValue);
					}
				}

				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_PARAM_NAMES) == true) {
					for (var nameIndex:uint = 0; nameIndex < nameCount; ++nameIndex) {
						var paramName:String = constantPool.stringPool[readU30()];
						ByteCodeParameter(params[nameIndex]).as3commons_reflect::setName(paramName);
					}
				}

				methodInfo.as3commons_reflect::setParameters(params);

			}
			return methods;
		}

		public function readMetaData(input:ByteArray, constantPool:ConstantPool, applicationDomain:ApplicationDomain):Array {
			var metadataCount:int = readU30();
			var metadatas:Array = [];
			for (var metadataIndex:int = 0; metadataIndex < metadataCount; ++metadataIndex) {
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
				var metadataInstance:MetaData = new MetaData("");
				metadatas[metadatas.length] = metadataInstance;

				metadataInstance.as3commons_reflect::setName(constantPool.stringPool[readU30()]);

				var keyValuePairCount:int = readU30();
				var keys:Array = [];

				// Suck out the keys first
				for (var keyIndex:int = 0; keyIndex < keyValuePairCount; ++keyIndex) {
					var key:String = constantPool.stringPool[readU30()];
					keys[keys.length] = key;
				}

				// Map keys to values in another loop
				for each (key in keys) {
					var value:String = constantPool.stringPool[readU30()];
					metadataInstance.arguments[metadataInstance.arguments.length] = new MetaDataArgument(key, value);
				}
			}
			return metadatas;
		}

		public function readTypes(input:ByteArray, constantPool:ConstantPool, applicationDomain:ApplicationDomain, methods:Array, metadatas:Array, typeCache:ByteCodeTypeCache):void {
			var classCount:int = readU30();
			var instances:Array = [];
			for (var instanceIndex:int = 0; instanceIndex < classCount; ++instanceIndex) {
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
				//	            trace("InstanceInfo: " + _byteStream.position);
				// The AVM2 spec dictates that this should always be a QualifiedName, but when parsing SWFs I have come across
				// Multinames with single namespaces (which are essentially QualifiedNames - the only reason to be a multiname
				// is to have multiple namespaces to search within to resolve a name). I haven't heard back from the Tamarin
				// list yet on this anomaly so I'm going to convert single-namespace Multinames to QualifiedNames here.
				//
				// From the spec (Section 4.7 "Instance", page 28):
				//  name 
				//      The name field is an index into the multiname array of the constant pool; it provides a name for the 
				//      class. The entry specified must be a QName. 
				var instanceInfo:ByteCodeType = new ByteCodeType(applicationDomain);

				// The AVM2 spec dictates that this should always be a QualifiedName, but when parsing SWFs I have come across
				// Multinames with single namespaces (which are essentially QualifiedNames - the only reason to be a multiname
				// is to have multiple namespaces to search within to resolve a name). I haven't heard back from the Tamarin
				// list yet on this anomaly so I'm going to convert single-namespace Multinames to QualifiedNames here.
				//
				// From the spec (Section 4.7 "Instance", page 28):
				//  name 
				//      The name field is an index into the multiname array of the constant pool; it provides a name for the 
				//      class. The entry specified must be a QName. 
				var classMultiname:BaseMultiname = constantPool.multinamePool[readU30()];

				var qualifiedName:QualifiedName = MultinameUtil.convertToQualifiedName(classMultiname);
				instanceInfo.fullName = qualifiedName.fullName;
				typeCache.as3commons_reflect::addDefinitionName(instanceInfo.fullName);
				instanceInfo.name = qualifiedName.name;
				typeCache.put(instanceInfo.fullName, instanceInfo);
				instances[instances.length] = instanceInfo;

				var superName:QualifiedName = constantPool.multinamePool[readU30()];
				instanceInfo.extendsClasses[instanceInfo.extendsClasses.length] = QualifiedName(superName).fullName;
				var instanceInfoFlags:int = readU8();
				instanceInfo.isFinal = ClassConstant.FINAL.present(instanceInfoFlags);
				instanceInfo.isInterface = ClassConstant.INTERFACE.present(instanceInfoFlags);
				instanceInfo.as3commons_reflect::setIsProtected(ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags));
				instanceInfo.as3commons_reflect::setIsSealed(ClassConstant.SEALED.present(instanceInfoFlags));
				if (instanceInfo.isProtected) {
					instanceInfo.as3commons_reflect::setProtectedNamespace(LNamespace(constantPool.namespacePool[readU30()]).name);
				}
				var interfaceCount:int = readU30();
				for (var interfaceIndex:int = 0; interfaceIndex < interfaceCount; ++interfaceIndex) {
					var mn:BaseMultiname = constantPool.multinamePool[readU30()];
					var qName:QualifiedName = MultinameUtil.convertToQualifiedName(mn);
					instanceInfo.interfaces[instanceInfo.interfaces.length] = qName.fullName;
				}
				var constructorIndex:uint = readU30();
				var method:ByteCodeMethod = methods[constructorIndex];
				var constr:Constructor = new Constructor(instanceInfo.fullName, applicationDomain, method.parameters);
				instanceInfo.constructor = constr;
				instanceInfo.methods = readTraitsInfo(instances, instanceInfo, constantPool, methods, metadatas, false, typeCache, applicationDomain);
			}

			for (var classIndex:int = 0; classIndex < classCount; ++classIndex) {
				// class_info  
				// { 
				//  u30 cinit 
				//  u30 trait_count 
				//  traits_info traits[trait_count] 
				// }
				var classInfo:ByteCodeType = instances[classIndex];
				classInfo.as3commons_reflect::setStaticConstructor(methods[readU30()]);
				classInfo.methods = classInfo.methods.concat(readTraitsInfo(instances, classInfo, constantPool, methods, metadatas, true, typeCache, applicationDomain));
			}

			var scriptCount:int = readU30();
			for (var scriptIndex:int = 0; scriptIndex < scriptCount; ++scriptIndex) {
				skipU30();
				readTraitsInfo(instances, null, constantPool, methods, metadatas, true, typeCache, applicationDomain);
			}

			var methodBodyCount:int = readU30();
			for (var bodyIndex:int = 0; bodyIndex < methodBodyCount; ++bodyIndex) {
				method = methods[readU30()];
				method.as3commons_reflect::setMaxStack(readU30());
				method.as3commons_reflect::setLocalCount(readU30());
				method.as3commons_reflect::setInitScopeDepth(readU30());
				method.as3commons_reflect::setMaxScopeDepth(readU30());
				method.as3commons_reflect::setBodyLength(readU30());
				method.as3commons_reflect::setBodyStartPosition(_byteStream.position);
				_byteStream.position += method.bodyLength;

				var exceptionCount:int = readU30();
				for (var exceptionIndex:int = 0; exceptionIndex < exceptionCount; ++exceptionIndex) {
					skipU30();
					skipU30();
					skipU30();
					skipU30();
					skipU30();
				}
				skipTraitsInfo();
			}
		}

		public function readTraitsInfo(instanceInfos:Array, instanceInfo:ByteCodeType, pool:ConstantPool, methodInfos:Array, metadata:Array, isStatic:Boolean, typeCache:ByteCodeTypeCache, applicationDomain:ApplicationDomain):Array {
			var traitCount:int = readU30();
			var methods:Array = [];
			for (var traitIndex:int = 0; traitIndex < traitCount; ++traitIndex) {
				var trait:TraitInfo;
				// traits_info  
				// { 
				//  u30 name 
				//  u8  kind 
				//  u8  data[] 
				//  u30 metadata_count 
				//  u30 metadata[metadata_count] 
				// }
				var traitName:BaseMultiname = pool.multinamePool[readU30()];
				var traitMultiname:QualifiedName = MultinameUtil.convertToQualifiedName(traitName);
				var traitKindValue:int = readU8();
				var traitKind:TraitKind = TraitKind.determineKind(traitKindValue);
				var namedMultiname:BaseMultiname = null;
				var vindex:uint = 0;
				var vkind:uint = 0;
				var metaDataContainer:MetaDataContainer;
				var qualifiedName:QualifiedName;
				var fullName:String = ((instanceInfo != null)) ? instanceInfo.fullName : "";
				switch (traitKind) {
					case TraitKind.SLOT:
						readU30();
						namedMultiname = pool.multinamePool[readU30()];
						qualifiedName = MultinameUtil.convertToQualifiedName(namedMultiname);
						var variable:ByteCodeVariable = new ByteCodeVariable(traitMultiname.name, qualifiedName.fullName, fullName, false, applicationDomain);
						variable.as3commons_reflect::setIsStatic(isStatic);
						metaDataContainer = variable;
						if (instanceInfo != null) {
							instanceInfo.variables[instanceInfo.variables.length] = variable;
						}
						vindex = readU30();
						if (vindex != 0) {
							vkind = ConstantKind.determineKind(readU8()).value;
							variable.as3commons_reflect::setInitializedValue(pool.getConstantPoolItem(vkind, vindex));
						}
						break;
					case TraitKind.CONST:
						// trait_slot 
						// { 
						//  u30 slot_id 
						//  u30 type_name 
						//  u30 vindex 
						//  u8  vkind  
						// }
						readU30();
						namedMultiname = pool.multinamePool[readU30()];
						qualifiedName = MultinameUtil.convertToQualifiedName(namedMultiname);
						var constant:ByteCodeConstant = new ByteCodeConstant(traitMultiname.name, qualifiedName.fullName, fullName, false, applicationDomain);
						constant.as3commons_reflect::setIsStatic(isStatic);
						metaDataContainer = constant;
						if (instanceInfo != null) {
							instanceInfo.constants[instanceInfo.constants.length] = constant;
						}
						vindex = readU30();
						if (vindex != 0) {
							vkind = ConstantKind.determineKind(readU8()).value;
							constant.as3commons_reflect::setInitializedValue(pool.getConstantPoolItem(vkind, vindex));
						}
						break;

					case TraitKind.METHOD:
					case TraitKind.FUNCTION:
						readU30(); //skip disp_id
						var method:Method = methodInfos[readU30()];
						method.as3commons_reflect::setIsStatic(isStatic);
						methods[methods.length] = method;
						metaDataContainer = method;
						break;
					case TraitKind.GETTER:
					case TraitKind.SETTER:
						// trait_method 
						// { 
						//  u30 disp_id 
						//  u30 method 
						// }
						readU30(); //skip disp_id
						var accessorMethod:Method = methodInfos[readU30()];
						if (instanceInfo != null) {
							metaDataContainer = addAccessor(instanceInfo, accessorMethod, isStatic);
						}
						break;

					case TraitKind.CLASS:
						// trait_class 
						// { 
						//  u30 slot_id 
						//  u30 classi 
						// }
						readU30();
						metaDataContainer = instanceInfos[readU30()];
						break;
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
					addMetaData(metadata, metaDataContainer, typeCache);
				}

				setNameSpaceAndVisibility(metaDataContainer as IVisibleMember, traitMultiname);

				if ((metaDataContainer is ByteCodeMethod) || (metaDataContainer is ByteCodeAccessor) || (metaDataContainer is ByteCodeConstant) || (metaDataContainer is ByteCodeVariable)) {
					var member:Object = Object(metaDataContainer);
					member.as3commons_reflect::setIsFinal(Boolean((traitKindValue >> 4) & TraitAttributes.FINAL.bitMask));
					member.as3commons_reflect::setIsOverride(Boolean((traitKindValue >> 4) & TraitAttributes.OVERRIDE.bitMask));
				}
			}
			return methods;
		}

		public function skipTraitsInfo():void {
			var traitCount:int = readU30();
			for (var traitIndex:int = 0; traitIndex < traitCount; ++traitIndex) {
				var trait:TraitInfo;
				skipU30();
				var traitKindValue:int = readU8();
				var traitKind:TraitKind = TraitKind.determineKind(traitKindValue);
				var vindex:uint = 0;
				var vkind:uint = 0;
				switch (traitKind) {
					case TraitKind.SLOT:
					case TraitKind.CONST:
						skipU30();
						skipU30();
						vindex = readU30();
						if (vindex != 0) {
							skipU8();
						}
						break;
					case TraitKind.METHOD:
					case TraitKind.FUNCTION:
					case TraitKind.GETTER:
					case TraitKind.SETTER:
					case TraitKind.CLASS:
						skipU30();
						skipU30();
						break;
				}
			}
		}

		private function addMetaData(metadata:Array, container:MetaDataContainer, typeCache:ByteCodeTypeCache):void {
			var numberOfTraitMetadataItems:int = readU30();
			for (var traitMetadataIndex:int = 0; traitMetadataIndex < numberOfTraitMetadataItems; ++traitMetadataIndex) {
				var md:MetaData = metadata[readU30()];
				container.addMetaData(md);
				if (container is ByteCodeType) {
					typeCache.as3commons_reflect::addToMetaDataCache(md.name, ByteCodeType(container).fullName);
				}
			}
		}

		private function setNameSpaceAndVisibility(visibleMember:IVisibleMember, qualifiedName:QualifiedName):void {
			if (visibleMember == null) {
				return;
			}
			visibleMember.as3commons_reflect::setVisibility(qualifiedName.nameSpace.kind);
			if (qualifiedName.nameSpace.kind === NamespaceKind.NAMESPACE) {
				if (qualifiedName.nameSpace.name.substr(0, 5) == HTTP_PREFIX) {
					visibleMember.as3commons_reflect::setNamespaceURI(qualifiedName.nameSpace.name);
				}
			}
		}

		private function addAccessor(instanceInfo:Type, method:ByteCodeMethod, isStatic:Boolean):ByteCodeAccessor {
			var nameParts:Array = method.name.split(FORWARD_SLASH);
			var methodName:String = String(nameParts[0]);
			for each (var acc:ByteCodeAccessor in instanceInfo.accessors) {
				if (acc.name == methodName) {
					acc.as3commons_reflect::setAccess(AccessorAccess.READ_WRITE);
					return acc;
				}
			}
			var getset:String = String(nameParts[1]);
			var accAccess:AccessorAccess = (getset == GETTER_SIGNATURE) ? AccessorAccess.READ_ONLY : AccessorAccess.WRITE_ONLY;
			var accessorType:String = '';
			if (accAccess === AccessorAccess.READ_ONLY) {
				accessorType = method.as3commons_reflect::returnTypeName;
			} else {
				if (method.parameters.length > 0) {
					accessorType = Parameter(method.parameters[0]).as3commons_reflect::typeName;
				}
			}
			var result:ByteCodeAccessor = new ByteCodeAccessor(methodName, accAccess, accessorType, instanceInfo.fullName, false, instanceInfo.applicationDomain);
			result.as3commons_reflect::setScopeName(method.scopeName);
			result.as3commons_reflect::setNamespaceURI(method.namespaceURI);
			result.as3commons_reflect::setIsStatic(isStatic);
			instanceInfo.accessors[instanceInfo.accessors.length] = result;
			return result;
		}

		private function makeMethodName(rawMethodName:String):String {
			if (rawMethodName.indexOf(FORWARD_SLASH) > -1) {
				var parts:Array = rawMethodName.split(FORWARD_SLASH);
				parts.splice(0, 1);
				rawMethodName = parts.join(FORWARD_SLASH);
			}
			if (rawMethodName.indexOf(DOUBLE_COLON) > -1) {
				parts = rawMethodName.split(DOUBLE_COLON);
				rawMethodName = parts[parts.length - 1];
			}
			return rawMethodName;
		}
	}
}