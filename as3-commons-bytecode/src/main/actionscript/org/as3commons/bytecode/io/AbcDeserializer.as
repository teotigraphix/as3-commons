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
	import flash.utils.getTimer;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.FunctionTrait;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.MultinameG;
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
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.bytecode.util.OpcodeIO;
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
		private static const ASSERT_EXTRACTION_ERROR_TEMPLATE:String = "Expected {0} elements in {1}, actual count is {2}";

		private var _methodBodyExtractionMethod:MethodBodyExtractionKind;

		public function AbcDeserializer(byteStream:ByteArray=null) {
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
					throw new Error(StringUtils.substitute(ASSERT_EXTRACTION_ERROR_TEMPLATE, expectedCount, collectionName, collectionLength));
				}
			}
		}

		/**
		 * Takes the ABC block handed to the constructor and deserializes it.
		 *
		 * @return  The <code>AbcFile</code> represented by the bytecode block given to the constructor.
		 */
		override public function deserialize(positionInByteArrayToReadFrom:int=0):AbcFile {
			_byteStream.position = positionInByteArrayToReadFrom;
			var abcFile:AbcFile = new AbcFile();
			var pool:IConstantPool = abcFile.constantPool;

			CONFIG::debug {
				trace("Deserialize ABC");
				var startTimestamp:Number = getTimer();
			}

			abcFile.minorVersion = AbcSpec.readU16(_byteStream);
			abcFile.majorVersion = AbcSpec.readU16(_byteStream);

			//When deserializing a constantpool its rather senseless to perform any duplicatechecks in the pool,
			//so in this instance we turn it off and back on after deserialization:
			pool.dupeCheck = false;
			deserializeConstantPool(pool);
			CONFIG::debug {
				logParseTime("Constant pool 1", startTimestamp);
			}
			pool.initializeLookups();
			CONFIG::debug {
				logParseTime("Constant lookups", startTimestamp);
			}
			pool.dupeCheck = true;

			CONFIG::debug {
				logParseTime("Constant pool", startTimestamp);
			}

			deserializeMethodInfos(abcFile, pool);

			CONFIG::debug {
				logParseTime("Method infos", startTimestamp);
			}

			deserializeMetadata(abcFile, pool);

			CONFIG::debug {
				logParseTime("Metadata", startTimestamp);
			}

			var classCount:int = deserializeInstanceInfo(abcFile, pool);

			CONFIG::debug {
				logParseTime("Instance info", startTimestamp);
			}

			deserializeClassInfos(abcFile, pool, classCount);

			CONFIG::debug {
				logParseTime("Class info", startTimestamp);
			}

			// script_info
			// {
			//  u30 init
			//  u30 trait_count
			//  traits_info trait[trait_count]
			// }
//            trace("Scripts: " + _byteStream.position);
			deserializeScriptInfos(abcFile);

			CONFIG::debug {
				logParseTime("Script info", startTimestamp);
			}

			deserializeMethodBodies(abcFile, pool);

			CONFIG::debug {
				logParseTime("Method bodies", startTimestamp);
				trace("Deserialize ABC done");
			}

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
				CONFIG::debug {
					Assert.notNull(abcFile.instanceInfo[classIndex]);
				}
				classInfo.classMultiname = InstanceInfo(abcFile.instanceInfo[classIndex]).classMultiname;
				classInfo.staticInitializer = abcFile.methodInfo[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(classInfo.staticInitializer);
				}
				classInfo.staticInitializer.as3commonsBytecodeName = STATIC_INITIALIZER_BYTECODENAME;
				classInfo.traits = deserializeTraitsInfo(abcFile, _byteStream, true);
				abcFile.instanceInfo[classIndex].classInfo = classInfo;
				abcFile.addClassInfo(classInfo);
			}
		}

		public override function deserializeMethodBodies(abcFile:AbcFile, pool:IConstantPool):void {
			var methodBodyCount:int = AbcSpec.readU30(_byteStream);
			//trace("methodBody count:" + methodBodyCount);
			for (var bodyIndex:int = 0; bodyIndex < methodBodyCount; ++bodyIndex) {
				//trace("deserializing method body #", bodyIndex);
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
				methodBody.methodSignature = abcFile.methodInfo[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(methodBody.methodSignature);
				}
				methodBody.methodSignature.methodBody = methodBody;
				methodBody.maxStack = AbcSpec.readU30(_byteStream);
				methodBody.localCount = AbcSpec.readU30(_byteStream);
				methodBody.initScopeDepth = AbcSpec.readU30(_byteStream);
				methodBody.maxScopeDepth = AbcSpec.readU30(_byteStream);

				var codeLength:int = AbcSpec.readU30(_byteStream);
				switch (methodBodyExtractionMethod) {
					case MethodBodyExtractionKind.PARSE:
						methodBody.opcodes = OpcodeIO.parse(_byteStream, codeLength, methodBody, abcFile.constantPool);
						break;
					case MethodBodyExtractionKind.BYTEARRAY:
						methodBody.rawOpcodes = AbcSpec.newByteArray();
						methodBody.rawOpcodes.writeBytes(_byteStream, _byteStream.position, codeLength);
					case MethodBodyExtractionKind.SKIP:
						_byteStream.position += codeLength;
						break;
				}

				methodBody.exceptionInfos = extractExceptionInfos(_byteStream, pool, methodBody);

				//Add the ExceptionInfo reference to all opcodes that until now only carried an
				//index of the reference (this replaces the index with the actual reference in the parameter):
				if (methodBodyExtractionMethod === MethodBodyExtractionKind.PARSE) {
					resolveExceptionInfos(methodBody);
				}

				methodBody.traits = deserializeTraitsInfo(abcFile, _byteStream);

				abcFile.addMethodBody(methodBody);
			}
		}

		public static function resolveExceptionInfos(methodBody:MethodBody):void {
			for each (var exceptionInfo:ExceptionInfo in methodBody.exceptionInfos) {
				resolveExceptionInfoOpcodes(exceptionInfo, methodBody);
			}
			resolveOpcodeExceptionInfos(methodBody);
		}

		public static function extractExceptionInfos(input:ByteArray, constantPool:IConstantPool, methodBody:MethodBody):Vector.<ExceptionInfo> {
			var exceptionInfos:Vector.<ExceptionInfo> = new Vector.<ExceptionInfo>();
			var exceptionCount:int = AbcSpec.readU30(input);
			for (var exceptionIndex:int = 0; exceptionIndex < exceptionCount; ++exceptionIndex) {
				// exception_info
				// {
				//  u30 from
				//  u30 to
				//  u30 target
				//  u30 exc_type
				//  u30 var_name
				// The AVM2 documentation is wrong again here, exc_type and var_name are
				// indexes into the multiname pool instead of the string pool
				// }
				var exceptionInfo:ExceptionInfo = new ExceptionInfo();
				exceptionInfo.exceptionEnabledFromCodePosition = AbcSpec.readU30(input);
				exceptionInfo.exceptionEnabledToCodePosition = AbcSpec.readU30(input);
				exceptionInfo.codePositionToJumpToOnException = AbcSpec.readU30(input);

				exceptionInfo.exceptionType = QualifiedName(constantPool.multinamePool[AbcSpec.readU30(input)]);
				exceptionInfo.variableReceivingException = QualifiedName(constantPool.multinamePool[AbcSpec.readU30(input)]);
				CONFIG::debug {
					Assert.notNull(exceptionInfo.variableReceivingException);
				}
				exceptionInfos[exceptionInfos.length] = exceptionInfo;
			}
			return exceptionInfos;
		}

		public static function resolveExceptionInfoOpcodes(exceptionInfo:ExceptionInfo, methodBody:MethodBody):void {
			exceptionInfo.exceptionEnabledFromOpcode = methodBody.opcodeBaseLocations[exceptionInfo.exceptionEnabledFromCodePosition];
			CONFIG::debug {
				Assert.notNull(exceptionInfo.exceptionEnabledFromOpcode);
			}
			exceptionInfo.exceptionEnabledToOpcode = methodBody.opcodeBaseLocations[exceptionInfo.exceptionEnabledToCodePosition];
			CONFIG::debug {
				Assert.notNull(exceptionInfo.exceptionEnabledToOpcode);
			}
			exceptionInfo.opcodeToJumpToOnException = methodBody.opcodeBaseLocations[exceptionInfo.codePositionToJumpToOnException];
			CONFIG::debug {
				Assert.notNull(exceptionInfo.opcodeToJumpToOnException);
			}
		}

		public static function resolveOpcodeExceptionInfos(methodBody:MethodBody):void {
			var exceptionIndex:int = -1;
			var len:int = methodBody.exceptionInfos.length;
			if (len > 0) {
				var foundLen:int = 0;
				for each (var op:Op in methodBody.opcodes) {
					var idx:int = getExceptionInfoArgumentIndex(op);
					if (idx > -1) {
						exceptionIndex = int(op.parameters[idx]);
						op.parameters[idx] = methodBody.exceptionInfos[exceptionIndex];
						CONFIG::debug {
							Assert.notNull(op.parameters[idx]);
						}
						if (++foundLen == len) {
							break;
						}
					}
				}
			}
		}

		public override function deserializeScriptInfos(abcFile:AbcFile):void {
			var scriptCount:int = AbcSpec.readU30(_byteStream);
			for (var scriptIndex:int = 0; scriptIndex < scriptCount; ++scriptIndex) {
				var scriptInfo:ScriptInfo = new ScriptInfo();
				scriptInfo.scriptInitializer = abcFile.methodInfo[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(scriptInfo.scriptInitializer);
				}
				scriptInfo.scriptInitializer.as3commonsBytecodeName = SCRIPT_INITIALIZER_BYTECODENAME;
				scriptInfo.traits = deserializeTraitsInfo(abcFile, _byteStream);
				abcFile.addScriptInfo(scriptInfo);
			}
		}

		public override function deserializeInstanceInfo(abcFile:AbcFile, pool:IConstantPool):int {
			var classCount:int = AbcSpec.readU30(_byteStream);
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
				var classMultiname:BaseMultiname = pool.multinamePool[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(classMultiname);
				}

				instanceInfo.classMultiname = MultinameUtil.convertToQualifiedName(classMultiname);
				instanceInfo.superclassMultiname = pool.multinamePool[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(instanceInfo.superclassMultiname);
				}
				var instanceInfoFlags:int = AbcSpec.readU8(_byteStream);
				instanceInfo.isFinal = ClassConstant.FINAL.present(instanceInfoFlags);
				instanceInfo.isInterface = ClassConstant.INTERFACE.present(instanceInfoFlags);
				instanceInfo.isProtected = ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags);
				instanceInfo.isSealed = ClassConstant.SEALED.present(instanceInfoFlags);
				if (instanceInfo.isProtected) {
					instanceInfo.protectedNamespace = pool.namespacePool[AbcSpec.readU30(_byteStream)];
					CONFIG::debug {
						Assert.notNull(instanceInfo.protectedNamespace);
					}
				}
				var interfaceCount:int = AbcSpec.readU30(_byteStream);
				for (var interfaceIndex:int = 0; interfaceIndex < interfaceCount; ++interfaceIndex) {
					var intfIdx:int = AbcSpec.readU30(_byteStream);
					instanceInfo.interfaceMultinames[instanceInfo.interfaceMultinames.length] = pool.multinamePool[intfIdx];
					CONFIG::debug {
						Assert.notNull(pool.multinamePool[intfIdx]);
					}
				}
				instanceInfo.instanceInitializer = abcFile.methodInfo[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(instanceInfo.instanceInitializer);
				}
				instanceInfo.instanceInitializer.as3commonsBytecodeName = CONSTRUCTOR_BYTECODENAME;
				instanceInfo.traits = deserializeTraitsInfo(abcFile, _byteStream, false, instanceInfo.classMultiname.fullName);
				abcFile.addInstanceInfo(instanceInfo);
			}
			return classCount;
		}

		public override function deserializeMetadata(abcFile:AbcFile, pool:IConstantPool):void {
			var metadataCount:int = AbcSpec.readU30(_byteStream);
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
				metadataInstance.name = pool.stringPool[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(metadataInstance.name);
				}
				abcFile.addMetadataInfo(metadataInstance);
				var keyValuePairCount:int = AbcSpec.readU30(_byteStream);
				var keys:Array = [];

				var key:String;
				var keyIndex:int;
				// Suck out the keys first
				for (keyIndex = 0; keyIndex < keyValuePairCount; ++keyIndex) {
					key = pool.stringPool[AbcSpec.readU30(_byteStream)];
					CONFIG::debug {
						Assert.notNull(key);
					}
					keys[keys.length] = key;
				}

				var value:String;
				var currentKey:String;
				// Map keys to values in another loop
				for each (currentKey in keys) {
					// Note that if a key is zero, then this is a keyless entry and only carries a value (AVM2 overview, page 27 under 4.6 metadata_info)
					value = pool.stringPool[AbcSpec.readU30(_byteStream)];
					CONFIG::debug {
						Assert.notNull(value);
					}
					metadataInstance.properties[currentKey] = value;
				}
			}
		}

		public override function deserializeMethodInfos(abcFile:AbcFile, pool:IConstantPool):void {
			var methodCount:int = AbcSpec.readU30(_byteStream);
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
				var paramCount:int = AbcSpec.readU30(_byteStream);
				//trace("MethodInfo param count: " + paramCount);
				methodInfo.returnType = pool.multinamePool[AbcSpec.readU30(_byteStream)];
				CONFIG::debug {
					Assert.notNull(methodInfo.returnType);
				}
				//trace("MethodInfo return type: " + methodInfo.returnType);
				for (var argumentIndex:int = 0; argumentIndex < paramCount; ++argumentIndex) {
					var mn:BaseMultiname = pool.multinamePool[AbcSpec.readU30(_byteStream)];
					CONFIG::debug {
						Assert.notNull(mn);
					}
					var paramQName:BaseMultiname = (mn is MultinameG) ? mn : MultinameUtil.convertToQualifiedName(mn);
					var arg:Argument = new Argument(paramQName);
					methodInfo.argumentCollection[methodInfo.argumentCollection.length] = arg;
						//trace("MethodInfo param " + argumentIndex + ": " + arg.toString());
				}
				methodInfo.methodName = pool.stringPool[AbcSpec.readU30(_byteStream)];
				methodInfo.scopeName = MultinameUtil.extractInterfaceScopeFromFullName(methodInfo.methodName);
				methodInfo.flags = AbcSpec.readU8(_byteStream);

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
					var optionInfoCount:int = AbcSpec.readU30(_byteStream);
					//trace("Method has " + optionInfoCount + " optional parameters");
					//trace("optioninfo count:" + optionInfoCount);
					for (var optionInfoIndex:int = 0; optionInfoIndex < optionInfoCount; ++optionInfoIndex) {
						var valueIndexInConstantPool:int = AbcSpec.readU30(_byteStream);
						var optionalValueKind:int = AbcSpec.readU8(_byteStream);
						var defaultValue:* = null;
						switch (optionalValueKind) {
							case ConstantKind.INT.value:
								defaultValue = pool.integerPool[valueIndexInConstantPool];
								CONFIG::debug {
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
							}
								break;
							case ConstantKind.UINT.value:
								defaultValue = pool.uintPool[valueIndexInConstantPool];
								CONFIG::debug {
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
							}
								break;
							case ConstantKind.DOUBLE.value:
								defaultValue = pool.doublePool[valueIndexInConstantPool];
								CONFIG::debug {
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
							}
								break;
							case ConstantKind.UTF8.value:
								defaultValue = pool.stringPool[valueIndexInConstantPool];
								CONFIG::debug {
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
							}
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
								CONFIG::debug {
								Assert.notNull(defaultValue, "defaultValue returned null from constant pool");
							}
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
						var paramName:String = abcFile.constantPool.stringPool[AbcSpec.readU30(_byteStream)];
						CONFIG::debug {
							Assert.notNull(paramName);
						}
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

		public override function deserializeTraitsInfo(abcFile:AbcFile, _byteStream:ByteArray, isStatic:Boolean=false, className:String=""):Vector.<TraitInfo> {
			var traits:Vector.<TraitInfo> = new Vector.<TraitInfo>();
			var pool:IConstantPool = abcFile.constantPool;
			var methodInfos:Vector.<MethodInfo> = abcFile.methodInfo;
			var metadata:Vector.<Metadata> = abcFile.metadataInfo;

			var traitCount:int = AbcSpec.readU30(_byteStream);
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
				var multiNameIndex:uint = AbcSpec.readU30(_byteStream);
				var traitName:BaseMultiname = pool.multinamePool[multiNameIndex];
				CONFIG::debug {
					Assert.notNull(traitName);
				}
				var traitMultiname:QualifiedName = MultinameUtil.convertToQualifiedName(traitName);
				var traitKindValue:int = AbcSpec.readU8(_byteStream);
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
						slotOrConstantTrait.slotId = AbcSpec.readU30(_byteStream);
						slotOrConstantTrait.typeMultiname = pool.multinamePool[AbcSpec.readU30(_byteStream)];
						CONFIG::debug {
						Assert.notNull(slotOrConstantTrait.typeMultiname);
					}
						slotOrConstantTrait.vindex = AbcSpec.readU30(_byteStream);
						slotOrConstantTrait.isStatic = isStatic;
						if (slotOrConstantTrait.vindex > 0) {
							slotOrConstantTrait.vkind = ConstantKind.determineKind(AbcSpec.readU8(_byteStream));
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
						methodTrait.dispositionId = AbcSpec.readU30(_byteStream);

						// It's not strictly necessary to do this, but it helps the API for the MethodInfo to have a
						// reference to its traits and vice versa
						var associatedMethodInfo:MethodInfo = methodInfos[AbcSpec.readU30(_byteStream)];
						CONFIG::debug {
						Assert.notNull(associatedMethodInfo);
					}
						associatedMethodInfo.methodName = traitMultiname.name;
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
						classTrait.classSlotId = AbcSpec.readU30(_byteStream);
						classTrait.classIndex = AbcSpec.readU30(_byteStream);
						classTrait.classInfo = abcFile.classInfo[classTrait.classIndex];
						trait = classTrait;
						break;

					case TraitKind.FUNCTION:
						// trait_function
						// {
						//  u30 slot_id
						//  u30 function
						// }
						var functionTrait:FunctionTrait = new FunctionTrait();
						functionTrait.functionSlotId = AbcSpec.readU30(_byteStream);
						functionTrait.functionMethod = methodInfos[AbcSpec.readU30(_byteStream)];
						CONFIG::debug {
						Assert.notNull(functionTrait.functionMethod);
					}
						functionTrait.functionMethod.methodName = traitMultiname.name;
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
					var traitMetadataCount:int = AbcSpec.readU30(_byteStream);
					for (var traitMetadataIndex:int = 0; traitMetadataIndex < traitMetadataCount; ++traitMetadataIndex) {
						var mt:Metadata = metadata[AbcSpec.readU30(_byteStream)];
						CONFIG::debug {
							Assert.notNull(mt);
						}
						trait.addMetadata(mt);
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

		CONFIG::debug {
			private static function logParseTime(name:String, startTimestamp:Number):void {
				trace(" - " + name + " parsed at " + (getTimer() - startTimestamp) + " ms");
			}
		}

	}
}
