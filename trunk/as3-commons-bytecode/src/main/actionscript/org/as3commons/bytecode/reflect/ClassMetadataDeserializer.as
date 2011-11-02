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
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
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

		public static const DOUBLE_COLON_REGEXP:RegExp = /[:]+/;
		public static const PERIOD:String = ".";
		private static const DOUBLE_COLON:String = ':';

		{
			Multiname;
			MultinameG;
			LNamespace;
		}

		public function ClassMetadataDeserializer() {
			super();
		}

		override public function readMethods(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain):Array {
			var result:int;
			include "../io/readU32.as.tmpl";
			const methodCount:int = result;

			while (methodCount--) {
				include "../io/readU32.as.tmpl";
				const paramCount:uint = result; //paramcount;
				const paramCount2:uint = paramCount; //paramcount;

				include "../io/readU32.as.tmpl"; //returnTypeQName

				while (paramCount--) {
					include "../io/readU32.as.tmpl";
				}

				include "../io/readU32.as.tmpl"; //methodNameIndex
				const flags:uint = 255 & byteStream[byteStream.position++];
				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_OPTIONAL) == true) {
					include "../io/readU32.as.tmpl";
					var optionInfoCount:int = result;
					while (optionInfoCount--) {
						include "../io/readU32.as.tmpl";
						input.position++;
					}
				}

				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_PARAM_NAMES) == true) {
					while (paramCount2--) {
						include "../io/readU32.as.tmpl";
					}
				}
			}
			return null;
		}

		override public function readTypes(input:ByteArray, constantPool:IConstantPool, applicationDomain:ApplicationDomain, methods:Array, metadatas:Array, typeCache:ByteCodeTypeCache):void {
			var result:int;
			include "../io/readU32.as.tmpl";
			const classCount:int = result;
			const classCount2:int = classCount;
			const classNames:Array = [];
			while (classCount--) {
				include "../io/readU32.as.tmpl";
				const classMultiname:BaseMultiname = constantPool.multinamePool[result];

				var fullName:String;
				var classMultinameAsMultiname:Multiname;
				var ns:LNamespace;
				include "convertToQualifiedName.as.tmpl";

				classNames[classNames.length] = fullName;
				typeCache.as3commons_reflect::addDefinitionName(fullName);

				include "../io/readU32.as.tmpl";
				const instanceInfoFlags:uint = 255 & byteStream[byteStream.position++]; //instanceInfoFlags
				if (ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags)) {
					include "../io/readU32.as.tmpl";
				}
				include "../io/readU32.as.tmpl";
				const interfaceCount:int = result;
				while (interfaceCount--) {
					include "../io/readU32.as.tmpl";
					const mn:BaseMultiname = constantPool.multinamePool[result];
					const qName:QualifiedName = MultinameUtil.convertToQualifiedName(mn);
					const impls:Array = (typeCache.interfaceLookup[qName.fullName]) ||= [];
					const idx:int = fullName.indexOf(DOUBLE_COLON);
					if (idx > -1) {
						fullName = fullName.replace(DOUBLE_COLON, PERIOD);
					}
					impls[impls.length] = fullName;
				}
				include "../io/readU32.as.tmpl";
				//gatherMetaData(classNames, constantPool, methods, metadatas, false, typeCache);
				include "../io/readU32.as.tmpl";
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
					include "../io/readU32.as.tmpl";
					var traitKindValue:int = 255 & byteStream[byteStream.position++];
					var kindMasked:uint = traitKindValue & 0xF;
					if ((kindMasked == 0) || (kindMasked == 6)) {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						if (result != 0) {
							byteStream.position++;
						}
					} else if ((kindMasked == 1) || (kindMasked == 2) || (kindMasked == 3) || (kindMasked == 5)) {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
					} else if (kindMasked == 4) {
						// trait_class 
						// { 
						//  u30 slot_id 
						//  u30 classi 
						// }
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
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
						include "../io/readU32.as.tmpl";
						var numberOfTraitMetadataItems:int = result;
						while (numberOfTraitMetadataItems--) {
							include "../io/readU32.as.tmpl";
							if (className != null) {
								var md:Metadata = metadatas[result];
								typeCache.as3commons_reflect::addToMetadataCache(md.name, className);
							}
						}
					}
				}
			}

			const classIndex:int = 0;
			while (classCount2--) {
				// class_info  
				// { 
				//  u30 cinit 
				//  u30 trait_count 
				//  traits_info traits[trait_count] 
				// }
				className = classNames[classIndex++];
				include "../io/readU32.as.tmpl";
				//gatherMetaData(classNames, constantPool, methods, metadatas, true, typeCache);
				include "../io/readU32.as.tmpl";
				traitCount = result;
				while (traitCount--) {
					className = null;
					// traits_info  
					// { 
					//  u30 name 
					//  u8  kind 
					//  u8  data[] 
					//  u30 metadata_count 
					//  u30 metadata[metadata_count] 
					// }
					include "../io/readU32.as.tmpl";
					traitKindValue = 255 & byteStream[byteStream.position++];
					kindMasked = traitKindValue & 0xF;
					if ((kindMasked == 0) || (kindMasked == 6)) {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						if (result != 0) {
							byteStream.position++;
						}
					} else if ((kindMasked == 1) || (kindMasked == 2) || (kindMasked == 3) || (kindMasked == 5)) {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
					} else if (kindMasked == 4) {
						// trait_class 
						// { 
						//  u30 slot_id 
						//  u30 classi 
						// }
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
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
						include "../io/readU32.as.tmpl";
						numberOfTraitMetadataItems = result;
						while (numberOfTraitMetadataItems--) {
							include "../io/readU32.as.tmpl";
							if (className != null) {
								md = metadatas[result];
								typeCache.as3commons_reflect::addToMetadataCache(md.name, className);
							}
						}
					}
				}
			}

			include "../io/readU32.as.tmpl";
			const scriptCount:int = result;
			while (scriptCount--) {
				include "../io/readU32.as.tmpl";
				//gatherMetaData(classNames, constantPool, methods, metadatas, true, typeCache);
				include "../io/readU32.as.tmpl";
				traitCount = result;
				while (traitCount--) {
					className = null;
					// traits_info  
					// { 
					//  u30 name 
					//  u8  kind 
					//  u8  data[] 
					//  u30 metadata_count 
					//  u30 metadata[metadata_count] 
					// }
					include "../io/readU32.as.tmpl";
					traitKindValue = 255 & byteStream[byteStream.position++];
					kindMasked = traitKindValue & 0xF;
					if ((kindMasked == 0) || (kindMasked == 6)) {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
						if (result != 0) {
							byteStream.position++;
						}
					} else if ((kindMasked == 1) || (kindMasked == 2) || (kindMasked == 3) || (kindMasked == 5)) {
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
					} else if (kindMasked == 4) {
						// trait_class 
						// { 
						//  u30 slot_id 
						//  u30 classi 
						// }
						include "../io/readU32.as.tmpl";
						include "../io/readU32.as.tmpl";
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
						include "../io/readU32.as.tmpl";
						numberOfTraitMetadataItems = result;
						while (numberOfTraitMetadataItems--) {
							include "../io/readU32.as.tmpl";
							if (className != null) {
								md = metadatas[result];
								typeCache.as3commons_reflect::addToMetadataCache(md.name, className);
							}
						}
					}
				}
			}

		}

	}
}
