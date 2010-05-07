package org.as3commons.emit.bytecode
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IDataOutput;
	
	import org.as3commons.emit.reflect.EmitAccessor;
	import org.as3commons.emit.reflect.EmitMethod;
	import org.as3commons.emit.reflect.EmitParameter;
	import org.as3commons.emit.reflect.EmitType;
	import org.as3commons.emit.reflect.EmitTypeUtils;
	import org.as3commons.emit.reflect.EmitVariable;
	import org.as3commons.lang.IEquals;
	
	public class ByteCodeLayout implements IByteCodeLayout
	{
		private var _readOnly : Boolean	= false;
		
		private var _integers : Array;
		private var _uintegers : Array;
		private var _doubles : Array;
		private var _strings : Array;
		private var _namespaces : Array;
		private var _namespaceSets : Array;
		private var _multinames : Array;
		private var _methods : Array;
		private var _metadata : Array;
		private var _types : Array;
		private var _methodBodies : Array;
		
		private var _methodBodiesBuffer : ByteArray;
		private var _methodBodiesWriter : IByteCodeWriter;
		
		private var _majorVersion : uint = 46;
		private var _minorVersion : uint = 16;
		
		public function ByteCodeLayout()
		{
			_integers = [0];
			_uintegers = [0];
			_doubles = [0];
			_strings = ['*'];
			_namespaces = [];
			_namespaceSets = new Array();
			_multinames = new Array();
			_methods = new Array();
			_metadata = new Array();
			
			_types = new Array();
			_methodBodies = new Array();
			
			_methodBodiesBuffer = new ByteArray();
			_methodBodiesWriter = new ByteCodeWriter(_methodBodiesBuffer);
			
			registerNamespaceSet(new NamespaceSet([EmitTypeUtils.UNTYPED.qname.ns]));
			registerMultiname(EmitTypeUtils.UNTYPED.qname);
		}
		
		public function write(output : IDataOutput) : void
		{
  			_readOnly = true;
			
			//try
			{
				var writer : IByteCodeWriter = new ByteCodeWriter(output);
				
				// Version
				writer.writeU16(_minorVersion);
				writer.writeU16(_majorVersion);
				
				writeConstantPool(writer);
				
				writeMethods(writer);
				
				writeMetadata(writer);
				
				writeClasses(writer);
				
				writeMethodBodies(writer);
			}
			//finally
			{
				_readOnly = false;
			}
		}
		
		private function writeConstantPool(output : IByteCodeWriter) : void
		{
			writeArray(_integers, output, output.writeS32, 1);
			writeArray(_uintegers, output, output.writeU32, 1);
			writeArray(_doubles, output, output.writeD64, 1);
			writeArray(_strings, output, output.writeString, 1);
			
			writeIndexedArray(_namespaces, output, function(ns : Array) : void
			{
				output.writeU8(ns[0]);
				output.writeU30(ns[1]);
			}, 1);
			
			writeIndexedArray(_namespaceSets, output, function(namespaceSet : Array) : void
			{
				output.writeU30(namespaceSet.length);
				for each(var index : uint in namespaceSet)
					output.writeU30(index);
			}, 1);
			
			writeIndexedArray(_multinames, output, function(multiname : Array) : void
			{
				output.writeU8(multiname[0]);
				
				for (var i:uint=1; i<multiname.length; i++)
					output.writeU30(multiname[i]);
			}, 1);
		}
		
		private function writeArray(array : Array, output : IByteCodeWriter, writeFunc : Function, startIndex : int = 0) : void
		{
			output.writeU30(array.length);
			
			for (var i:int = startIndex; i<array.length; i++)	
			{
				writeFunc(array[i]);
			}
		}
		
		private function writeIndexedArray(array : Array, output : IByteCodeWriter, writeFunc : Function, startIndex : int = 0) : void
		{
			output.writeU30(array.length);
			
			for (var i:int = startIndex; i<array.length; i++)	
			{
				writeFunc(array[i].Data);
			}
		}
		
		private function writeNamespace(ns : NamespaceInfo, output : IByteCodeWriter) : void 
		{
			output.writeU8(ns.kind);
			output.writeU30(ns.name);
		}
		
		private function writeNamespaceSet(namespaceSet : Array, output : IByteCodeWriter) : void 
		{
			output.writeU30(namespaceSet.length);
			
			for each(var index : uint in namespaceSet)
			{
				output.writeU30(index);
			}
		}
		
		private function writeMethods(output : IByteCodeWriter) : void
		{
			var param : EmitParameter = null;
			
			output.writeU30(_methods.length);
			
			for each(var method : EmitMethod in _methods)
			{
				var params : Array = new Array().concat(method.parameters);
				
				var needsRest : Boolean = this.needsRest(method);
				
				if (needsRest)
				{
					params.pop();
				}
				
				output.writeU30(params.length);
				
				output.writeU30(registerMultiname(EmitType(method.returnType).multiname));
				
				var optionalArgsCount : uint = 0;
				
				var paramCount : int = params.length;
				
				for (var i:uint=0; i<paramCount; i++)
				{
					param = method.parameters[i];
					
					if (param.isOptional)
					{
						optionalArgsCount++;
					}
					
					output.writeU30(registerMultiname(EmitType(param.type).multiname));
				}
				
				output.writeU30(registerString(method.fullName));
				
				// TODO: Only specify NEED_ARGUMENTS if the method needs it... ?
				var flags : uint = MethodFlags.HAS_PARAM_NAMES
				
				if (needsRest)
				{
					flags |= MethodFlags.NEED_REST;
					params.pop();
				}
				else
				{
					flags |= MethodFlags.NEED_ARGUMENTS;
				}

				if (optionalArgsCount > 0)
					flags |= MethodFlags.HAS_OPTIONAL; 
				
				output.writeU8(flags);
				
				if (optionalArgsCount > 0)
				{
					output.writeU30(optionalArgsCount);
					
					for (var p:int=optionalArgsCount; p>0; p--)
					{
						// TODO: Determine optional value?
						
						output.writeU30(0);
						output.writeU8(0x0C); // Undefined
					}
				}
				
				for each(param in params)
				{
					output.writeU30(registerString(param.name));
				}
			}
		}
		
		private function needsRest(method : EmitMethod) : Boolean
		{
			for each(var param : EmitParameter in method.parameters)
			{
				if (param.type == EmitTypeUtils.REST)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function writeMetadata(output : IByteCodeWriter) : void
		{
			output.writeU30(0);
		}
		
		private function writeClasses(output : IByteCodeWriter) : void
		{
			output.writeU30(_types.length);
			
			var type : EmitType;
			
			var method : EmitMethod;
			
			for each(type in _types)
			{
				output.writeU30(registerMultiname(type.multiname));
				
				if (type.superClassType == null || type.superClassType.fullName == "Object")
				{
					// No base type - 4.3 Instance / super_name
					output.writeU30(0);
				}
				else
				{
					output.writeU30(registerMultiname(type.superClassType.multiname));
				}
				
				var flags : uint = getClassFlags(type);
				
				var hasProtectedNs : Boolean = ((flags & ClassFlags.PROTECTED_NAMESPACE) != 0)
				
				output.writeU8(flags);
				
				if (hasProtectedNs)
				{
					output.writeU30(registerNamespace(type.typeNamespace));
				}
				 
				var interfaces : Array = type.interfaces;
				output.writeU30(interfaces.length);
				
				for each(var interfaceType : EmitType in interfaces)
				{
					output.writeU30(registerMultiname(interfaceType.multiNamespaceName));
				}
				
				// iinit
				output.writeU30(registerMethod(type.constructorMethod));
				
				// trait count
				output.writeU30(getTraitCount(type, false));
				/* output.writeU30(
					type.getMethods(false, true).length +
					(2 * type.getProperties(false, true).length) +
					type.getFields(false, true).length					
				); */
				
				var attributes : int = 0;
				
				for each(method in type.getMethods(false, true))
				{
					output.writeU30(registerMultiname(method.qname));
					
					// TODO: Support override
					
					output.writeU8(TraitKind.METHOD | (getMethodTraitAttributes(method) << 4)); // kind
					
					output.writeU30(0); // disp_id (optimisation disabled)
					output.writeU30(registerMethod(method));
					
					// Only include metadata count/data if METADATA attribute is present
					//output.writeU30(0); // metadata count
				}
				
				for each(var property : EmitAccessor in type.getProperties(false, true))
				{
					if (property.readable)
					{
						// Getter
						output.writeU30(registerMultiname(property.qname));
						output.writeU8(TraitKind.GETTER | (getMethodTraitAttributes(property.getMethod) << 4)); // kind
						output.writeU30(0); // disp_id (optimisation disabled)
						output.writeU30(registerMethod(property.getMethod));
						//output.writeU30(0); // metadata count
					}
					
					if (property.writeable)
					{
						// Setter
						output.writeU30(registerMultiname(property.qname));
						output.writeU8(TraitKind.SETTER | (getMethodTraitAttributes(property.setMethod) << 4)); // kind
						output.writeU30(0); // disp_id (optimisation disabled)
						output.writeU30(registerMethod(property.setMethod));
						//output.writeU30(0); // metadata count
					}
				}
				
				for each(var field : EmitVariable in type.getFields(false, true))
				{
					// Getter 
					output.writeU30(registerMultiname(field.qname));
					output.writeU8(TraitKind.SLOT); // kind
					output.writeU30(0); // slot_id (avm selected)
					output.writeU30(registerMultiname(EmitType(field.type).multiname)); // type_name
					output.writeU30(0); // no initial value
					// vkind skipped
				}
			}
			
			for each(type in _types)
			{
				output.writeU30(registerMethod(type.staticInitializer));
				
				var staticTraitCount : int = type.getMethods(true, false).length;
				
				// TODO: Support static properties/fields
				output.writeU30(staticTraitCount);
				
				for each(method in type.getMethods(true, false))
				{
					output.writeU30(registerMultiname(method.qname));
					
					// TODO: Support override
					
					output.writeU8(TraitKind.METHOD | (getMethodTraitAttributes(method) << 4)); // kind
					
					output.writeU30(0); // disp_id (optimisation disabled)
					output.writeU30(registerMethod(method));
					
					// Only include metadata count/data if METADATA attribute is present
					//output.writeU30(0); // metadata count
				}
			}
			
			// Scripts
			output.writeU30(_types.length);
			
			for each(type in _types)
			{
				output.writeU30(registerMethod(type.scriptInitializer));
				output.writeU30(1); // trait_count
				
				output.writeU30(registerMultiname(type.qname));
				output.writeU8(TraitKind.CLASS);
				output.writeU30(0); // slot_id, avm assigned
				output.writeU30(registerClass(type));
			}
		}
		
		private function getClassFlags(type : EmitType) : uint
		{
			var flags : uint = 0;
			
			if (type.typeNamespace.kind == NamespaceKind.PROTECTED_NAMESPACE)
			{
				flags |= ClassFlags.PROTECTED_NAMESPACE; 
			}
			
			if (type.isInterface)
			{
				flags |= ClassFlags.INTERFACE;
			}
			
			if (type.isFinal)
			{
				flags |= ClassFlags.FINAL;
			}
			
			if (!type.isDynamic)
			{
				flags |= ClassFlags.SEALED;
			}
			
			return flags;
		}
		
		private function getTraitCount(type : EmitType, staticMembers : Boolean) : uint 
		{
			var traitCount : uint = 0;
			
			traitCount += type.getFields(staticMembers, !staticMembers).length;
			traitCount += type.getMethods(staticMembers, !staticMembers).length;
			
			for each(var property : EmitAccessor in type.getProperties(staticMembers, !staticMembers))
			{
				if (property.readable)
				{
					traitCount++;
				}
				
				if (property.writeable)
				{
					traitCount++;
				}
			}
			
			return traitCount;
		}
		
		private function getMethodTraitAttributes(method : EmitMethod) : int
		{
			var attributes : int = 0;
			
			if (method.isOverride)
			{
				attributes |= TraitAttribute.OVERRIDE;
			}
			
			return attributes;
		}
		
		private function writeMethodBodies(output : IByteCodeWriter) : void
		{
			output.writeU30(_methodBodies.length);
			
			_methodBodiesBuffer.position = 0;
			output.writeBytes(_methodBodiesBuffer);
		}
		
		public function registerInteger(value : int) : uint
		{
			return assertArrayIndex(_integers, value);
		}
		
		public function registerUInteger(value : uint) : uint
		{
			return assertArrayIndex(_uintegers, value);
		}
		
		public function registerDouble(value : Number) : uint
		{
			return assertArrayIndex(_doubles, value)
		}
		
		public function registerString(value : String) : uint
		{
			return assertArrayIndex(_strings, value)
		}
		
		public function registerClass(value : EmitType) : uint
		{
			var index : uint = assertArrayIndex(_types, value);
			
			registerTypeMultiname(value);
			registerMultiname(value.multiNamespaceName);
			registerNamespace(value.typeNamespace);
			
			/* if (value.qname.ns.kind != NamespaceKind.PACKAGE_NAMESPACE)
			{
				registerNamespace(_protectedNamespace);
			} */
			
			registerMethod(value.scriptInitializer);
			registerMethod(value.staticInitializer);
			registerMethod(value.constructorMethod);
			
			for each(var method : EmitMethod in value.methods)
			{
				registerMethod(method);
			}
			
			for each(var property : EmitAccessor in value.properties)
			{
				registerString(property.fullName);
				registerMultiname(property.qname);
				
				if (property.readable)
				{
					registerMethod(property.getMethod);
				}
				
				if (property.writeable)
				{
					registerMethod(property.setMethod);
				}
			}
			
			for each(var field : EmitVariable in value.fields)
			{
				registerTypeMultiname(field.type as EmitType);
			}
			
			return index;
		}
		
		public function registerMethod(value : EmitMethod) : uint
		{
			registerString(value.name);
			registerString(value.fullName);
			registerMultiname(value.qname);
			registerTypeMultiname(value.returnType as EmitType);
			
			for each(var param : EmitParameter in value.parameters)
			{
				registerTypeMultiname(param.type as EmitType);
				registerString(param.name);
			}
			
			return assertArrayIndex(_methods, value);
		}
		
		private function registerTypeMultiname(type : EmitType) : void
		{
			if (type.isGeneric)
			{
				registerMultiname(type.genericTypeDefinition.multiname);
			}
			
			registerMultiname(type.multiname);
		}
		
		public function registerMethodBody(method : EmitMethod, value : DynamicMethod) : uint
		{
			var index : int = _methodBodies.indexOf(value);
			
			if (index == -1)
			{
				index = _methodBodies.push(value);
			
				_methodBodiesWriter.writeU30(registerMethod(method));
				
				_methodBodiesWriter.writeU30(value.maxStack);
				_methodBodiesWriter.writeU30(value.maxLocal);
				_methodBodiesWriter.writeU30(value.minScope);
				_methodBodiesWriter.writeU30(value.maxScope);
				
				var instruction : Array = null;
				
				var instructionBuffer : ByteArray = new ByteArray();
				var instructionWriter : IByteCodeWriter = new ByteCodeWriter(instructionBuffer);
				
				for each(instruction in value.instructionSet)
				{
					instructionWriter.writeU8(instruction[0]);
					
					var paramTypesObj : Object = _instructionParamTypes[instruction[0]];
					
					if (paramTypesObj is Function)
					{
						Function(paramTypesObj)(instruction, instructionWriter);
					}
					else if (paramTypesObj is Array)
					{
						var paramTypes : Array = paramTypesObj as Array;
					
						for (var i:uint=0; i<paramTypes.length; i++)
						{
							var paramType : uint = paramTypes[i];
							var paramVal : Object = instruction[i + 1];
							
							switch(paramType)
							{
								case InstructionArgumentType.Integer:
									instructionWriter.writeU30(registerInteger(paramVal as int));
									break;
								case InstructionArgumentType.UInteger:
									instructionWriter.writeU30(registerUInteger(paramVal as uint));
									break;
								case InstructionArgumentType.Double:
									instructionWriter.writeU30(registerDouble(paramVal as Number));
									break;
								case InstructionArgumentType.String:
									instructionWriter.writeU30(registerString(paramVal as String));
									break;
								case InstructionArgumentType.Class:
									instructionWriter.writeU30(registerClass(EmitType(paramVal)));
									break;
								case InstructionArgumentType.Method:
									instructionWriter.writeU30(registerMethod(EmitMethod(paramVal)));
									break;
								case InstructionArgumentType.Multiname:
									instructionWriter.writeU30(registerMultiname(AbstractMultiname(paramVal)));
									break;
								case InstructionArgumentType.U8:
									instructionWriter.writeU8(paramVal as uint);
									break;
								case InstructionArgumentType.U30:
									instructionWriter.writeU30(paramVal as uint);
									break;
								case InstructionArgumentType.S24:
									instructionWriter.writeS24(paramVal as int);
									break;
								default:
									throw new IllegalOperationError("Unsupported argument type: " + paramType);
							}
						}
					}
				}
				
				instructionBuffer.position = 0;
				
				var codeLength : uint = instructionBuffer.bytesAvailable;
				
				_methodBodiesWriter.writeU30(codeLength);
				_methodBodiesWriter.writeBytes(instructionBuffer, 0, codeLength);
				
				// TODO: Support exceptions
				_methodBodiesWriter.writeU30(0);
				
				// TODO: Supports trait (presumably inline functions?)
				_methodBodiesWriter.writeU30(0);				
			}
			
			return index;
		}
		
		public function registerMultiname(value : AbstractMultiname) : uint
		{
			return assertEqArrayIndex(_multinames, value, function():Array
			{
				switch(value.kind)
				{
					case MultinameKind.QUALIFIED_NAME:
					case MultinameKind.QUALIFIED_NAME_ATTRIBUTE:
						var qname : QualifiedName = value as QualifiedName;
						return [value.kind,
								registerNamespace(qname.ns),								 
								registerString(qname.name)];
						
					case MultinameKind.MULTINAME:
					case MultinameKind.MULTINAME_ATTRIBUTE:
						var mname : MultipleNamespaceName = value as MultipleNamespaceName;
						return [value.kind, 
								registerString(mname.name),
								registerNamespaceSet(mname.namespaceSet)];
								
					case MultinameKind.MULTINAME_LATE:
					case MultinameKind.MULTINAME_LATE_ATTRIBUTE:
						var mnamel : MultipleNamespaceNameLate = value as MultipleNamespaceNameLate;
						return [value.kind, registerNamespaceSet(mnamel.namespaceSet)];
						
					case MultinameKind.RUNTIME_QUALIFIED_NAME:
					case MultinameKind.RUNTIME_QUALIFIED_NAME_ATTRIBUTE:
						var rtqname : RuntimeQualifiedName = value as RuntimeQualifiedName;
						return [value.kind, registerString(rtqname.name)];
						
				 	case MultinameKind.RUNTIME_QUALIFIED_NAME_LATE:
					case MultinameKind.RUNTIME_QUALIFIED_NAME_LATE_ATTRIBUTE:
						return [value.kind];
					
					case MultinameKind.GENERIC:
						var gen : GenericName = value as GenericName;
						var arr : Array = [value.kind, registerMultiname(gen.typeDefinition), gen.genericParameters.length];
						//arr = arr.concat(gen.genericParameters);
						
						for each(var mn : AbstractMultiname in gen.genericParameters)
						{
							arr.push(registerMultiname(mn));
						}
						
						return arr;
						
					default:
						throw new IllegalOperationError("Invalid multiname kind");
				}
			});
		}
		
		public function registerNamespace(value : BCNamespace) : uint
		{
			return assertEqArrayIndex(_namespaces, value, function():Array
			{
				return [
					value.kind,
					registerString(value.name)
				];
			});
		}
		
		public function registerNamespaceSet(value : NamespaceSet) : uint
		{
			return assertEqArrayIndex(_namespaceSets, value, function():Array
			{
				var indexValues : Array = new Array();
				
				for each(var ns : BCNamespace in value.namespaces)
				{
					indexValues.push(registerNamespace(ns));
				}
				
				return indexValues;
			});
		}
		
		private function assertEqArrayIndex(array : Array, value : IEquals, dataCallback : Function) : uint
		{
			for (var i:uint =0; i<array.length; i++)
			{
				if (value.equals(array[i].Object))
					return i;
			}
			
			if (_readOnly)
			{
				throw new IllegalOperationError("Cannot register a new item when the instance is readonly");
			}
			
			var indexedObj : IndexedObject = new IndexedObject();
			indexedObj.Object = value;
			indexedObj.Data = dataCallback();
			
			return array.push(indexedObj) - 1;
		}
		
		private function assertArrayIndex(array : Array, value : Object) : uint
		{
			var index : int = array.indexOf(value);
			
			if (index == -1)
			{
				if (_readOnly)
				{
					throw new IllegalOperationError("Cannot register a new item when the instance is readonly");
				}
				
				index = array.push(value) - 1;
			}
			
			return index;
		}
		
		private static function notSupportedInstructionHandler(instruction : Array, writer : IByteCodeWriter) : void
		{
			var instructionName : String = Instructions[instruction[0]];
			
			throw new IllegalOperationError("Operation (" + instructionName + ") not supported");
		}
		
		private static var _instructionParamTypes : Dictionary = getInstructionParamTypes();
		
		private static function getInstructionParamTypes() : Dictionary
		{
			var dict : Dictionary = new Dictionary();
			
			InstructionArgumentType.Class;
			
			var multiname : uint = InstructionArgumentType.Multiname;
			
			with(Instructions)
			{
				with(InstructionArgumentType)
				{
					dict[AsType] = [multiname];
					dict[Call] = [U30];
					dict[CallMethod] = [Method, U30];
					dict[CallProperty] = [multiname, U30];
					dict[CallPropLex] = [multiname, U30];
					dict[CallPropVoid] = [multiname, U30];
					dict[CallStatic] = [Method, U30];
					dict[CallSuper] = [multiname, U30];
					dict[CallSuperVoid] = [multiname, U30];
					dict[Coerce] = [multiname];
					dict[Construct] = [U30];
					dict[ConstructProp] = [multiname, U30];
					dict[ConstructSuper] = [U30];
					dict[Debug] = [U8, String, U8, U30];
					dict[DebugFile] = [String];
					dict[DebugLine] = [U30];
					dict[DecrementLocal] = [U30];
					dict[DecrementLocalInteger] = [U30];
					dict[DeleteProperty] = [multiname];
					dict[DefaultXMLNamespace] = [String];
					dict[FindProperty] = [multiname];
					dict[FindPropertyStrict] = [multiname];
					dict[GetDescendants] = [multiname];
					dict[GetGlobalSlot] = [U30];
					dict[GetLex] = [multiname];
					dict[GetLocal] = [U30];
					dict[GetProperty] = [multiname];
					dict[GetScopeObject] = [U8];
					dict[GetSlot] = [U30];
					dict[GetSuper] = [multiname];
					dict[HasNext2] = [U30, U30]; // ?
					dict[IfEquals] = [S24];
					dict[IfFalse] = [S24];
					dict[IfGreaterThanOrEquals] = [S24];
					dict[IfGreaterThan] = [S24];
					dict[IfLessThanOrEquals] = [S24];
					dict[IfLessThan] = [S24];
					dict[IfNotGreaterThanOrEquals] = [S24];
					dict[IfNotGreaterThan] = [S24];
					dict[IfNotLessThanOrEquals] = [S24];
					dict[IfNotLessThan] = [S24];
					dict[IfNotEquals] = [S24];
					dict[IfStrictEquals] = [S24];
					dict[IfStrictNotEquals] = [S24];
					dict[IfTrue] = [S24];
					dict[IncrementLocal] = [U30];
					dict[IncrementLocalInteger] = [U30];
					dict[InitProperty] = [multiname];
					dict[IsType] = [multiname];
					dict[Jump] = [S24];
					dict[Kill] = [U30];
					dict[LookUpSwitch] = notSupportedInstructionHandler;
					dict[NewArray] = [U30];
					dict[NewCatch] = notSupportedInstructionHandler;
					dict[NewClass] = [Class];
					dict[NewFunction] = [Method];
					dict[NewObject] = [U30];
					dict[PushByte] = [U8];
					dict[PushDouble] = [Double];
					dict[PushInt] = [Integer];
					dict[PushNamespace] = [Namespace];
					dict[PushShort] = [U30];
					dict[PushString] = [String];
					dict[PushUInt] = [UInteger];
					dict[SetLocal] = [U30];
					dict[SetGlobalSlot] = [U30];
					dict[SetProperty] = [multiname];
					dict[SetSlot] = [U30];
					dict[SetSuper] = [multiname];
				} 
			}
			
			return dict;
		}
	}
}

import org.as3commons.emit.bytecode.BCNamespace;
import org.as3commons.lang.IEquals;	

class IndexedObject {
	public var Data : Array;
	public var Object : IEquals;
}
