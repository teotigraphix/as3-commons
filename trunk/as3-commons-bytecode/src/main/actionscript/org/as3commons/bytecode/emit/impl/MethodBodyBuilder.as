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
package org.as3commons.bytecode.emit.impl {
import flash.utils.Dictionary;

import org.as3commons.bytecode.abc.BaseMultiname;
import org.as3commons.bytecode.abc.MethodBody;
import org.as3commons.bytecode.abc.Op;
import org.as3commons.bytecode.abc.enum.MultinameKind;
import org.as3commons.bytecode.emit.IExceptionInfoBuilder;
import org.as3commons.bytecode.emit.IMethodBodyBuilder;

public class MethodBodyBuilder implements IMethodBodyBuilder {


	/*
	The stack modifier logic I spied from the excellent AS3Eval library: http://eval.hurlant.com/
	 */
	private static const stackModifiers:Dictionary = new Dictionary();
	{
		stackModifiers["dup"] = 1;
		stackModifiers["getglobalscope"] = 1;
		stackModifiers["getlocal_0"] = 1;
		stackModifiers["getlocal_1"] = 1;
		stackModifiers["getlocal_2"] = 1;
		stackModifiers["getlocal_3"] = 1;
		stackModifiers["newactivation"] = 1;
		stackModifiers["pushfalse"] = 1;
		stackModifiers["pushnan"] = 1;
		stackModifiers["pushnull"] = 1;
		stackModifiers["pushtrue"] = 1;
		stackModifiers["pushundefined"] = 1;
		stackModifiers["newcatch"] = 1;
		stackModifiers["getglobalslot"] = 1;
		stackModifiers["getlex"] = 1;
		stackModifiers["getscopeobject"] = 1;
		stackModifiers["newfunction"] = 1;
		stackModifiers["pushdouble"] = 1;
		stackModifiers["pushint"] = 1;
		stackModifiers["pushnamespace"] = 1;
		stackModifiers["pushshort"] = 1;
		stackModifiers["pushstring"] = 1;
		stackModifiers["pushuint"] = 1;
		stackModifiers["hasnext2"] = 1;
		stackModifiers["pushbyte"] = 1;

		stackModifiers["add"] = -1;
		stackModifiers["add_i"] = -1;
		stackModifiers["astypelate"] = -1;
		stackModifiers["bitand"] = -1;
		stackModifiers["bitor"] = -1;
		stackModifiers["bitxor"] = -1;
		stackModifiers["divide"] = -1;
		stackModifiers["dxnslate"] = -1;
		stackModifiers["Equals"] = -1;
		stackModifiers["greaterequals"] = -1;
		stackModifiers["greaterthan"] = -1;
		stackModifiers["hasnext"] = -1;
		stackModifiers["in"] = -1;
		stackModifiers["instanceof"] = -1;
		stackModifiers["istypelate"] = -1;
		stackModifiers["lessequals"] = -1;
		stackModifiers["lessthan"] = -1;
		stackModifiers["lshift"] = -1;
		stackModifiers["modulo"] = -1;
		stackModifiers["multiply"] = -1;
		stackModifiers["multiply_i"] = -1;
		stackModifiers["nextname"] = -1;
		stackModifiers["nextvalue"] = -1;
		stackModifiers["pop"] = -1;
		stackModifiers["pushscope"] = -1;
		stackModifiers["pushwith"] = -1;
		stackModifiers["returnvalue"] = -1;
		stackModifiers["rshift"] = -1;
		stackModifiers["setlocal_0"] = -1;
		stackModifiers["setlocal_1"] = -1;
		stackModifiers["setlocal_2"] = -1;
		stackModifiers["setlocal_3"] = -1;
		stackModifiers["strictequals"] = -1;
		stackModifiers["subtract"] = -1;
		stackModifiers["subtract_i"] = -1;
		stackModifiers["throw"] = -1;
		stackModifiers["urshift"] = -1;
		stackModifiers["setglobalslot"] = -1;
		stackModifiers["iffalse"] = -1;
		stackModifiers["iftrue"] = -1;

		stackModifiers["ifeq"] = -2;
		stackModifiers["ifge"] = -2;
		stackModifiers["ifgt"] = -2;
		stackModifiers["ifle"] = -2;
		stackModifiers["iflt"] = -2;
		stackModifiers["ifne"] = -2;
		stackModifiers["ifnge"] = -2;
		stackModifiers["ifngt"] = -2;
		stackModifiers["ifnle"] = -2;
		stackModifiers["ifnlt"] = -2;
		stackModifiers["ifstricteq"] = -2;
		stackModifiers["ifstrictne"] = -2;
		stackModifiers["setslot"] = -2;
	}

	private var _opcodes:Array = [];
	private var _exceptionInfos:Array = [];
	private var _traits:Array = [];
	private var _hasDXNS:Boolean;
	private var _hasNewActivation:Boolean;

	public function MethodBodyBuilder() {
		super();
	}

	public function get opcodes():Array {
		return _opcodes;
	}

	public function set opcodes(value:Array):void {
		_opcodes = value;
	}

	public function defineExceptionInfo():IExceptionInfoBuilder {
		var eib:ExceptionInfoBuilder = new ExceptionInfoBuilder();
		_exceptionInfos[_exceptionInfos.length] = eib;
		return eib;
	}

	public function build():MethodBody {
		var mb:MethodBody = new MethodBody();
		mb.opcodes = _opcodes.concat([]);
		mb.exceptionInfos = _exceptionInfos.concat([]);
		mb.traits = _traits.concat([]);
		for each(var op:Op in _opcodes) {
			if (stackModifiers[op.opcode.opcodeName] != null) {
				mb.maxStack += stackModifiers[op.opcode.opcodeName];
			}
			switch (op.opcode.opcodeName) {
				case  "pushscope":
				case "pushwith":
					mb.maxScopeDepth++;
					break;
				case "popscope":
					mb.maxScopeDepth--;
					break;
				case "dxns":
					hasDXNS = true;
					break;
				case "newactivation":
					hasNewActivation = true;
					break;
				case "call":
					mb.maxStack = 1 - op.parameters[0] + 2;
					break;
				case "construct":
				case "callmethod":
				case "callstatic":
					mb.maxStack = 1 - op.parameters[1] + 1;
					break;
				case "constructsuper":
					mb.maxStack = op.parameters[0] + 1;
					break;
				case "findproperty":
				case "findpropstrict":
					if (hasRuntimeNamespace(op.parameters[0])) {
						mb.maxStack++;
					}
					if (hasRuntimeMultiname(op.parameters[0])) {
						mb.maxStack++;
					}
					mb.maxStack++;
					break;
				case "deleteproperty":
				case "getdescendants":
				case "getproperty":
				case "getsuper":
				case "initproperty":
				case "setproperty":
				case "setsuper":
					if (hasRuntimeNamespace(op.parameters[0])) {
						mb.maxStack++;
					}
					if (hasRuntimeMultiname(op.parameters[0])) {
						mb.maxStack++;
					}
					mb.maxStack += 2;
					break;
				case "callsuper":
				case "callproperty":
				case "constructprop":
				case "callproplex":
					if (hasRuntimeNamespace(op.parameters[0])) {
						mb.maxStack++;
					}
					if (hasRuntimeMultiname(op.parameters[0])) {
						mb.maxStack++;
					}
					mb.maxStack += op.parameters[1];
					break;
				case "callsupervoid":
				case "callpropvoid":
					if (hasRuntimeNamespace(op.parameters[0])) {
						mb.maxStack++;
					}
					if (hasRuntimeMultiname(op.parameters[0])) {
						mb.maxStack++;
					}
					mb.maxStack += op.parameters[1] + 1;
					break;
				case "newarray":
					mb.maxStack += (1 - op.parameters[0]);
					break;
				case "newobject":
					mb.maxStack += (1 - (2*op.parameters[0]));
					break;
			}
		}
		return mb;
	}

	private function hasRuntimeMultiname(baseMultiname:BaseMultiname):Boolean {
		switch (baseMultiname.kind) {
			case MultinameKind.RTQNAME_L:
			case MultinameKind.RTQNAME_LA:
			case MultinameKind.MULTINAME_L:
			case MultinameKind.MULTINAME_LA:
				return true;
				break;
		}
		return false;
	}

	private function hasRuntimeNamespace(baseMultiname:BaseMultiname):Boolean {
		switch (baseMultiname.kind) {
			case MultinameKind.RTQNAME:
			case MultinameKind.RTQNAME_A:
			case MultinameKind.RTQNAME_L:
			case MultinameKind.RTQNAME_LA:
				return true;
				break;
		}
		return false;
	}

	public function get hasDXNS():Boolean {
		return _hasDXNS;
	}

	public function set hasDXNS(value:Boolean):void {
		_hasDXNS = value;
	}

	public function get hasNewActivation():Boolean {
		return _hasNewActivation;
	}

	public function set hasNewActivation(value:Boolean):void {
		_hasNewActivation = value;
	}

}
}