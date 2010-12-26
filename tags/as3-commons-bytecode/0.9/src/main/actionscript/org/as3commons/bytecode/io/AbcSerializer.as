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
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.ConstantPool;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.FunctionTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.MultinameL;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedName;
	import org.as3commons.bytecode.abc.ScriptInfo;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.ClassConstant;
	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.abc.enum.TraitAttributes;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.typeinfo.ClassDefinition;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.bytecode.typeinfo.Method;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;

	/**
	 * Takes an <code>AbcFile</code> and converts it in to a stream of bytes containing a valid ABC bytecode block. This
	 * class is the symmetric opposite of <code>AbcDeserializer</code>.
	 *
	 * <p>
	 * Once the bytecode block has been serialized, it can be loaded in to the Flash Player/AVM using <code>AbcClassLoader</code>,
	 * can be written to the file system for passing to <code>avmplus</code>, put in to a SWF ABC block, or whatever else you have
	 * in mind for it.
	 * </p>
	 *
	 * @see    AbcDeserializer
	 * @see    org.as3commons.bytecode.abc.AbcFile
	 */
	public class AbcSerializer {
		public static const MINOR_VERSION:int = 16;
		public static const MAJOR_VERSION:int = 46;
		private static const UNKNOWN_TRAITKIND_ERROR:String = "Unknown trait kind: {0}";
		private static const __UNABLE_TO_DETERMINE_POOL_POSITION_ERROR:String = "Unable to determine pool position.";

		private var _pool:ConstantPool;
		private var _outputStream:ByteArray;

		public function AbcSerializer() {
			super();
		}

		/**
		 * Takes the given <code>AbcFile</code> and converts it to an ABC bytecode block.
		 *
		 * @param     The <code>AbcFile</code> to be serialized to the ABC file format.
		 * @return    A <code>ByteArray</code> containing the bytecode. The <code>ByteArray</code> position is set to 0 so it can be read from immediately.
		 */
		public function serializeAbcFile(abcFile:AbcFile):ByteArray {
			_outputStream = AbcSpec.byteArray();
			writeU16(MINOR_VERSION);
			writeU16(MAJOR_VERSION);

			var tempOutputStream:ByteArray = _outputStream;

			_outputStream = AbcSpec.byteArray();

			serializeMethodInfo(abcFile);
			serializeMetadataInfo(abcFile);
			serializeClassAndInstanceInfo(abcFile);
			serializeScriptInfo(abcFile);
			serializeMethodBodies(abcFile);

			_outputStream.position = 0;
			var trailingOutputStream:ByteArray = _outputStream;

			_outputStream = tempOutputStream;

			abcFile.constantPool.locked = true;
			serializeConstantPool(abcFile.constantPool, _outputStream);

			_outputStream.writeBytes(trailingOutputStream);

			_outputStream.position = 0;
			return _outputStream;
		}

		public function serializeMethodBodies(abcFile:AbcFile):void {
			var methodBodies:Array = abcFile.methodBodies;
			var pool:ConstantPool = abcFile.constantPool;

			writeU30(methodBodies.length);
			for each (var body:MethodBody in methodBodies) {
				writeU30(abcFile.addMethodInfo(body.methodSignature));
				writeU30(body.maxStack);
				writeU30(body.localCount);
				writeU30(body.initScopeDepth);
				writeU30(body.maxScopeDepth);

//        		trace("====> " + body.methodSignature.loomName);
				var opcodesAsByteArray:ByteArray = Opcode.serialize(body.opcodes, body, abcFile);
//        		trace(opcodesAsByteArray.length + ": " + body.methodSignature.loomName);
				writeU30(opcodesAsByteArray.length);
				var len:uint = opcodesAsByteArray.length;
				for (var opcodeBytePosition:int = 0; opcodeBytePosition < len; ++opcodeBytePosition) {
					writeU8(opcodesAsByteArray[opcodeBytePosition]);
				}
//        		for each (var opcode : int in body.opcodes)
//        		{
//        			writeU8(opcode);
//        		}

				writeU30(body.exceptionInfos.length);
				for each (var exception:ExceptionInfo in body.exceptionInfos) {
					writeU30(exception.exceptionEnabledFromCodePosition);
					writeU30(exception.exceptionEnabledToCodePosition);
					writeU30(exception.codePositionToJumpToOnException);
					writeU30(pool.addString(exception.exceptionTypeName));
					writeU30(pool.addString(exception.nameOfVariableReceivingException));
				}

				serializeTraits(body.traits, abcFile);
			}
		}

		public function serializeScriptInfo(abcFile:AbcFile):void {
			var scriptInfo:Array = abcFile.scriptInfo;

			writeU30(scriptInfo.length);
			for each (var script:ScriptInfo in scriptInfo) {
				writeU30(abcFile.addMethodInfo(script.scriptInitializer));
				serializeTraits(script.traits, abcFile);
			}
		}

		public function serializeTraits(traits:Array, abcFile:AbcFile):void {
			writeU30(traits.length);
			var pool:ConstantPool = abcFile.constantPool;

			for each (var trait:TraitInfo in traits) {
				// traits_info  
				// { 
				//  u30 name 
				//  u8  kind 
				//  u8  data[] 
				//  u30 metadata_count 
				//  u30 metadata[metadata_count] 
				// }
				writeU30(pool.addMultiname(trait.traitMultiname));

				// Assemble trait kind and flip flags for attributes
				var traitKindAndAttributes:int = trait.traitKind.bitMask;
				traitKindAndAttributes = traitKindAndAttributes | ((trait.isFinal) ? (TraitAttributes.FINAL.bitMask << 4) : null);
				traitKindAndAttributes = traitKindAndAttributes | ((trait.isOverride) ? (TraitAttributes.OVERRIDE.bitMask << 4) : null);
				traitKindAndAttributes = traitKindAndAttributes | ((trait.hasMetadata) ? (TraitAttributes.METADATA.bitMask << 4) : null);
				writeU8(traitKindAndAttributes);

				switch (trait.traitKind) {
					case TraitKind.SLOT:
					case TraitKind.CONST:
						// trait_slot 
						// { 
						//  u30 slot_id 
						//  u30 type_name 
						//  u30 vindex 
						//  u8  vkind  
						// }
						var slotTrait:SlotOrConstantTrait = trait as SlotOrConstantTrait;
						writeU30(slotTrait.slotId);
						writeU30(pool.addMultiname(slotTrait.typeMultiname));
						if (slotTrait.vkind != null) {
							var vindex:int = pool.addItemToPool(slotTrait.vkind, slotTrait.defaultValue);
							slotTrait.vindex = vindex;
						} else {
							slotTrait.vindex = 0;
						}
						writeU30(slotTrait.vindex);
						if (slotTrait.vindex > 0) {
							writeU8(slotTrait.vkind.value);
						}
						break;

					case TraitKind.METHOD:
					case TraitKind.GETTER:
					case TraitKind.SETTER:
						// trait_method 
						// { 
						//  u30 disp_id 
						//  u30 method 
						// }
						var methodTrait:MethodTrait = trait as MethodTrait;
						writeU30(methodTrait.dispositionId);
						writeU30(abcFile.addMethodInfo(methodTrait.traitMethod));
						break;

					case TraitKind.CLASS:
						// trait_class 
						// { 
						//  u30 slot_id 
						//  u30 classi 
						// }
						var classTrait:ClassTrait = trait as ClassTrait;
						classTrait.classIndex = abcFile.classInfo.indexOf(classTrait.classInfo);
						Assert.state((classTrait.classIndex > -1), "classTrait.classIndex is -1");
						writeU30(classTrait.classSlotId);
						writeU30(classTrait.classIndex);
						break;

					case TraitKind.FUNCTION:
						// trait_function 
						// { 
						//  u30 slot_id 
						//  u30 function 
						// } 
						var functionTrait:FunctionTrait = trait as FunctionTrait;
						writeU30(functionTrait.functionSlotId);
						writeU30(abcFile.addMethodInfo(functionTrait.functionMethod));
						break;

					default:
						throw new Error(StringUtils.substitute(UNKNOWN_TRAITKIND_ERROR, trait.traitKind));
						break;
				}

				if (trait.hasMetadata) {
					writeU30(trait.metadata.length);
					for each (var metadataEntry:Metadata in trait.metadata) {
						writeU30(abcFile.addMetadataInfo(metadataEntry));
					}
				}
			}
		}

		public function serializeClassAndInstanceInfo(abcFile:AbcFile):void {
			var instanceInfo:Array = abcFile.instanceInfo;
			var classInfo:Array = abcFile.classInfo;
			var pool:ConstantPool = abcFile.constantPool;

			// class_count u30
			writeU30(classInfo.length); // class_count u30

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
			for each (var instance:InstanceInfo in instanceInfo) {
				writeU30(pool.addMultiname(instance.classMultiname));
				writeU30(pool.addMultiname(instance.superclassMultiname));

				// Flip the appropriate bit flags for the various instance flags if applicable
				var flags:int = 0;
				flags = (flags | ((instance.isFinal) ? ClassConstant.FINAL.bitMask : 0));
				flags = (flags | ((instance.isInterface) ? ClassConstant.INTERFACE.bitMask : 0));
				flags = (flags | ((instance.isProtected) ? ClassConstant.PROTECTED_NAMESPACE.bitMask : 0));
				flags = (flags | ((instance.isSealed) ? ClassConstant.SEALED.bitMask : 0));
				writeU8(flags);

				if (instance.isProtected) {
					writeU30(pool.addNamespace(instance.protectedNamespace));
				}

				writeU30(instance.interfaceCount);
				for each (var interfaceEntry:BaseMultiname in instance.interfaceMultinames) {
					writeU30(pool.addMultiname(interfaceEntry));
				}

				writeU30(abcFile.addMethodInfo(instance.instanceInitializer));
				serializeTraits(instance.traits, abcFile);
			}

			// class_info  
			// { 
			//  u30 cinit 
			//  u30 trait_count 
			//  traits_info traits[trait_count] 
			// }
			for each (var classEntry:ClassInfo in classInfo) {
				writeU30(abcFile.addMethodInfo(classEntry.staticInitializer));
				serializeTraits(classEntry.traits, abcFile);
			}
		}

		public function serializeMetadataInfo(abcFile:AbcFile):void {
			var metadataInfo:Array = abcFile.metadataInfo;
			var pool:ConstantPool = abcFile.constantPool;

			writeU30(metadataInfo.length);
			for each (var metadataEntry:Metadata in metadataInfo) {
				writeU30(pool.addString(metadataEntry.name));

				// There's no way to get the number of entries in a Dictionary, so we copy to an Array first... weak
				var properties:Dictionary = metadataEntry.properties;
				var keys:Array = [];
				for (var keyValue:String in properties) {
					keys[keys.length] = keyValue;
				}

				writeU30(keys.length);
				for each (var key:String in keys) {
					writeU30(pool.addString(key));
				}
				for each (var value:String in properties) {
					writeU30(pool.addString(value));
				}
			}
		}

		public function serializeMethodInfo(abcFile:AbcFile):void {
			Assert.notNull(abcFile, "abcFile argument must not be null");
			// u30 method_count
			// method_info method[method_count]
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
			var pool:ConstantPool = abcFile.constantPool;
			var methodInfoArray:Array = abcFile.methodInfo;

			writeU30(methodInfoArray.length); // u30 method_count
			for each (var methodInfo:MethodInfo in methodInfoArray) {
				writeU30(methodInfo.argumentCollection.length); // u30 param_count
				writeU30(pool.addMultiname(methodInfo.returnType)); // u30 return_type
				for each (var param:Argument in methodInfo.argumentCollection) {
					writeU30(pool.addMultiname(param.type)); // u30 param_type[param_count] 
				}

				writeU30(pool.addString(methodInfo.methodName));

				//  NEED_ARGUMENTS 0x01 Suggests to the run-time that an “arguments” object (as specified by the
				//                 ActionScript 3.0 Language Reference) be created. Must not be used together with
				//                 NEED_REST. See Chapter 3. 
				//  NEED_ACTIVATION 0x02 Must be set if this method uses the newactivation opcode. 
				//  NEED_REST 0x04  This flag creates an ActionScript 3.0 rest arguments array.  Must not be used
				//                  with NEED_ARGUMENTS. See Chapter 3. 
				//  HAS_OPTIONAL    0x08 Must be set if this method has optional parameters and the options field
				//                  is present in this method_info structure. 
				//  SET_DXNS        0x40 Must be set if this method uses the dxns or dxnslate opcodes. 
				//  HAS_PARAM_NAMES 0x80 Must be set when the param_names field is present in this method_info structure.
				writeU8(methodInfo.flags); // u8 flags

				// option_info options 
				// option_info  
				// { 
				//  u30 option_count 
				//  option_detail option[option_count] 
				// }
				// This entry is only made if MethodFlag.HAS_OPTIONAL is present 
				if (MethodFlag.flagPresent(methodInfo.flags, MethodFlag.HAS_OPTIONAL)) {
					var optionalParams:Array = methodInfo.optionalParameters;
					writeU30(optionalParams.length); // u30 option_count
					for each (var optionalArgument:Argument in optionalParams) {
						var defaultValue:* = optionalArgument.defaultValue;
						var positionInPool:int;
						switch (optionalArgument.kind) {
							case ConstantKind.INT:
								positionInPool = pool.addInt(defaultValue as int);
								break;

							case ConstantKind.UINT:
								positionInPool = pool.addUint(defaultValue as uint);
								break;

							case ConstantKind.DOUBLE:
								positionInPool = pool.addDouble(defaultValue as Number);
								break;

							case ConstantKind.UTF8:
								positionInPool = pool.addString(defaultValue as String);
								break;

							case ConstantKind.TRUE:
							case ConstantKind.FALSE:
							case ConstantKind.NULL:
							case ConstantKind.UNDEFINED:
								// When the value is one of these constants, the position with the pool entry
								// just contains the type kind value again
								positionInPool = optionalArgument.kind.value;
								break;

							case ConstantKind.NAMESPACE:
							case ConstantKind.PACKAGE_NAMESPACE:
							case ConstantKind.PACKAGE_INTERNAL_NAMESPACE:
							case ConstantKind.PROTECTED_NAMESPACE:
							case ConstantKind.EXPLICIT_NAMESPACE:
							case ConstantKind.STATIC_PROTECTED_NAMESPACE:
							case ConstantKind.PRIVATE_NAMESPACE:
								positionInPool = pool.addNamespace(defaultValue as LNamespace);
								break;

							default:
								throw new Error(__UNABLE_TO_DETERMINE_POOL_POSITION_ERROR + " " + optionalArgument.kind);
								break;
						}
						// option_detail 
						// { 
						//  u30 val 
						//  u8  kind 
						// }
						writeU30(positionInPool); // u30 val
						writeU30(optionalArgument.kind.value); // u30 val
					}
				}

				//  param_info param_names
				// This entry is only made if MethodFlag.HAS_PARAM_NAMES is present 
				if (MethodFlag.flagPresent(methodInfo.flags, MethodFlag.HAS_PARAM_NAMES)) {
					for each (var arg:Argument in methodInfo.argumentCollection) {
						writeU30(pool.addString(arg.name));
					}
				}
			}
		}

		private function writeU8(value:int):void {
			AbcSpec.writeU8(value, _outputStream);
		}

		private function writeU16(value:int):void {
			AbcSpec.writeU16(value, _outputStream);
		}

		private function writeU30(value:int):void {
			//NOTE: Uncomment the try/catch to find the cause of out of range errors. Usually, it's a missing multiname or similar in the constant pool
//			try
//			{
			AbcSpec.writeU30(value, _outputStream);
//			}
//			catch (e : Error)
//			{
//				throw e;
//			}
		}

		public function serialize(classDefinition:ClassDefinition):ByteArray {
			_pool = new ConstantPool();

			// abcFile  
			// { 
			//  u16 minor_version 
			//  u16 major_version 
			//  cpool_info constant_pool 
			//  u30 method_count 
			//  method_info method[method_count] 
			//  u30 metadata_count 
			//  metadata_info metadata[metadata_count] 
			//  u30 class_count 
			//  instance_info instance[class_count] 
			//  class_info class[class_count] 
			//  u30 script_count 
			//  script_info script[script_count] 
			//  u30 method_body_count 
			//  method_body_info method_body[method_body_count] 
			// }
			var methodInfoBuffer:ByteArray = serializeMethods(classDefinition);

			// ========================
			// FLUSH TO BYTECODE BUFFER
			// ========================
			var bytecodeBuffer:ByteArray = createBuffer();
			AbcSpec.writeU16(MINOR_VERSION, bytecodeBuffer);
			AbcSpec.writeU16(MAJOR_VERSION, bytecodeBuffer);
			serializeConstantPool(_pool, bytecodeBuffer);

			bytecodeBuffer.writeBytes(methodInfoBuffer);
			bytecodeBuffer.position = 0;
			return bytecodeBuffer;
		}

		/**
		 * Flushes the Constant Pool to the output stream. This should be the last possible thing that
		 * can happen since all the constants have to be added to the pool before it hits the bytecode
		 * (after all, all the bytecode references the pool).
		 */
		public function serializeConstantPool(pool:ConstantPool, outputStream:ByteArray):void {
			//NOTE: Contrary to the spec, the number of entries in each numeric pool seems to be
			// either (a) the number of entries + 1 if entries are present, or (b) 0 if no entries
			// are present

			// Integers
			var integers:Array = pool.integerPool.slice(1, pool.integerPool.length);
			if (integers.length != 0) {
				AbcSpec.writeU30(integers.length + 1, outputStream);
				for each (var integer:int in integers) {
					AbcSpec.writeU32(integer, outputStream);
				}
			} else {
				AbcSpec.writeU30(0, outputStream);
			}

			// uints
			var uints:Array = pool.uintPool.slice(1, pool.uintPool.length);
			if (uints.length != 0) {
				AbcSpec.writeU30(uints.length + 1, outputStream);
				for each (var uinteger:int in uints) {
					AbcSpec.writeU32(uinteger, outputStream);
				}
			} else {
				AbcSpec.writeU30(0, outputStream);
			}

			// doubles
			var doubles:Array = pool.doublePool.slice(1, pool.doublePool.length);
			if (doubles.length != 0) {
				AbcSpec.writeU30(doubles.length + 1, outputStream);
				for each (var double:Number in doubles) {
					AbcSpec.writeD64(double, outputStream);
				}
			} else {
				AbcSpec.writeU30(0, outputStream);
			}

			// strings
			var strings:Array = pool.stringPool.slice(1, pool.stringPool.length);
			AbcSpec.writeU30((strings.length + 1), outputStream);
			for each (var string:String in strings) {
				AbcSpec.writeStringInfo(string, outputStream);
			}

			// namespaces
			var namespaces:Array = pool.namespacePool.slice(1, pool.namespacePool.length);
			AbcSpec.writeU30((namespaces.length + 1), outputStream);
			for each (var namespaceInstance:LNamespace in namespaces) {
				AbcSpec.writeU8(namespaceInstance.kind.byteValue, outputStream);
				AbcSpec.writeU30(pool.addString(namespaceInstance.name), outputStream);
			}

			// namespace sets
			var namespaceSets:Array = pool.namespaceSetPool.slice(1, pool.namespaceSetPool.length);
			AbcSpec.writeU30((namespaceSets.length + 1), outputStream);
			for each (var namespaceSet:NamespaceSet in namespaceSets) { // ns_set_info
				AbcSpec.writeU30(namespaceSet.namespaces.length, outputStream); // u30 count
				for each (var nameSpace:LNamespace in namespaceSet.namespaces) {
					AbcSpec.writeU30(pool.addNamespace(nameSpace), outputStream); // u30 ns[count]
				}
			}

			// multinames
			// multiname_kind_QName 
			// { 
			//  u30 ns - namespace pool
			//  u30 name - string pool
			// } 
			// multiname_kind_RTQName 
			// { 
			//  u30 name - string pool 
			// }
			// multiname_kind_Multiname 
			// { 
			//  u30 name - string pool
			//  u30 ns_set - nsset pool
			// }
			// multiname_kind_MultinameL 
			// { 
			//  u30 ns_set - nsset pool 
			// }
			var multinames:Array = pool.multinamePool.slice(1, pool.multinamePool.length);
			AbcSpec.writeU30((multinames.length + 1), outputStream);
			for each (var multiname:BaseMultiname in multinames) {
				// multiname_info 
				// { 
				// u8   kind 
				// u8   data[] (defined in the switch statements below) 
				// }
				AbcSpec.writeU8(multiname.kind.byteValue, outputStream);
				switch (multiname.kind) {
					case MultinameKind.QNAME:
					case MultinameKind.QNAME_A:
						// multiname_kind_QName 
						// { 
						//  u30 ns 
						//  u30 name 
						// }
						var qualifiedName:QualifiedName = multiname as QualifiedName;
						AbcSpec.writeU30(pool.addNamespace(qualifiedName.nameSpace), outputStream);
						AbcSpec.writeU30(pool.addString(qualifiedName.name), outputStream);
						break;

					case MultinameKind.MULTINAME:
					case MultinameKind.MULTINAME_A:
						// multiname_kind_Multiname 
						// { 
						//  u30 name 
						//  u30 ns_set 
						// }
						var multinamespaceName:Multiname = multiname as Multiname;
						AbcSpec.writeU30(pool.addString(multinamespaceName.name), outputStream);
						AbcSpec.writeU30(pool.addNamespaceSet(multinamespaceName.namespaceSet), outputStream);
						break;

					case MultinameKind.MULTINAME_L:
					case MultinameKind.MULTINAME_LA:
						// multiname_kind_MultinameL 
						// { 
						//  u30 ns_set 
						// }
						var multinamespaceNameLate:MultinameL = multiname as MultinameL;
						AbcSpec.writeU30(pool.addNamespaceSet(multinamespaceNameLate.namespaceSet), outputStream);
						break;

					case MultinameKind.RTQNAME:
					case MultinameKind.RTQNAME_A:
						// multiname_kind_RTQName 
						// { 
						//  u30 name 
						// }
						var runtimeQualifiedName:RuntimeQualifiedName = multiname as RuntimeQualifiedName;
						AbcSpec.writeU30(pool.addString(runtimeQualifiedName.name), outputStream);
						break;

					case MultinameKind.RTQNAME_L:
					case MultinameKind.RTQNAME_LA:
						// multiname_kind_RTQNameL 
						// { 
						// }
						break;
					case MultinameKind.GENERIC:
						var generic:MultinameG = multiname as MultinameG;
						AbcSpec.writeU30(pool.addMultiname(generic.qualifiedName), outputStream);
						var paramCount:uint = generic.parameters.length;
						AbcSpec.writeU30(paramCount, outputStream);
						for (var idx:uint = 0; idx < paramCount; ++idx) {
							AbcSpec.writeU30(pool.addMultiname(BaseMultiname(generic.parameters[idx])), outputStream);
						}
						break;

				}
			}
		}

		private function createBuffer():ByteArray {
			return AbcSpec.byteArray();
		}

		public function serializeMethods(classDefinition:ClassDefinition):ByteArray {
			var buffer:ByteArray = createBuffer();
			AbcSpec.writeU30(classDefinition.instanceMethods.length, buffer);

			// Methods
			for each (var method:Method in classDefinition.instanceMethods) {
				//  trace("~~~" + method.methodName + "(" + method.arguments.length + ") flags=" + method.flags);
				AbcSpec.writeU30(method.methodArguments.length, buffer); // u30 param_count
				AbcSpec.writeU30(_pool.addMultiname(method.returnType), buffer); // u30 return_type
				//TODO: If the owning classdef is an interface, then no method bodies are allowed
				for each (var argument:Argument in method.methodArguments) {
					AbcSpec.writeU30(_pool.addMultiname(argument.type), buffer); // u30 param_type[param_count]
				}
				AbcSpec.writeU30(_pool.addString(method.methodName.name), buffer); // u30 name

				var flags:uint = 0;
				if ((method.methodArguments.length > 0) && (method.hasRestArguments == false)) {
					flags |= MethodFlag.NEED_ARGUMENTS.value;
				}
				if ((method.methodArguments.length < 1) && (method.hasRestArguments == true)) {
					flags |= MethodFlag.NEED_REST.value;
				}
				if (method.hasOpcode(Opcode.newactivation)) {
					flags |= MethodFlag.NEED_ACTIVATION.value;
				}
				if ((method.hasOpcode(Opcode.dxns) || (method.hasOpcode(Opcode.dxnslate)))) {
					flags |= MethodFlag.SET_DXNS.value;
				}

				var numberOfOptionalArguments:uint = 0;
				for each (var arg:Argument in method.methodArguments) {
					if (arg.isOptional) {
						numberOfOptionalArguments++;
					}
				}
				if (numberOfOptionalArguments > 0) {
					flags |= MethodFlag.HAS_OPTIONAL.value;
				}

				for each (arg in method.methodArguments) {
					if (StringUtils.hasText(arg.name)) {
						flags |= MethodFlag.HAS_PARAM_NAMES.value;
						break;
					}
				}

				AbcSpec.writeU8(flags, buffer);

				if (numberOfOptionalArguments > 0) {
					AbcSpec.writeU30(numberOfOptionalArguments, buffer);
					var argLen:int = method.methodArguments.length;
					for (var i:int = (method.methodArguments.length - numberOfOptionalArguments); i < argLen; ++i) {
						arg = method.methodArguments[i];
						var defaultValueIndex:int = 0;
						defaultValueIndex = _pool.addItemToPool(arg.kind, arg.defaultValue);
						AbcSpec.writeU30(defaultValueIndex, buffer);
						AbcSpec.writeU8(arg.kind.value, buffer);
					}
				}

				if (MethodFlag.flagPresent(flags, MethodFlag.HAS_PARAM_NAMES)) {
					for each (arg in method.methodArguments) {
						AbcSpec.writeU30(_pool.addString(arg.name), buffer);
					}
				}

			}

			return buffer;
		}

		public function toString():String {
			return StringUtils.substitute("Integer Pool: {0}\n" + "Uint Pool: {1}\n" + "Double Pool: {2}\n" + "String Pool: {3}", _pool.integerPool.join(), _pool.uintPool.join(), _pool.doublePool.join(), _pool.stringPool.join());
		}
	}
}