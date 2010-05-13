/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.emit.bytecode {

	public final class Instructions {
		public static const Add:uint = 0xa0;
		public static const AddInteger:uint = 0xc5;
		public static const AsType:uint = 0x86; // u30 (type_index)
		public static const AsTypeLate:uint = 0x87;
		public static const BitAnd:uint = 0xa8;
		public static const BitNot:uint = 0x97;
		public static const BitOr:uint = 0xa9;
		public static const BitXor:uint = 0xaa;
		public static const Call:uint = 0x41; // u30 (arg_count)
		public static const CallMethod:uint = 0x43; // u30 (index); u30 (arg_count)
		public static const CallProperty:uint = 0x46; // u30 (index); u30 (arg_count)
		public static const CallPropLex:uint = 0x4c; // u30 (index); u30 (arg_count)
		public static const CallPropVoid:uint = 0x4f; // u30 (index); u30 (arg_count)
		public static const CallStatic:uint = 0x44; // u30 (index); u30 (arg_count)
		public static const CallSuper:uint = 0x45; // u30 (index); u30 (arg_count)
		public static const CallSuperVoid:uint = 0x4e; // u30 (index); u30 (arg_count)
		public static const CheckFilter:uint = 0x78;
		public static const Coerce:uint = 0x80; // u30 (index)
		public static const CoerceAny:uint = 0x82; // 
		public static const CoerceString:uint = 0x85;
		public static const Construct:uint = 0x42; // u30 (arg_count)
		public static const ConstructProp:uint = 0x4a; // u30 (index); u30 (arg_count)
		public static const ConstructSuper:uint = 0x49; // u30 (arg_count)
		public static const ConvertBoolean:uint = 0x76;
		public static const ConvertInteer:uint = 0x73;
		public static const ConvertDouble:uint = 0x75;
		public static const ConvertObject:uint = 0x77;
		public static const ConvertUInteger:uint = 0x74;
		public static const ConvertString:uint = 0x70;
		public static const Debug:uint = 0xef; // u8 (DI_LOCAL : uint =  1); u30 (string index); u8 (register); u30 (unused)
		public static const DebugFile:uint = 0xf1; // u8 (string index)
		public static const DebugLine:uint = 0xf0; // u8 (line num)
		public static const DecrementLocal:uint = 0x94; // u8 (register index)
		public static const DecrementLocalInteger:uint = 0xc3; // u8 (register index)
		public static const Decrement:uint = 0x93;
		public static const DecrementInteger:uint = 0xc1;
		public static const DeleteProperty:uint = 0x6a; // u8 (multiname index)
		public static const Divide:uint = 0xa3;
		public static const Duplicate:uint = 0x2a;
		public static const DefaultXMLNamespace:uint = 0x06; // u30 (string index)
		public static const DefaultXMLNamespaceLate:uint = 0x07;
		public static const Equals:uint = 0xab;
		public static const EscapeXmlAttribute:uint = 0x72;
		public static const EscapeXmlElement:uint = 0x71;
		public static const FindProperty:uint = 0x5e; // u30 (multiname index)
		public static const FindPropertyStrict:uint = 0x5d; // u30 (multiname index)
		public static const GetDescendants:uint = 0x59; // u30 (multiname index)
		public static const GetGlobalScope:uint = 0x64;
		public static const GetGlobalSlot:uint = 0x6e; // u30 (slot index)
		public static const GetLex:uint = 0x60; // u30 (multiname index)
		public static const GetLocal:uint = 0x62; // u30 (index)
		public static const GetLocal_0:uint = 0xd0;
		public static const GetLocal_1:uint = 0xd1;
		public static const GetLocal_2:uint = 0xd2;
		public static const GetLocal_3:uint = 0xd3;
		public static const GetProperty:uint = 0x66; // u8 (multiname index)
		public static const GetScopeObject:uint = 0x65; // u8 (index)
		public static const GetSlot:uint = 0x6c; // u8 (index)
		public static const GetSuper:uint = 0x04; // u8 (multiname index)
		public static const GreaterEquals:uint = 0xaf;
		public static const GreaterThan:uint = 0xaf; // ??
		public static const HasNext:uint = 0x1f;
		public static const HasNext2:uint = 0x32; // u8 (object_reg); u8 (index_reg)
		public static const IfEquals:uint = 0x13; // u8 (offset)
		public static const IfFalse:uint = 0x12; // u8 (offset)
		public static const IfGreaterThanOrEquals:uint = 0x18; // u8 (offset)
		public static const IfGreaterThan:uint = 0x17; // u8 (offset)
		public static const IfLessThanOrEquals:uint = 0x16; // u8 (offset)
		public static const IfLessThan:uint = 0x15; // u8 (offset)
		public static const IfNotGreaterThanOrEquals:uint = 0x0f; // u8 (offset)
		public static const IfNotGreaterThan:uint = 0x0e; // u8 (offset)
		public static const IfNotLessThanOrEquals:uint = 0x0d; // u8 (offset)
		public static const IfNotLessThan:uint = 0x0c; // u8 (offset)
		public static const IfNotEquals:uint = 0x14; // u8 (offset)
		public static const IfStrictEquals:uint = 0x19; // u8 (offset)
		public static const IfStrictNotEquals:uint = 0x1a; // u8 (offset)
		public static const IfTrue:uint = 0x11; // u8 (offset)
		public static const In:uint = 0xb4;
		public static const IncrementLocal:uint = 0x92; // u30 (local register)
		public static const IncrementLocalInteger:uint = 0xc2; // u30 (local register)
		public static const Increment:uint = 0x91;
		public static const IncrementInteger:uint = 0xc0;
		public static const InitProperty:uint = 0x68; // u30 (multiname index)
		public static const InstanceOf:uint = 0xb1;
		public static const IsType:uint = 0xb2; // u30 (multiname index)
		public static const IsTypeLate:uint = 0xb3;
		public static const Jump:uint = 0x10; // s24 (offset)
		public static const Kill:uint = 0x05; // u30 (local register)
		public static const Label:uint = 0x09;
		public static const LessThanOrEquals:uint = 0xae;
		public static const LessThan:uint = 0xad;
		public static const LookUpSwitch:uint = 0x1b; // s24 (default_offset); u30 (case_count); s24[case_count] (case_offset)
		public static const LeftShift:uint = 0xa5;
		public static const Modulo:uint = 0xa4;
		public static const Multiply:uint = 0xa2;
		public static const MultiplyInteger:uint = 0xc7;
		public static const Negate:uint = 0x90;
		public static const NegateInteger:uint = 0xc4;
		public static const NewActivation:uint = 0x57;
		public static const NewArray:uint = 0x56; // u30 (arg_count)
		public static const NewCatch:uint = 0x5a; // u30 (exception_info index)
		public static const NewClass:uint = 0x58; // u30 (class info)
		public static const NewFunction:uint = 0x40; // u30 (arg_count)
		public static const NewObject:uint = 0x55;
		public static const NextName:uint = 0x1e;
		public static const NextValue:uint = 0x23;
		public static const Nop:uint = 0x02;
		public static const Not:uint = 0x96;
		public static const Pop:uint = 0x29;
		public static const PopScope:uint = 0x1d;
		public static const PushByte:uint = 0x24; // u8 (byte value)
		public static const PushDouble:uint = 0x2f; // u30 (double index)
		public static const PushFalse:uint = 0x27;
		public static const PushInt:uint = 0x2d; // u30 (int index)
		public static const PushNamespace:uint = 0x31; // u30 (namespace index)
		public static const PushNaN:uint = 0x28;
		public static const PushScope:uint = 0x30;
		public static const PushNull:uint = 0x20;
		public static const PushShort:uint = 0x25; // u30 (short value)
		public static const PushString:uint = 0x2c; // u30 (string value)
		public static const PushTrue:uint = 0x26;
		public static const PushUInt:uint = 0x2e; // u30 (uint value)
		public static const PushUndefined:uint = 0x21;
		public static const PushWith:uint = 0x1c;
		public static const ReturnValue:uint = 0x48;
		public static const ReturnVoid:uint = 0x47;
		public static const RightShift:uint = 0xa6;
		public static const SetLocal:uint = 0x63; // u30 (index)
		public static const SetLocal_0:uint = 0xd4;
		public static const SetLocal_1:uint = 0xd5;
		public static const SetLocal_2:uint = 0xd6;
		public static const SetLocal_3:uint = 0xd7;
		public static const SetGlobalSlot:uint = 0x6f; // u30 (slot index)
		public static const SetProperty:uint = 0x61; // u30 (multiname)
		public static const SetSlot:uint = 0x6d; // u30 (index)
		public static const SetSuper:uint = 0x05; // u30 (multname)
		public static const StrictEquals:uint = 0xac;
		public static const Subtract:uint = 0xa1;
		public static const SubsctractInteger:uint = 0xc6;
		public static const Swap:uint = 0x2b;
		public static const Throw:uint = 0x03;
		public static const TypeOf:uint = 0x95;
		public static const UnsignedRightShift:uint = 0xa7;
	}
}