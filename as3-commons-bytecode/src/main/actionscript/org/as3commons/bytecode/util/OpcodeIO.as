/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.bytecode.util {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ByteCodeErrorEvent;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.IConstantPool;
	import org.as3commons.bytecode.abc.Integer;
	import org.as3commons.bytecode.abc.JumpTargetData;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.UnsignedInteger;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.asm.ClassInfoReference;
	import org.as3commons.lang.StringUtils;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public final class OpcodeIO {
		public static const errorDispatcher:IEventDispatcher = new EventDispatcher();
		public static const jumpOpcodes:Dictionary = createJumpOpcodesLookup();
		private static const UNKNOWN_OPCODE_ARGUMENTTYPE:String = "Unknown Opcode argument type. {0}";

		/**
		 * Parses the bytecode block out of the given ByteArray, returning an array of Ops representing the
		 * bytecode in the Ops. This method assumes that the ByteArray is positioned at the top of an
		 * opcode block.
		 */
		public static function parse(byteArray:ByteArray, opcodeByteCodeLength:int, methodBody:MethodBody, constantPool:IConstantPool):Vector.<Op> {
			var opcodePositions:Dictionary = new Dictionary();
			var opcodeEndPositions:Dictionary = new Dictionary();
			var ops:Vector.<Op> = new Vector.<Op>();
			methodBody.jumpTargets ||= new Vector.<JumpTargetData>();
			var methodBodyPosition:uint = byteArray.position;
			var opcodeStartPosition:uint = 0;
			var offset:uint = 0;
			var newOp:Op;
			var positionAtEndOfBytecode:int = (byteArray.position + opcodeByteCodeLength);
			try {
				while (byteArray.position < positionAtEndOfBytecode) {
					opcodeStartPosition = byteArray.position;
					newOp = parseOpcode(byteArray, constantPool, ops, methodBody);
					newOp.baseLocation = offset;
					offset += (byteArray.position - opcodeStartPosition);
					newOp.endLocation = offset;
					opcodePositions[newOp.baseLocation] = newOp;
					opcodeEndPositions[newOp.endLocation] = newOp;
				}
				if (byteArray.position > positionAtEndOfBytecode) {
					throw new Error("Opcode parsing read beyond end of method body");
				}
			} catch (e:*) {
				var pos:int = (byteArray.position - methodBodyPosition);
				var fragment:ByteArray = AbcSpec.newByteArray();
				fragment.writeBytes(byteArray, methodBodyPosition, opcodeByteCodeLength);
				fragment.position = 0;
				errorDispatcher.dispatchEvent(new ByteCodeErrorEvent(ByteCodeErrorEvent.BYTECODE_METHODBODY_ERROR, fragment, pos));
				throw e;
			}

			resolveParsedJumpTargets(methodBody, opcodePositions, opcodeEndPositions, opcodeByteCodeLength);
			methodBody.opcodeBaseLocations = opcodePositions;
			return ops;
		}

		public static function parseOpcode(byteArray:ByteArray, constantPool:IConstantPool, ops:Vector.<Op>, methodBody:MethodBody):Op {
			var startPos:int = byteArray.position;
			var opcode:Opcode = Opcode.determineOpcode(AbcSpec.readU8(byteArray));
			var argumentValues:Array = [];
			for each (var argument:* in opcode.argumentTypes) {
				parseOpcodeArguments(argument, byteArray, constantPool, methodBody, argumentValues);
			}
			var endPos:int = byteArray.position;

			var op:Op = opcode.op(argumentValues);
			ops[ops.length] = op;
			if (jumpOpcodes[opcode] == true) {
				methodBody.jumpTargets[methodBody.jumpTargets.length] = new JumpTargetData(op);
			}
			return op;
		}

		public static function parseOpcodeArguments(argument:*, byteArray:ByteArray, constantPool:IConstantPool, methodBody:MethodBody, argumentValues:Array):void {
			var argumentType:* = argument[0];
			var readWritePair:ReadWritePair = argument[1];
			var byteCodeValue:* = readWritePair.read(byteArray);
			var constantPoolValue:*;

			switch (argumentType) {
				case uint:
				case int:
					argumentValues[argumentValues.length] = byteCodeValue;
					break;

				case Integer:
					constantPoolValue = constantPool.integerPool[byteCodeValue];
					CONFIG::debug {
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
				}
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case UnsignedInteger:
					constantPoolValue = constantPool.uintPool[byteCodeValue];
					CONFIG::debug {
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
				}
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case Number:
					constantPoolValue = constantPool.doublePool[byteCodeValue];
					CONFIG::debug {
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
				}
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case BaseMultiname:
					constantPoolValue = constantPool.multinamePool[byteCodeValue];
					CONFIG::debug {
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
				}
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case ClassInfo:
					constantPoolValue = constantPool.classInfo[byteCodeValue];
					CONFIG::debug {
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
				}
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case String:
					constantPoolValue = constantPool.stringPool[byteCodeValue];
					CONFIG::debug {
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
				}
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case LNamespace:
					constantPoolValue = constantPool.namespacePool[byteCodeValue];
					CONFIG::debug {
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
				}
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case Array:
					//TODO: Come back and clean this up with a different parser model. lookupswitch f'd up the clean pre-existing model
					// Special case for lookupswitch opcode. We need to iterate the possible case
					// values and pull their offsets from the bytestream. The first value has
					// already been read for us by the time this switch is invoked, we just need
					// to pull the rest of the offsets. We determine how many there are by looking at
					// the second argument to the op, which is the case_count
					//new Opcode(0x1b, "lookupswitch", [int, AbcSpec.S24], [int, AbcSpec.U30], [Array, AbcSpec.S24_ARRAY]);
					var caseOffsets:Array = [];
					var caseCount:int = int(argumentValues[1]);
					caseOffsets[caseOffsets.length] = byteCodeValue;
					for (var i:int = 0; i < caseCount; ++i) {
						caseOffsets[caseOffsets.length] = readWritePair.read(byteArray);
					}
					argumentValues[argumentValues.length] = caseOffsets;
					break;

				case ExceptionInfo:
					//Exception info is assigned after all opcodes and exception infos have been parsed,
					//so for now we only assign the raw value (which is the index into the methodbody's exception info array)
					argumentValues[argumentValues.length] = byteCodeValue;
					break;

				default:
					throw new Error("Unknown Opcode argument type." + argumentType.toString());
			}
		}

		public static function resolveJumpTarget(positions:Dictionary, jumpOpcode:Op, targetOpcode:Op, serializedOpcodes:ByteArray, isLookupSwitch:Boolean=false, index:int=-1):Boolean {
			if (targetOpcode.opcode === Opcode.END_OF_BODY) {
				return false;
			}
			var jumpParam:int = (index < 0) ? int(jumpOpcode.parameters[0]) : jumpOpcode.parameters[2][index];
			var baseLocation:int = (isLookupSwitch) ? jumpOpcode.baseLocation : jumpOpcode.endLocation;
			var targetPos:int = baseLocation + jumpParam;
			if (targetPos != targetOpcode.baseLocation) {
				var operandPos:int = jumpOpcode.baseLocation;
				var newJump:int = (targetOpcode.baseLocation - baseLocation);
				serializedOpcodes.position = operandPos + 1;
				if (index > -1) {
					AbcSpec.readU30(serializedOpcodes);
				}
				while (index-- > 0) {
					AbcSpec.readS24(serializedOpcodes);
				}
				AbcSpec.writeS24(newJump, serializedOpcodes);
				return true;
			}
			return false;
		}

		public static function resolveJumpTargets(serializedOpcodes:ByteArray, backPatches:Vector.<JumpTargetData>, positions:Dictionary):void {
			for each (var jumpData:JumpTargetData in backPatches) {
				var changed:Boolean = false;
				if (jumpData.targetOpcode != null) {
					if (resolveJumpTarget(positions, jumpData.jumpOpcode, jumpData.targetOpcode, serializedOpcodes, (jumpData.jumpOpcode.opcode === Opcode.lookupswitch)) == true) {
						changed = true;
					}
				}
				if (jumpData.extraOpcodes != null) {
					var idx:int = 0;
					for each (var targetOpcode:Op in jumpData.extraOpcodes) {
						if (resolveJumpTarget(positions, jumpData.jumpOpcode, targetOpcode, serializedOpcodes, true, idx++)) {
							changed = true;
						}
					}
				}

			}
		}

		public static function resolveParsedJumpTargets(methodBody:MethodBody, opcodeStartPositions:Dictionary, opcodeEndPositions:Dictionary, positionAtEndOfMethodBody:int):void {
			var pos:int;
			var targetPos:int;
			var target:Op;
			var len:int;
			var arr:Array;
			for each (var jmpTarget:JumpTargetData in methodBody.jumpTargets) {
				if (jmpTarget.jumpOpcode.opcode !== Opcode.lookupswitch) {
					pos = int(jmpTarget.jumpOpcode.parameters[0]);
					targetPos = jmpTarget.jumpOpcode.endLocation + pos;
					target = opcodeStartPositions[targetPos];
					if (target == null) {
						target = Opcode.END_OF_BODY.op();
						target.baseLocation = positionAtEndOfMethodBody;
					}
					jmpTarget.targetOpcode = target;
				} else {
					arr = jmpTarget.jumpOpcode.parameters[2] as Array;
					len = arr.length;
					for (var i:int = 0; i < len; ++i) {
						pos = arr[i];
						targetPos = jmpTarget.jumpOpcode.baseLocation + pos;
						target = opcodeStartPositions[targetPos];
						if (target == null) {
							target = Opcode.END_OF_BODY.op();
							target.baseLocation = positionAtEndOfMethodBody;
						}
						jmpTarget.addTarget(target);
					}
					pos = jmpTarget.jumpOpcode.parameters[0];
					targetPos = jmpTarget.jumpOpcode.baseLocation + pos;
					target = opcodeStartPositions[targetPos];
					if (target == null) {
						target = Opcode.END_OF_BODY.op();
						target.baseLocation = positionAtEndOfMethodBody;
					}
					jmpTarget.targetOpcode = target;
				}
			}
		}

		/**
		 * Serializes an array of Ops, returning a ByteArray with the opcode output block.
		 */
		public static function serialize(ops:Vector.<Op>, methodBody:MethodBody, abcFile:AbcFile):ByteArray {
			var opcodePositions:Dictionary = new Dictionary();
			var serializedOpcodes:ByteArray = AbcSpec.newByteArray();
			var len:int = ops.length;
			var i:int;
			var op:Op;
			for (i = 0; i < len; ++i) {
				op = ops[i];
				if (op.opcode !== Opcode.END_OF_BODY) {
					op.baseLocation = serializedOpcodes.position;
					opcodePositions[op] = serializedOpcodes.position;
					AbcSpec.writeU8(op.opcode.opcodeValue, serializedOpcodes);

					serializeOpcodeArguments(op, abcFile, methodBody, serializedOpcodes);
					op.endLocation = serializedOpcodes.position;
				}
			}
			serializedOpcodes.position = 0;
			resolveJumpTargets(serializedOpcodes, methodBody.jumpTargets, opcodePositions);
			serializedOpcodes.position = 0;
			methodBody.opcodeBaseLocations = opcodePositions;
			return serializedOpcodes;
		}

		public static function serializeOpcodeArgument(rawValue:*, argumentType:*, abcFile:AbcFile, methodBody:MethodBody, op:Op, serializedOpcodes:ByteArray, readWritePair:ReadWritePair):void {
			var abcCompatibleValue:* = rawValue;

			switch (argumentType) {
				case uint:
				case int:
					abcCompatibleValue = rawValue;
					//trace("\tNumber: " + abcCompatibleValue + "(" + rawValue + ")");
					break;

				case Integer:
					abcCompatibleValue = abcFile.constantPool.addInt(rawValue);
					break;

				case UnsignedInteger:
					abcCompatibleValue = abcFile.constantPool.addUint(rawValue);
					break;

				case Number:
					abcCompatibleValue = abcFile.constantPool.addDouble(rawValue);
					//trace("\tNumber: " + abcCompatibleValue + "(" + rawValue + ")");
					break;

				case BaseMultiname:
					abcCompatibleValue = abcFile.constantPool.addMultiname(rawValue);
					//trace("\tMultiname: " + abcCompatibleValue + "(" + rawValue + ")");
					break;

				case ClassInfo:
					if (rawValue is ClassInfoReference) {
						abcCompatibleValue = abcFile.addClassInfoReference(rawValue);
						CONFIG::debug {
							Assert.state(abcCompatibleValue > 0, "Unknown classinfo: " + ClassInfoReference(rawValue).classMultiName.toString());
						}
					} else {
						abcCompatibleValue = abcFile.addClassInfo(rawValue);
					}
					//                            trace("\tClassInfo: " + abcCompatibleValue + "(" + rawValue + ")");
					break;

				case String:
					abcCompatibleValue = abcFile.constantPool.addString(rawValue);
					//                            trace("\tString: " + abcCompatibleValue + "(" + rawValue + ")");
					break;

				case LNamespace:
					abcCompatibleValue = abcFile.constantPool.addNamespace(rawValue);
					//                            trace("\tString: " + abcCompatibleValue + "(" + rawValue + ")");
					break;

				case ExceptionInfo:
					abcCompatibleValue = methodBody.addExceptionInfo(rawValue);
					break;

				case Array:
					var arr:Array = rawValue as Array;
					var caseCount:int = arr.length;
					for (var i:int = 0; i < caseCount; ++i) {
						readWritePair.write(arr[i], serializedOpcodes);
					}
					break;

				default:
					throw new Error(StringUtils.substitute(UNKNOWN_OPCODE_ARGUMENTTYPE, +argumentType));
			}

			try {
				if (!(abcCompatibleValue is Array)) {
					readWritePair.write(abcCompatibleValue, serializedOpcodes);
				}
			} catch (e:Error) {
				trace(e);
			}
		}

		public static function serializeOpcodeArguments(op:Op, abcFile:AbcFile, methodBody:MethodBody, serializedOpcodes:ByteArray):void {
			var serializedArgumentCount:int = 0;
			for each (var typeAndReadWritePair:Array in op.opcode.argumentTypes) {
				var argumentType:* = typeAndReadWritePair[0];
				var readWritePair:ReadWritePair = typeAndReadWritePair[1];
				var rawValue:* = op.parameters[serializedArgumentCount++];
				serializeOpcodeArgument(rawValue, argumentType, abcFile, methodBody, op, serializedOpcodes, readWritePair);
			}
		}

		private static function createJumpOpcodesLookup():Dictionary {
			var result:Dictionary = new Dictionary();
			result[Opcode.ifeq] = true;
			result[Opcode.ifge] = true;
			result[Opcode.ifgt] = true;
			result[Opcode.ifle] = true;
			result[Opcode.iflt] = true;
			result[Opcode.ifne] = true;
			result[Opcode.ifnge] = true;
			result[Opcode.ifngt] = true;
			result[Opcode.ifnle] = true;
			result[Opcode.ifnlt] = true;
			result[Opcode.ifstricteq] = true;
			result[Opcode.ifstrictne] = true;
			result[Opcode.iffalse] = true;
			result[Opcode.iftrue] = true;
			result[Opcode.jump] = true;
			result[Opcode.lookupswitch] = true;
			return result;
		}
	}
}
