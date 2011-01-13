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
package org.as3commons.bytecode.io {
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.FunctionTrait;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.ScriptInfo;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ClassConstant;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.abc.enum.TraitAttributes;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Takes an ABC bytecode block as a stream of bytes and converts it in to an as3commons-bytecode representation of the ABC file format. This
	 * class is the symmetric opposite of <code>AbcSerializer</code>.
	 *
	 * <p>
	 * Bytecode can be loaded either from the file system or a SWF file and handed to this object for deserialization.
	 * </p>
	 *
	 * @see    AbcSerializer
	 */
	//TODO: Capture ranges for bytecode blocks so they can be checked in unit tests
	public class AbcDeserializer extends AbstractAbcDeserializer implements IAbcDeserializer {

		public static const __NEED_CONSTANTS_:String = "~~ need constants ~~";
		public static const CONSTRUCTOR_BYTECODENAME:String = "constructor";
		public static const STATIC_INITIALIZER_BYTECODENAME:String = "staticInitializer";
		public static const SCRIPT_INITIALIZER_BYTECODENAME:String = "scriptInitializer";

		private var _methodBodyExtractionMethod:MethodBodyExtractionKind;

		public function AbcDeserializer(byteStream:ByteArray) {
			super(byteStream);
			methodBodyExtractionMethod = MethodBodyExtractionKind.PARSE;
		}

		override public function get methodBodyExtractionMethod():MethodBodyExtractionKind {
			return _methodBodyExtractionMethod;
		}

		override public function set methodBodyExtractionMethod(value:MethodBodyExtractionKind):void {
			_methodBodyExtractionMethod = value;
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

		/**
		 * Takes the ABC block handed to the constructor and deserializes it.
		 *
		 * @return  The <code>AbcFile</code> represented by the bytecode block given to the constructor.
		 */
		override public function deserialize(positionInByteArrayToReadFrom:int = 0):AbcFile {
			byteStream.position = positionInByteArrayToReadFrom;
			var abcFile:AbcFile = new AbcFile();
			var pool:IConstantPool = abcFile.constantPool;

			var startTime:Number = new Date().getTime();

			abcFile.minorVersion = readU16();
			abcFile.majorVersion = readU16();

			deserializeConstantPool(pool);

			deserializeMethodInfos(abcFile, pool);

//            trace("Metadata: " + _byteStream.position);
			deserializeMetadata(abcFile, pool);

//            trace("Classes: " + _byteStream.position);
			var classCount:int = deserializeInstanceInfo(abcFile, pool);

			deserializeClassInfos(abcFile, pool, classCount);

			trace("ClassInfos parsed by " + (new Date().getTime() - startTime) + " ms");

			// script_info  
			// { 
			//  u30 init 
			//  u30 trait_count 
			//  traits_info trait[trait_count] 
			// }
//            trace("Scripts: " + _byteStream.position);
			deserializeScriptInfos(abcFile);

			trace("ScriptInfos parsed by " + (new Date().getTime() - startTime) + " ms");

//            trace("MethodBodies: " + _byteStream.position);
			deserializeMethodBodies(abcFile, pool);

			trace("MethodInfos parsed by " + (new Date().getTime() - startTime) + " ms");

			return abcFile;
		}

		public override function deserializeClassInfos(abcFile:AbcFile, pool:IConstantPool, classCount:int):void {
			// class info
			//	        trace("ClassInfo: " + _byteStream.position);
			for (var classIndex:int = 0; classIndex < classCount; ++classIndex) {
				// class_info  
				// { 
				//  u30 cinit 
				//  u30 trait_count 
				//  traits_info traits[trait_count] 
				// }
				var classInfo:ClassInfo = new ClassInfo();
				classInfo.classMultiname = InstanceInfo(abcFile.instanceInfo[classIndex]).classMultiname;
				classInfo.staticInitializer = abcFile.methodInfo[readU30()];
				classInfo.staticInitializer.as3commonsBytecodeName = STATIC_INITIALIZER_BYTECODENAME;
				classInfo.traits = deserializeTraitsInfo(abcFile, byteStream, true);
				abcFile.instanceInfo[classIndex].classInfo = classInfo;
				abcFile.addClassInfo(classInfo);
			}
		}


		public override function deserializeMethodBodies(abcFile:AbcFile, pool:IConstantPool):void {
			var methodBodyCount:int = readU30();
			trace("methodBody count:" + methodBodyCount);
			for (var bodyIndex:int = 0; bodyIndex < methodBodyCount; ++bodyIndex) {
				var methodBody:MethodBody = new MethodBody();
				// method_body_info 
				// { 
				//  u30 method 
				//  u30 max_stack 
				//  u30 local_count 
				//  u30 init_scope_depth  
				//  u30 max_scope_depth 
				//  u30 code_length 
				//  u8  code[code_length] 
				//  u30 exception_count 
				//  exception_info exception[exception_count] 
				//  u30 trait_count 
				//  traits_info trait[trait_count] 
				// }
				methodBody.methodSignature = abcFile.methodInfo[readU30()];
				methodBody.methodSignature.methodBody = methodBody;
				methodBody.maxStack = readU30();
				methodBody.localCount = readU30();
				methodBody.initScopeDepth = readU30();
				methodBody.maxScopeDepth = readU30();

				var codeLength:int = readU30();
				if (methodBodyExtractionMethod === MethodBodyExtractionKind.PARSE) {
					methodBody.opcodes = Opcode.parse(byteStream, codeLength, methodBody, abcFile.constantPool);
				} else if (methodBodyExtractionMethod === MethodBodyExtractionKind.BYTEARRAY) {
					methodBody.rawOpcodes.writeBytes(byteStream, byteStream.position, codeLength);
					byteStream.position += codeLength;
				} else {
					byteStream.position += codeLength;
				}

				var exceptionCount:int = readU30();
				var exceptionInfos:Array = methodBody.exceptionInfos;
				/*trace("----------------------------------------------------");
				   trace("Method: " + methodBody.methodSignature.methodName);
				   trace("Opcode count: " + methodBody.opcodes.length);
				   trace("Exception info count: " + exceptionCount);
				 trace("----------------------------------------------------");*/
				for (var exceptionIndex:int = 0; exceptionIndex < exceptionCount; ++exceptionIndex) {
					trace("Exception #" + exceptionIndex);
					var exceptionInfo:ExceptionInfo = new ExceptionInfo();
					// exception_info  
					// { 
					//  u30 from 
					//  u30 to  
					//  u30 target 
					//  u30 exc_type 
					//  u30 var_name 
					// }
					exceptionInfo.exceptionEnabledFromCodePosition = readU30();
					exceptionInfo.exceptionEnabledToCodePosition = readU30();
					exceptionInfo.codePositionToJumpToOnException = readU30();
					exceptionInfo.exceptionType = pool.multinamePool[readU30()];
					Assert.notNull(exceptionInfo.exceptionType, "exceptionInfo.exceptionTypeName returned null from constant pool");
					exceptionInfo.variableReceivingException = pool.multinamePool[readU30()];
					Assert.notNull(exceptionInfo.variableReceivingException, "exceptionInfo.nameOfVariableReceivingException returned null from constant pool");
					exceptionInfos[exceptionInfos.length] = exceptionInfo;
				}

				//Add the ExceptionInfo reference to all opcodes to until now only carried an
				//index for the reference (this replaces the index with the actual reference in the parameter):
				for each (var op:Op in methodBody.opcodes) {
					var idx:int = getExceptionInfoArgumentIndex(op);
					if (idx > -1) {
						exceptionIndex = op.parameters[idx];
						op.parameters[idx] = methodBody.exceptionInfos[exceptionIndex];
						Assert.notNull(op.parameters[idx], op.parameters[idx].toString() + " returned null from method exception info collection");
					}
				}

				methodBody.traits = deserializeTraitsInfo(abcFile, byteStream);

				abcFile.addMethodBody(methodBody);
			}
		}


		public override function deserializeScriptInfos(abcFile:AbcFile):void {
			var scriptCount:int = readU30();
			for (var scriptIndex:int = 0; scriptIndex < scriptCount; ++scriptIndex) {
				var scriptInfo:ScriptInfo = new ScriptInfo();
				scriptInfo.scriptInitializer = abcFile.methodInfo[readU30()];
				scriptInfo.scriptInitializer.as3commonsBytecodeName = SCRIPT_INITIALIZER_BYTECODENAME;
				scriptInfo.traits = deserializeTraitsInfo(abcFile, byteStream);
				abcFile.addScriptInfo(scriptInfo);
			}
		}


		public override function deserializeInstanceInfo(abcFile:AbcFile, pool:IConstantPool):int {
			var classCount:int = readU30();
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
				var instanceInfo:InstanceInfo = new InstanceInfo();

				// The AVM2 spec dictates that this should always be a QualifiedName, but when parsing SWFs I have come across
				// Multinames with single namespaces (which are essentially QualifiedNames - the only reason to be a multiname
				// is to have multiple namespaces to search within to resolve a name). I haven't heard back from the Tamarin
				// list yet on this anomaly so I'm going to convert single-namespace Multinames to QualifiedNames here.
				//
				// From the spec (Section 4.7 "Instance", page 28):
				//  name 
				//      The name field is an index into the multiname array of the constant pool; it provides a name for the 
				//      class. The entry specified must be a QName. 
				var classMultiname:BaseMultiname = pool.multinamePool[readU30()];

				instanceInfo.classMultiname = MultinameUtil.convertToQualifiedName(classMultiname);
				instanceInfo.superclassMultiname = pool.multinamePool[readU30()];
				var instanceInfoFlags:int = readU8();
				instanceInfo.isFinal = ClassConstant.FINAL.present(instanceInfoFlags);
				instanceInfo.isInterface = ClassConstant.INTERFACE.present(instanceInfoFlags);
				instanceInfo.isProtected = ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags);
				instanceInfo.isSealed = ClassConstant.SEALED.present(instanceInfoFlags);
				if (instanceInfo.isProtected) {
					instanceInfo.protectedNamespace = pool.namespacePool[readU30()];
				}
				var interfaceCount:int = readU30();
				for (var interfaceIndex:int = 0; interfaceIndex < interfaceCount; ++interfaceIndex) {
					var intfIdx:int = readU30();
					instanceInfo.interfaceMultinames[instanceInfo.interfaceMultinames.length] = pool.multinamePool[intfIdx];
				}
				instanceInfo.instanceInitializer = abcFile.methodInfo[readU30()];
				instanceInfo.instanceInitializer.as3commonsBytecodeName = CONSTRUCTOR_BYTECODENAME;
				instanceInfo.traits = deserializeTraitsInfo(abcFile, byteStream);
				abcFile.addInstanceInfo(instanceInfo);
			}
			return classCount;
		}


		public override function deserializeMetadata(abcFile:AbcFile, pool:IConstantPool):void {
			var metadataCount:int = readU30();
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
				var metadataInstance:Metadata = new Metadata();
				metadataInstance.name = pool.stringPool[readU30()];
				abcFile.addMetadataInfo(metadataInstance);
				var keyValuePairCount:int = readU30();
				var keys:Array = [];

				// Suck out the keys first
				for (var keyIndex:int = 0; keyIndex < keyValuePairCount; ++keyIndex) {
					var key:String = pool.stringPool[readU30()];
					keys[keys.length] = key;
				}

				// Map keys to values in another loop
				for each (var currentKey:String in keys) {
					// Note that if a key is zero, then this is a keyless entry and only carries a value (AVM2 overview, page 27 under 4.6 metadata_info) 
					var value:String = pool.stringPool[readU30()];
					metadataInstance.properties[currentKey] = value;
				}
			}
		}


		public override function deserializeMethodInfos(abcFile:AbcFile, pool:IConstantPool):void {
			var methodCount:int = readU30();
			//trace("MethodInfo count: " + methodCount);
			for (var methodIndex:int = 0; methodIndex < methodCount; ++methodIndex) {
				//trace("---------------------------------------------------------------------");
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
				var methodInfo:MethodInfo = new MethodInfo();
				abcFile.addMethodInfo(methodInfo);
				var paramCount:int = readU30();
				//trace("MethodInfo param count: " + paramCount);
				methodInfo.returnType = pool.multinamePool[readU30()];
				//trace("MethodInfo return type: " + methodInfo.returnType);
				for (var argumentIndex:int = 0; argumentIndex < paramCount; ++argumentIndex) {
					var mn:BaseMultiname = pool.multinamePool[readU30()];
					var paramQName:QualifiedName = MultinameUtil.convertToQualifiedName(mn);
					var arg:Argument = new Argument(paramQName);
					methodInfo.argumentCollection[methodInfo.argumentCollection.length] = arg;
						//trace("MethodInfo param " + argumentIndex + ": " + arg.toString());
				}
				methodInfo.methodName = pool.stringPool[readU30()];
				methodInfo.scopeName = MultinameUtil.extractNamespaceNameFromFullName(methodInfo.methodName);
				//trace("Method name " + methodInfo.methodName);
				methodInfo.flags = readU8();

				if (MethodFlag.flagPresent(methodInfo.flags, MethodFlag.HAS_OPTIONAL)) {
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
					//trace("Method has " + optionInfoCount + " optional parameters");
					//trace("optioninfo count:" + optionInfoCount);
					for (var optionInfoIndex:int = 0; optionInfoIndex < optionInfoCount; ++optionInfoIndex) {
						var valueIndexInConstantPool:int = readU30();
						var optionalValueKind:int = readU8();
						var defaultValue:Object = null;
						switch (optionalValueKind) {
							case ConstantKind.INT.value:
								defaultValue = pool.integerPool[valueIndexInConstantPool];
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
								break;

							case ConstantKind.UINT.value:
								defaultValue = pool.uintPool[valueIndexInConstantPool];
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
								break;

							case ConstantKind.DOUBLE.value:
								defaultValue = pool.doublePool[valueIndexInConstantPool];
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
								break;

							case ConstantKind.UTF8.value:
								defaultValue = pool.stringPool[valueIndexInConstantPool];
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
								break;

							case ConstantKind.TRUE.value:
								defaultValue = true;
								break;

							case ConstantKind.FALSE.value:
								defaultValue = false;
								break;

							case ConstantKind.NULL.value:
								defaultValue = null;
								break;

							case ConstantKind.UNDEFINED.value:
								defaultValue = undefined;
								break;

							case ConstantKind.NAMESPACE.value:
							case ConstantKind.PACKAGE_NAMESPACE.value:
							case ConstantKind.PACKAGE_INTERNAL_NAMESPACE.value:
							case ConstantKind.PROTECTED_NAMESPACE.value:
							case ConstantKind.EXPLICIT_NAMESPACE.value:
							case ConstantKind.STATIC_PROTECTED_NAMESPACE.value:
							case ConstantKind.PRIVATE_NAMESPACE.value:
								defaultValue = pool.namespacePool[valueIndexInConstantPool];
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
								break;
							default:
								throw new Error("Unknown optional value kind: " + optionalValueKind);
								break;
						}
						//var qualifiedName:QualifiedName = new QualifiedName(__NEED_CONSTANTS_, null, MultinameKind.QNAME);
						//var optArg:Argument = new Argument(qualifiedName, true, defaultValue, ConstantKind.determineKind(optionalValueKind));
						//methodInfo.argumentCollection[methodInfo.argumentCollection.length] = optArg;
						var len:int = methodInfo.argumentCollection.length;
						var argIdx:int = int((len - optionInfoCount) + optionInfoIndex);
						var optArg:Argument = Argument(methodInfo.argumentCollection[argIdx]);
						optArg.defaultValue = defaultValue;
						optArg.kind = ConstantKind.determineKind(optionalValueKind);
						optArg.isOptional = true;
							//trace("Optional argument " + optionInfoIndex + ": " + optArg.toString());
					}
				}

				if (MethodFlag.flagPresent(methodInfo.flags, MethodFlag.HAS_PARAM_NAMES)) {
					//trace("Method has param names:");
					// param_info
					// {
					//  u30 param_name[param_count] -- index in to String Pool
					// }
					var nameCount:uint = methodInfo.argumentCollection.length;
					for (var nameIndex:uint = 0; nameIndex < nameCount; ++nameIndex) {
						var paramName:String = abcFile.constantPool.stringPool[readU30()];
						Argument(methodInfo.argumentCollection[nameIndex]).name = paramName;
							//trace("Param name " + nameIndex + ": " + paramName);
					}
				}
			}
		}


		public static function getExceptionInfoArgumentIndex(op:Op):int {
			if (op.opcode === Opcode.newcatch) {
				return 0;
			}
			return -1;
		}

		public override function deserializeTraitsInfo(abcFile:AbcFile, byteStream:ByteArray, isStatic:Boolean = false):Array {
			var traits:Array = [];
			var pool:IConstantPool = abcFile.constantPool;
			var methodInfos:Array = abcFile.methodInfo;
			var metadata:Array = abcFile.metadataInfo;

			var traitCount:int = readU30();
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
				var multiNameIndex:uint = readU30();
				var traitName:BaseMultiname = pool.multinamePool[multiNameIndex];
				var traitMultiname:QualifiedName = MultinameUtil.convertToQualifiedName(traitName);
				var traitKindValue:int = readU8();
				var traitKind:TraitKind = TraitKind.determineKind(traitKindValue);
				switch (traitKind) {
					case TraitKind.SLOT:
					case TraitKind.CONST:
						// trait_slot 
						// { 
						//  u30 slot_id 
						//  u30 type_name 
						//  u30 vindex 
						//  u8  vkind  
						// }
						var slotOrConstantTrait:SlotOrConstantTrait = new SlotOrConstantTrait();
						slotOrConstantTrait.slotId = readU30();
						slotOrConstantTrait.typeMultiname = pool.multinamePool[readU30()];
						slotOrConstantTrait.vindex = readU30();
						slotOrConstantTrait.isStatic = isStatic;
						if (slotOrConstantTrait.vindex > 0) {
							slotOrConstantTrait.vkind = ConstantKind.determineKind(readU8());
							slotOrConstantTrait.defaultValue = getSlotOrConstantDefaultValue(pool, slotOrConstantTrait.vindex, slotOrConstantTrait.vkind);
						}
						trait = slotOrConstantTrait;
						break;

					case TraitKind.METHOD:
					case TraitKind.GETTER:
					case TraitKind.SETTER:
						// trait_method 
						// { 
						//  u30 disp_id 
						//  u30 method 
						// }
						var methodTrait:MethodTrait = new MethodTrait();
						methodTrait.isStatic = isStatic;
						methodTrait.dispositionId = readU30();

						// It's not strictly necessary to do this, but it helps the API for the MethodInfo to have a
						// reference to its traits and vice versa 
						var associatedMethodInfo:MethodInfo = methodInfos[readU30()];
						methodTrait.traitMethod = associatedMethodInfo;
						associatedMethodInfo.as3commonsByteCodeAssignedMethodTrait = methodTrait;
						methodTrait.traitMethod.as3commonsBytecodeName = traitMultiname;

						trait = methodTrait;
						break;

					case TraitKind.CLASS:
						// trait_class 
						// { 
						//  u30 slot_id 
						//  u30 classi 
						// }
						var classTrait:ClassTrait = new ClassTrait();
						classTrait.classSlotId = readU30();
						classTrait.classIndex = readU30();
						classTrait.classInfo = ClassInfo(abcFile.classInfo[classTrait.classIndex]);
						trait = classTrait;
						break;

					case TraitKind.FUNCTION:
						// trait_function 
						// { 
						//  u30 slot_id 
						//  u30 function 
						// } 
						var functionTrait:FunctionTrait = new FunctionTrait();
						functionTrait.functionSlotId = readU30();
						functionTrait.functionMethod = methodInfos[readU30()];
						functionTrait.isStatic = isStatic;
						functionTrait.functionMethod.as3commonsByteCodeAssignedMethodTrait = functionTrait;
						trait = functionTrait;
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
					var traitMetadataCount:int = readU30();
					for (var traitMetadataIndex:int = 0; traitMetadataIndex < traitMetadataCount; ++traitMetadataIndex) {
						trait.addMetadata(metadata[readU30()]);
					}
				}

				trait.traitMultiname = traitMultiname;
				trait.isFinal = Boolean((traitKindValue >> 4) & TraitAttributes.FINAL.bitMask);
				trait.isOverride = Boolean((traitKindValue >> 4) & TraitAttributes.OVERRIDE.bitMask);
				trait.traitKind = traitKind;
				traits[traits.length] = trait;
			}

			return traits;
		}

		protected function getSlotOrConstantDefaultValue(pool:IConstantPool, poolIndex:uint, constantKind:ConstantKind):* {
			return pool.getConstantPoolItem(constantKind.value, poolIndex);
		}

	}
}