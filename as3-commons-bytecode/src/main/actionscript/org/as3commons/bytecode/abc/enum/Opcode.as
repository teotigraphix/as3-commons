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
package org.as3commons.bytecode.abc.enum {
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import mx.controls.Alert;
	import mx.effects.easing.Back;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ByteCodeErrorEvent;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.Integer;
	import org.as3commons.bytecode.abc.JumpTargetData;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.OpcodePosition;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.UnsignedInteger;
	import org.as3commons.bytecode.emit.asm.ClassInfoReference;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.ReadWritePair;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of possible values for the kinds of opcodes in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "AVM2 instructions" in the AVM Spec (page 35)
	 */
	//TODO: Derive local_count etc. from opcodes. Page 15 of the AVM2 spec covers this in more detail.
	public class Opcode {

		private static var _enumCreated:Boolean = false;
		private static const _ALL_OPCODES:Dictionary = new Dictionary();
		private static const _opcodeNameLookup:Dictionary = new Dictionary();

		public static const errorDispatcher:IEventDispatcher = new EventDispatcher();

		// 162 total opcodes
		public static const add:Opcode = new Opcode(0xa0, "add");
		public static const add_d:Opcode = new Opcode(0x9B, "add_d"); //Added
		public static const add_i:Opcode = new Opcode(0xC5, "add_i"); //Added
		public static const applytype:Opcode = new Opcode(0x53, "applytype", [int, AbcSpec.U30]); //Added
		public static const astype:Opcode = new Opcode(0x86, "astype", [BaseMultiname, AbcSpec.U30]);
		public static const astypelate:Opcode = new Opcode(0x87, "astypelate");
		public static const bitand:Opcode = new Opcode(0xa8, "bitand");
		public static const bitnot:Opcode = new Opcode(0x97, "bitnot");
		public static const bitor:Opcode = new Opcode(0xa9, "bitor"); //Added
		public static const bitxor:Opcode = new Opcode(0xAA, "bitxor"); //Added
		public static const bkpt:Opcode = new Opcode(0x01, "bkpt"); //Added
		public static const bkptline:Opcode = new Opcode(0xF2, "bkptline", [Integer, AbcSpec.U30]);
		public static const call:Opcode = new Opcode(0x41, "call", [int, AbcSpec.U30]);
		public static const callinterface:Opcode = new Opcode(0x4D, "callinterface", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]); //Added
		public static const callmethod:Opcode = new Opcode(0x43, "callmethod", [int, AbcSpec.U30], [int, AbcSpec.U30]); //Added
		public static const callproperty:Opcode = new Opcode(0x46, "callproperty", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
		public static const callproplex:Opcode = new Opcode(0x4C, "callproplex", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]); //Added
		public static const callpropvoid:Opcode = new Opcode(0x4f, "callpropvoid", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
		public static const callstatic:Opcode = new Opcode(0x44, "callstatic", [int, AbcSpec.U30], [int, AbcSpec.U30]); //Added
		public static const callsuper:Opcode = new Opcode(0x45, "callsuper", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
		public static const callsuperid:Opcode = new Opcode(0x4B, "callsuperid"); //Added
		public static const callsupervoid:Opcode = new Opcode(0x4e, "callsupervoid", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
		public static const checkfilter:Opcode = new Opcode(0x78, "checkfilter");
		public static const coerce:Opcode = new Opcode(0x80, "coerce", [BaseMultiname, AbcSpec.U30]);
		public static const coerce_a:Opcode = new Opcode(0x82, "coerce_a");
		public static const coerce_b:Opcode = new Opcode(0x81, "coerce_b"); //Added
		public static const coerce_d:Opcode = new Opcode(0x84, "coerce_d"); //Added
		public static const coerce_i:Opcode = new Opcode(0x83, "coerce_i"); //Added
		public static const coerce_o:Opcode = new Opcode(0x89, "coerce_o"); //Added
		public static const coerce_s:Opcode = new Opcode(0x85, "coerce_s");
		public static const coerce_u:Opcode = new Opcode(0x88, "coerce_u"); //Added
		public static const concat:Opcode = new Opcode(0x9A, "concat"); //Added
		public static const construct:Opcode = new Opcode(0x42, "construct", [int, AbcSpec.U30]);
		public static const constructprop:Opcode = new Opcode(0x4a, "constructprop", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
		public static const constructsuper:Opcode = new Opcode(0x49, "constructsuper", [int, AbcSpec.U30]);
		public static const convert_b:Opcode = new Opcode(0x76, "convert_b");
		public static const convert_d:Opcode = new Opcode(0x75, "convert_d");
		public static const convert_i:Opcode = new Opcode(0x73, "convert_i");
		public static const convert_o:Opcode = new Opcode(0x77, "convert_o"); //Added
		public static const convert_s:Opcode = new Opcode(0x70, "convert_s");
		public static const convert_u:Opcode = new Opcode(0x74, "convert_u");
		public static const debug:Opcode = new Opcode(0xEF, "debug", [uint, AbcSpec.U8], [int, AbcSpec.U30], [uint, AbcSpec.U8], [int, AbcSpec.U30]); //Added
		public static const debugfile:Opcode = new Opcode(0xF1, "debugfile", [String, AbcSpec.U30]); //Added
		public static const debugline:Opcode = new Opcode(0xF0, "debugline", [int, AbcSpec.U30]); //Added
		public static const declocal:Opcode = new Opcode(0x94, "declocal", [int, AbcSpec.U30]); //Added
		public static const declocal_i:Opcode = new Opcode(0xC3, "declocal_i", [int, AbcSpec.U30]); //Added
		public static const decrement:Opcode = new Opcode(0x93, "decrement");
		public static const decrement_i:Opcode = new Opcode(0xc1, "decrement_i");
		public static const deleteproperty:Opcode = new Opcode(0x6a, "deleteproperty", [BaseMultiname, AbcSpec.U30]);
		public static const deletepropertylate:Opcode = new Opcode(0x6B, "deletepropertylate"); //Added
		public static const divide:Opcode = new Opcode(0xa3, "divide");
		public static const dup:Opcode = new Opcode(0x2a, "dup");
		public static const dxns:Opcode = new Opcode(0x06, "dxns", [String, AbcSpec.U30]); //Added
		public static const dxnslate:Opcode = new Opcode(0x07, "dxnslate"); //Added
		public static const equals:Opcode = new Opcode(0xab, "equals");
		public static const esc_xattr:Opcode = new Opcode(0x72, "esc_xattr"); //Added
		public static const esc_xelem:Opcode = new Opcode(0x71, "esc_xelem"); //Added
		public static const finddef:Opcode = new Opcode(0x5F, "finddef", [BaseMultiname, AbcSpec.U30]); //Added
		public static const findpropglobalstrict:Opcode = new Opcode(0x5b, "findpropglobalstrict", [BaseMultiname, AbcSpec.U30]); //Added
		public static const findpropglobal:Opcode = new Opcode(0x5c, "findpropglobal", [BaseMultiname, AbcSpec.U30]); //Added
		public static const findproperty:Opcode = new Opcode(0x5e, "findproperty", [BaseMultiname, AbcSpec.U30]);
		public static const findpropstrict:Opcode = new Opcode(0x5d, "findpropstrict", [BaseMultiname, AbcSpec.U30]);
		public static const getdescendants:Opcode = new Opcode(0x59, "getdescendants", [BaseMultiname, AbcSpec.U30]);
		public static const getglobalscope:Opcode = new Opcode(0x64, "getglobalscope");
		public static const getglobalslot:Opcode = new Opcode(0x6E, "getglobalslot", [int, AbcSpec.U30]); //Added
		public static const getlex:Opcode = new Opcode(0x60, "getlex", [BaseMultiname, AbcSpec.U30]);
		public static const getlocal:Opcode = new Opcode(0x62, "getlocal", [int, AbcSpec.U30]);
		public static const getlocal_0:Opcode = new Opcode(0xd0, "getlocal_0");
		public static const getlocal_1:Opcode = new Opcode(0xd1, "getlocal_1");
		public static const getlocal_2:Opcode = new Opcode(0xd2, "getlocal_2");
		public static const getlocal_3:Opcode = new Opcode(0xd3, "getlocal_3");
		public static const getouterscope:Opcode = new Opcode(0x67, "getouterscope", [BaseMultiname, AbcSpec.U30]); //Added
		public static const getproperty:Opcode = new Opcode(0x66, "getproperty", [BaseMultiname, AbcSpec.U30]);
		public static const getscopeobject:Opcode = new Opcode(0x65, "getscopeobject", [int, AbcSpec.U8]); // unsigned byte - using U8 for the same reasons as pushbyte
		public static const getslot:Opcode = new Opcode(0x6c, "getslot", [int, AbcSpec.U30]);
		public static const getsuper:Opcode = new Opcode(0x04, "getsuper", [BaseMultiname, AbcSpec.U30]);
		public static const greaterequals:Opcode = new Opcode(0xb0, "greaterequals");
		public static const greaterthan:Opcode = new Opcode(0xaf, "greaterthan");
		public static const hasnext2:Opcode = new Opcode(0x32, "hasnext2", [int, AbcSpec.U30], [int, AbcSpec.U30]); // I'm guessing this is two u30s since they are register positions - the spec was not explicit about this
		public static const hasnext:Opcode = new Opcode(0x1F, "hasnext"); //Added
		public static const ifeq:Opcode = new Opcode(0x13, "ifeq", [int, AbcSpec.S24]);
		public static const iffalse:Opcode = new Opcode(0x12, "iffalse", [int, AbcSpec.S24]);
		public static const ifge:Opcode = new Opcode(0x18, "ifge", [int, AbcSpec.S24]);
		public static const ifgt:Opcode = new Opcode(0x17, "ifgt", [int, AbcSpec.S24]);
		public static const ifle:Opcode = new Opcode(0x16, "ifle", [int, AbcSpec.S24]);
		public static const iflt:Opcode = new Opcode(0x15, "iflt", [int, AbcSpec.S24]);
		public static const ifne:Opcode = new Opcode(0x14, "ifne", [int, AbcSpec.S24]);
		public static const ifnge:Opcode = new Opcode(0x0f, "ifnge", [int, AbcSpec.S24]);
		public static const ifnle:Opcode = new Opcode(0x0d, "ifnle", [int, AbcSpec.S24]);
		public static const ifnlt:Opcode = new Opcode(0x0c, "ifnlt", [int, AbcSpec.S24]);
		public static const ifngt:Opcode = new Opcode(0x0e, "ifngt", [int, AbcSpec.S24]);
		public static const ifstricteq:Opcode = new Opcode(0x19, "ifstricteq", [int, AbcSpec.S24]);
		public static const ifstrictne:Opcode = new Opcode(0x1a, "ifstrictne", [int, AbcSpec.S24]);
		public static const iftrue:Opcode = new Opcode(0x11, "iftrue", [int, AbcSpec.S24]);
		public static const in_op:Opcode = new Opcode(0xb4, "in");
		public static const inclocal:Opcode = new Opcode(0x92, "inclocal", [int, AbcSpec.U30]); //Added
		public static const inclocal_i:Opcode = new Opcode(0xc2, "inclocal_i", [int, AbcSpec.U30]);
		public static const increment:Opcode = new Opcode(0x91, "increment");
		public static const increment_i:Opcode = new Opcode(0xc0, "increment_i");
		public static const initproperty:Opcode = new Opcode(0x68, "initproperty", [BaseMultiname, AbcSpec.U30]);
		public static const instance_of:Opcode = new Opcode(0xB1, "instance_of"); //Added
		public static const istype:Opcode = new Opcode(0xB2, "istype", [BaseMultiname, AbcSpec.U30]); //Added
		public static const istypelate:Opcode = new Opcode(0xb3, "istypelate");
		public static const jump:Opcode = new Opcode(0x10, "jump", [int, AbcSpec.S24]);
		public static const kill:Opcode = new Opcode(0x08, "kill", [int, AbcSpec.U30]);
		public static const label:Opcode = new Opcode(0x09, "label");
		public static const lessequals:Opcode = new Opcode(0xae, "lessequals");
		public static const lessthan:Opcode = new Opcode(0xad, "lessthan");
		public static const lookupswitch:Opcode = new Opcode(0x1b, "lookupswitch", [int, AbcSpec.S24], [int, AbcSpec.U30], [Array, AbcSpec.S24_ARRAY]); // NOTE: lookupswitch is a special case because it has a variable number of arguments
		public static const lshift:Opcode = new Opcode(0xa5, "lshift");
		public static const modulo:Opcode = new Opcode(0xa4, "modulo");
		public static const multiply:Opcode = new Opcode(0xa2, "multiply");
		public static const multiply_i:Opcode = new Opcode(0xC7, "multiply_i"); //Added
		public static const negate:Opcode = new Opcode(0x90, "negate");
		public static const negate_i:Opcode = new Opcode(0xC4, "negate_i"); //Added
		public static const newactivation:Opcode = new Opcode(0x57, "newactivation");
		public static const newarray:Opcode = new Opcode(0x56, "newarray", [int, AbcSpec.U30]);
		public static const newcatch:Opcode = new Opcode(0x5a, "newcatch", [ExceptionInfo, AbcSpec.U30]);
		public static const newclass:Opcode = new Opcode(0x58, "newclass", [ClassInfo, AbcSpec.U30]);
		public static const newfunction:Opcode = new Opcode(0x40, "newfunction", [int, AbcSpec.U30]); // u30 - methodInfo
		public static const newobject:Opcode = new Opcode(0x55, "newobject", [int, AbcSpec.U30]);
		public static const nextname:Opcode = new Opcode(0x1e, "nextname");
		public static const nextvalue:Opcode = new Opcode(0x23, "nextvalue");
		public static const nop:Opcode = new Opcode(0x02, "nop"); //Added
		public static const not:Opcode = new Opcode(0x96, "not");
		public static const pop:Opcode = new Opcode(0x29, "pop");
		public static const popscope:Opcode = new Opcode(0x1d, "popscope");
		public static const pushbyte:Opcode = new Opcode(0x24, "pushbyte", [int, AbcSpec.UNSIGNED_BYTE]); // unsigned byte... however, this was writing out too many bytes (4 bytes for the value instead of 1)
		public static const pushconstant:Opcode = new Opcode(0x22, "pushconstant", [String, AbcSpec.U30]); //Added
		public static const pushdouble:Opcode = new Opcode(0x2f, "pushdouble", [Number, AbcSpec.U30]);
		public static const pushfalse:Opcode = new Opcode(0x27, "pushfalse");
		public static const pushint:Opcode = new Opcode(0x2d, "pushint", [Integer, AbcSpec.U30]);
		public static const pushnamespace:Opcode = new Opcode(0x31, "pushnamespace", [LNamespace, AbcSpec.U30]); //Added
		public static const pushnan:Opcode = new Opcode(0x28, "pushnan");
		public static const pushnull:Opcode = new Opcode(0x20, "pushnull");
		public static const pushscope:Opcode = new Opcode(0x30, "pushscope");
		public static const pushshort:Opcode = new Opcode(0x25, "pushshort", [uint, AbcSpec.U30]);
		public static const pushstring:Opcode = new Opcode(0x2c, "pushstring", [String, AbcSpec.U30]);
		public static const pushtrue:Opcode = new Opcode(0x26, "pushtrue");
		public static const pushuint:Opcode = new Opcode(0x2E, "pushuint", [UnsignedInteger, AbcSpec.U30]); //Added
		public static const pushundefined:Opcode = new Opcode(0x21, "pushundefined");
		public static const pushwith:Opcode = new Opcode(0x1c, "pushwith");
		public static const returnvalue:Opcode = new Opcode(0x48, "returnvalue");
		public static const returnvoid:Opcode = new Opcode(0x47, "returnvoid");
		public static const rshift:Opcode = new Opcode(0xa6, "rshift");
		public static const setglobalslot:Opcode = new Opcode(0x6F, "setglobalslot", [int, AbcSpec.U30]); //Added
		public static const setlocal:Opcode = new Opcode(0x63, "setlocal", [int, AbcSpec.U30]);
		public static const setlocal_0:Opcode = new Opcode(0xD4, "setlocal_0");
		public static const setlocal_1:Opcode = new Opcode(0xD5, "setlocal_1");
		public static const setlocal_2:Opcode = new Opcode(0xD6, "setlocal_2");
		public static const setlocal_3:Opcode = new Opcode(0xD7, "setlocal_3");
		public static const setproperty:Opcode = new Opcode(0x61, "setproperty", [BaseMultiname, AbcSpec.U30]);
		public static const setpropertylate:Opcode = new Opcode(0x69, "setpropertylate"); //Added
		public static const setslot:Opcode = new Opcode(0x6d, "setslot", [int, AbcSpec.U30]); // u30 - slotId
		public static const setsuper:Opcode = new Opcode(0x05, "setsuper", [BaseMultiname, AbcSpec.U30]);
		public static const strictequals:Opcode = new Opcode(0xac, "strictequals");
		public static const subtract:Opcode = new Opcode(0xa1, "subtract");
		public static const subtract_i:Opcode = new Opcode(0xC6, "subtract_i"); //Added
		public static const swap:Opcode = new Opcode(0x2b, "swap");
		public static const throw_op:Opcode = new Opcode(0x03, "throw");
		public static const typeof_op:Opcode = new Opcode(0x95, "typeof");
		public static const urshift:Opcode = new Opcode(0xa7, "urshift");

		private static const UNKNOWN_OPCODE_ARGUMENTTYPE:String = "Unknown Opcode argument type. {0}";

		private static var _jumpLookup:Dictionary;
		private static var _opcodePositions:Dictionary;
		public static const jumpOpcodes:Dictionary = new Dictionary();
		{
			jumpOpcodes[ifeq] = true;
			jumpOpcodes[ifge] = true;
			jumpOpcodes[ifgt] = true;
			jumpOpcodes[ifle] = true;
			jumpOpcodes[iflt] = true;
			jumpOpcodes[ifne] = true;
			jumpOpcodes[ifnge] = true;
			jumpOpcodes[ifngt] = true;
			jumpOpcodes[ifnle] = true;
			jumpOpcodes[ifnlt] = true;
			jumpOpcodes[ifstricteq] = true;
			jumpOpcodes[ifstrictne] = true;
			jumpOpcodes[iffalse] = true;
			jumpOpcodes[iftrue] = true;
			jumpOpcodes[jump] = true;
			jumpOpcodes[lookupswitch] = true;
		}

		private var _opcodeName:String;
		private var _value:int;
		private var _argumentTypes:Array;

		{
			_enumCreated = true;
		}

		public function Opcode(opcodeValue:int, opcodeName:String, ... typeAndReadWritePairs) {
			Assert.state((!_enumCreated), "Opcode enum has already been created");
			_value = opcodeValue;
			_opcodeName = opcodeName;
			_argumentTypes = typeAndReadWritePairs;

			if (_ALL_OPCODES[_value] == null) {
				_ALL_OPCODES[_value] = this;
			} else {
				throw new IllegalOperationError("duplicate! " + opcodeName + " : " + Opcode(_ALL_OPCODES[_value]).opcodeName);
			}
			_opcodeNameLookup[opcodeName] = this;
		}

		public static function fromName(opcodeName:String):Opcode {
			return _opcodeNameLookup[opcodeName] as Opcode;
		}

		/**
		 * Serializes an array of Ops, returning a ByteArray with the opcode output block.
		 */
		public static function serialize(ops:Array, methodBody:MethodBody, abcFile:AbcFile):ByteArray {
			_opcodePositions = new Dictionary();
			var serializedOpcodes:ByteArray = AbcSpec.byteArray();
			for each (var op:Op in ops) {
				_opcodePositions[op] = serializedOpcodes.position;
				AbcSpec.writeU8(op.opcode._value, serializedOpcodes);

				serializeOpcodeArguments(op, abcFile, methodBody, serializedOpcodes);
//				trace(serializedOpcodes.position + "\t" + op);
			}
			serializedOpcodes.position = 0;
			resolveBackPatches(serializedOpcodes, methodBody.backPatches, _opcodePositions);
			serializedOpcodes.position = 0;
			serializedOpcodes.position = 0;
			_opcodePositions = null;
			return serializedOpcodes;
		}

		public static function resolveBackPatches(serializedOpcodes:ByteArray, backPatches:Array, positions:Dictionary):void {
			for each (var jumpData:JumpTargetData in backPatches) {
				var targetPos:int = positions[jumpData.jumpOpcode] + int(jumpData.jumpOpcode.parameters[0]);
				var targetOpPos:int = (positions[jumpData.targetOpcode]) ? positions[jumpData.targetOpcode] : 0;
				if (targetPos != targetOpPos) {
					serializedOpcodes.position = (positions[jumpData.jumpOpcode]) + 1;
					var operandPos:int = serializedOpcodes.position;
					var newJump:int = (targetOpPos - (operandPos + 3));
					serializedOpcodes.position = operandPos;
					AbcSpec.writeS24(newJump, serializedOpcodes);
				}
			}
		}

		public static function serializeOpcodeArguments(op:Op, abcFile:AbcFile, methodBody:MethodBody, serializedOpcodes:ByteArray):void {
			var serializedArgumentCount:int = 0;
			for each (var typeAndReadWritePair:Array in op.opcode.argumentTypes) {
				var argumentType:* = typeAndReadWritePair[0];
				var readWritePair:ReadWritePair = typeAndReadWritePair[1];
				var rawValue:* = op.parameters[serializedArgumentCount++];
				serializeOpcode(rawValue, argumentType, abcFile, methodBody, op, serializedOpcodes, readWritePair);
			}
		}

		public static function serializeOpcode(rawValue:*, argumentType:*, abcFile:AbcFile, methodBody:MethodBody, op:Op, serializedOpcodes:ByteArray, readWritePair:ReadWritePair):void {
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
						Assert.state(abcCompatibleValue > 0, "Unknown classinfo: " + ClassInfoReference(rawValue).classMultiName.toString());
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
						AbcSpec.writeS24(arr[i], serializedOpcodes);
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


		/**
		 * Parses the bytecode block out of the given ByteArray, returning an array of Ops representing the
		 * bytecode in the Ops. This method assumes that the ByteArray is positioned at the top of an
		 * opcode block.
		 */
		public static function parse(byteArray:ByteArray, opcodeByteCodeLength:int, methodBody:MethodBody, abcFile:AbcFile):Array {
			_opcodePositions = new Dictionary();
			var ops:Array = [];
			methodBody.backPatches = [];
			_jumpLookup = new Dictionary();
			var startPosition:int = byteArray.position;

			var positionAtEndOfBytecode:int = (byteArray.position + opcodeByteCodeLength);
			try {
				while (byteArray.position < positionAtEndOfBytecode) {
					parseOpcode(byteArray, abcFile, ops, methodBody);
				}
				if (byteArray.position > positionAtEndOfBytecode) {
					throw new Error("Opcode parsing read beyond end of method body");
				}
			} catch (e:*) {
				var pos:int = (byteArray.position - startPosition);
				var fragment:ByteArray = AbcSpec.byteArray();
				fragment.writeBytes(byteArray, startPosition, opcodeByteCodeLength);
				fragment.position = 0;
				errorDispatcher.dispatchEvent(new ByteCodeErrorEvent(ByteCodeErrorEvent.BYTECODE_METHODBODY_ERROR, fragment, pos));
				throw e;
			}
			_opcodePositions = null;
			return ops;
		}

		public static function parseOpcode(byteArray:ByteArray, abcFile:AbcFile, ops:Array, methodBody:MethodBody):void {
			var startPos:int = byteArray.position;
			var opcode:Opcode = determineOpcode(AbcSpec.readU8(byteArray));
			var argumentValues:Array = [];
			for each (var argument:* in opcode.argumentTypes) {
				parseOpcodeArguments(argument, byteArray, argumentValues, abcFile, methodBody);
			}
			var endPos:int = byteArray.position;

			var op:Op = opcode.op(argumentValues);
			ops[ops.length] = op;

			var pos:int;
			if (jumpOpcodes[opcode] == true) {
				if (opcode !== Opcode.lookupswitch) {
					var jumpPos:int = int(op.parameters[0]);
					pos = (endPos + jumpPos);
					if (pos > endPos) {
						if (_jumpLookup[pos] == null) {
							_jumpLookup[pos] = [new JumpTargetData(op, endPos, null)];
						} else {
							var arr:Array = _jumpLookup[pos];
							arr[arr.length] = new JumpTargetData(op, endPos, null);
						}
					} else {
						methodBody.backPatches[methodBody.backPatches.length] = new JumpTargetData(op, endPos, _opcodePositions[endPos], pos);
					}
				} else {
					var newJpd:JumpTargetData = new JumpTargetData(op, endPos, null);
					var positions:Array = (op.parameters[2] as Array);
					for each (var switchPos:int in positions) {
						if (switchPos < 0) {
							pos = (endPos + switchPos);
							newJpd.addTarget(_opcodePositions[endPos], pos);
						} else {
							_jumpLookup[switchPos] = newJpd;
						}
					}
					methodBody.backPatches[methodBody.backPatches.length] = newJpd;
				}
			}
			if (_jumpLookup[startPos] != null) {
				var jumpTargets:Array = _jumpLookup[startPos];
				for each (var jt:JumpTargetData in jumpTargets) {
					if (jt.jumpOpcode.opcode !== Opcode.lookupswitch) {
						jt.targetOpcode = op;
						jt.targetOpcodePosition = startPos;
						methodBody.backPatches[methodBody.backPatches.length] = jt;
					} else {
						jt.addTarget(op, startPos);
					}
				}
				delete _jumpLookup[startPos];
			}
			_opcodePositions[startPos] = op;
			//trace(byteArray.position + "\t" + op);
		}

		public static function parseOpcodeArguments(argument:*, byteArray:ByteArray, argumentValues:Array, abcFile:AbcFile, methodBody:MethodBody):void {
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
					constantPoolValue = abcFile.constantPool.integerPool[byteCodeValue];
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case UnsignedInteger:
					constantPoolValue = abcFile.constantPool.uintPool[byteCodeValue];
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case Number:
					constantPoolValue = abcFile.constantPool.doublePool[byteCodeValue];
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case BaseMultiname:
					constantPoolValue = abcFile.constantPool.multinamePool[byteCodeValue];
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case ClassInfo:
					constantPoolValue = abcFile.classInfo[byteCodeValue];
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case String:
					constantPoolValue = abcFile.constantPool.stringPool[byteCodeValue];
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case LNamespace:
					constantPoolValue = abcFile.constantPool.namespacePool[byteCodeValue];
					Assert.notNull(constantPoolValue, "constantPoolValue value is null");
					argumentValues[argumentValues.length] = constantPoolValue;
					break;

				case Array:
					//TODO: Come back and clean this up with a different parser model. lookupswitch f'd up the clean pre-existing model
					// Special case for lookupswitch opcode. We need to iterate the possible case
					// values and pull their offsets from the bytestream. The first value has
					// already been read for us by the time this switch is invoked, we just need
					// to pull the rest of the offsets. We determine how many there are by looking at
					// the second argument to the op, which is the case_count
					var caseOffsets:Array = [];
					caseOffsets[caseOffsets.length] = byteCodeValue;
					var caseCount:int = argumentValues[1];
					for (var i:int = 0; i < caseCount; ++i) {
						caseOffsets[caseOffsets.length] = AbcSpec.readS24(byteArray);
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

		public static function determineOpcode(opcodeByte:int):Opcode {
			var matchingOpcode:Opcode = _ALL_OPCODES[opcodeByte];

			if (!matchingOpcode) {
				throw new Error("No match for Opcode: 0x" + opcodeByte.toString(16) + " (" + opcodeByte + ")");
			}
			//trace(matchingOpcode);
			return matchingOpcode;
		}

		public function get argumentTypes():Array {
			return _argumentTypes;
		}

		public function get opcodeName():String {
			return _opcodeName;
		}

		public function toString():String {
			return StringUtils.substitute("[Opcode(value={0},name={1})]", _value, _opcodeName);
		}

		public function op(opArguments:Array = null):Op {
			if (opArguments == null) {
				opArguments = [];
			}

			if (opArguments.length != this._argumentTypes.length) {
				throw new Error(this.opcodeName + " requires " + this._argumentTypes.length + " arguments.");
			}

			Op.checkParameters(opArguments, this);

			return new Op(this, opArguments);
		}
	}

}