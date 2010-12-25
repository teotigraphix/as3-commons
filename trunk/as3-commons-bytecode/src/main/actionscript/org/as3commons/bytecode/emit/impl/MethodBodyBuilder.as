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
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.JumpTargetData;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IExceptionInfoBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.asm.Asm;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public class MethodBodyBuilder implements IMethodBodyBuilder {

		/*
		   The stack modifier logic I spied from the excellent AS3Eval library: http://eval.hurlant.com/
		 */
		private static const stackModifiers:Dictionary = new Dictionary();
		private static const ILLEGAL_JUMP_OPCODE_ERROR:String = "{0} is not an opcode that can trigger a jump";
		{
			stackModifiers[Opcode.dup] = 1;
			stackModifiers[Opcode.getglobalscope] = 1;
			stackModifiers[Opcode.getlocal_0] = 1;
			stackModifiers[Opcode.getlocal_1] = 1;
			stackModifiers[Opcode.getlocal_2] = 1;
			stackModifiers[Opcode.getlocal_3] = 1;
			stackModifiers[Opcode.newactivation] = 1;
			stackModifiers[Opcode.pushfalse] = 1;
			stackModifiers[Opcode.pushnan] = 1;
			stackModifiers[Opcode.pushnull] = 1;
			stackModifiers[Opcode.pushtrue] = 1;
			stackModifiers[Opcode.pushundefined] = 1;
			stackModifiers[Opcode.newcatch] = 1;
			stackModifiers[Opcode.getglobalslot] = 1;
			stackModifiers[Opcode.getlex] = 1;
			stackModifiers[Opcode.getscopeobject] = 1;
			stackModifiers[Opcode.newfunction] = 1;
			stackModifiers[Opcode.pushdouble] = 1;
			stackModifiers[Opcode.pushint] = 1;
			stackModifiers[Opcode.pushnamespace] = 1;
			stackModifiers[Opcode.pushshort] = 1;
			stackModifiers[Opcode.pushstring] = 1;
			stackModifiers[Opcode.pushuint] = 1;
			stackModifiers[Opcode.hasnext2] = 1;
			stackModifiers[Opcode.pushbyte] = 1;

			stackModifiers[Opcode.add] = -1;
			stackModifiers[Opcode.add_i] = -1;
			stackModifiers[Opcode.astypelate] = -1;
			stackModifiers[Opcode.bitand] = -1;
			stackModifiers[Opcode.bitor] = -1;
			stackModifiers[Opcode.bitxor] = -1;
			stackModifiers[Opcode.divide] = -1;
			stackModifiers[Opcode.dxnslate] = -1;
			stackModifiers[Opcode.equals] = -1;
			stackModifiers[Opcode.greaterequals] = -1;
			stackModifiers[Opcode.greaterthan] = -1;
			stackModifiers[Opcode.hasnext] = -1;
			stackModifiers[Opcode.in_op] = -1;
			stackModifiers[Opcode.instance_of] = -1;
			stackModifiers[Opcode.istypelate] = -1;
			stackModifiers[Opcode.lessequals] = -1;
			stackModifiers[Opcode.lessthan] = -1;
			stackModifiers[Opcode.lshift] = -1;
			stackModifiers[Opcode.modulo] = -1;
			stackModifiers[Opcode.multiply] = -1;
			stackModifiers[Opcode.multiply_i] = -1;
			stackModifiers[Opcode.nextname] = -1;
			stackModifiers[Opcode.nextvalue] = -1;
			stackModifiers[Opcode.pop] = -1;
			stackModifiers[Opcode.pushscope] = -1;
			stackModifiers[Opcode.pushwith] = -1;
			stackModifiers[Opcode.returnvalue] = -1;
			stackModifiers[Opcode.rshift] = -1;
			stackModifiers[Opcode.setlocal_0] = -1;
			stackModifiers[Opcode.setlocal_1] = -1;
			stackModifiers[Opcode.setlocal_2] = -1;
			stackModifiers[Opcode.setlocal_3] = -1;
			stackModifiers[Opcode.strictequals] = -1;
			stackModifiers[Opcode.subtract] = -1;
			stackModifiers[Opcode.subtract_i] = -1;
			stackModifiers[Opcode.throw_op] = -1;
			stackModifiers[Opcode.urshift] = -1;
			stackModifiers[Opcode.setglobalslot] = -1;
			stackModifiers[Opcode.iffalse] = -1;
			stackModifiers[Opcode.iftrue] = -1;
			stackModifiers[Opcode.lookupswitch] = -1;

			stackModifiers[Opcode.ifeq] = -2;
			stackModifiers[Opcode.ifge] = -2;
			stackModifiers[Opcode.ifgt] = -2;
			stackModifiers[Opcode.ifle] = -2;
			stackModifiers[Opcode.iflt] = -2;
			stackModifiers[Opcode.ifne] = -2;
			stackModifiers[Opcode.ifnge] = -2;
			stackModifiers[Opcode.ifngt] = -2;
			stackModifiers[Opcode.ifnle] = -2;
			stackModifiers[Opcode.ifnlt] = -2;
			stackModifiers[Opcode.ifstricteq] = -2;
			stackModifiers[Opcode.ifstrictne] = -2;
			stackModifiers[Opcode.setslot] = -2;
		}

		private var _opcodes:Array = [];
		private var _backpatches:Array = [];
		private var _exceptionInfos:Array = [];
		private var _traits:Array = [];
		private var _currentStack:int = 0;
		private var _maxStack:int = 0;
		private var _currentScope:int = 0;
		private var _maxScope:int = 0;
		private var _hasDXNS:Boolean = false;
		private var _needActivation:Boolean = false;
		private var _needArguments:Boolean = false;
		private var _jumpDataLookup:Dictionary = new Dictionary();
		private var _asm:Asm;
		private var _methodBody:MethodBody;

		public function MethodBodyBuilder() {
			super();
		}

		as3commons_bytecode function setMethodBody(methodBody:MethodBody):void {
			Assert.notNull(methodBody, "methodBody argument must not be null");
			_methodBody = methodBody;
			_opcodes = _methodBody.opcodes.concat([]);
			_exceptionInfos = _methodBody.exceptionInfos.concat([]);
			_traits = _methodBody.traits.concat([]);
			_maxStack = _methodBody.maxStack;
			_maxScope = _methodBody.maxScopeDepth;
		}

		public function get setDXNS():Boolean {
			return _hasDXNS;
		}

		public function get needActivation():Boolean {
			return _needActivation;
		}

		public function get needArguments():Boolean {
			return _needArguments;
		}

		public function get opcodes():Array {
			return _opcodes;
		}

		public function set opcodes(value:Array):void {
			_opcodes = value;
		}

		public function get exceptionInfos():Array {
			return _exceptionInfos;
		}

		public function set exceptionInfos(value:Array):void {
			_exceptionInfos = value;
		}

		public function defineExceptionInfo():IExceptionInfoBuilder {
			var eib:ExceptionInfoBuilder = new ExceptionInfoBuilder();
			_exceptionInfos[_exceptionInfos.length] = eib;
			return eib;
		}

		public function buildBody(initScopeDepth:uint = 1, extraLocalCount:uint = 0):MethodBody {
			_currentStack = 0;
			_maxStack = 0;
			_currentScope = initScopeDepth;
			_maxScope = 0;
			var mb:MethodBody = (_methodBody != null) ? _methodBody : new MethodBody();
			mb.backPatches = [];
			mb.localCount += extraLocalCount;
			mb.initScopeDepth = initScopeDepth;
			mb.opcodes = _opcodes.concat([]);
			mb.exceptionInfos = _exceptionInfos.concat([]);
			mb.traits = _traits.concat([]);
			analyzeOpcodes(mb);
			mb.maxStack = _maxStack;
			mb.maxScopeDepth = _maxScope;
			mb.backPatches = _backpatches.concat([]);
			return mb;
		}

		protected function get asm():Asm {
			if (_asm == null) {
				_asm = new Asm();
			}
			return _asm;
		}

		protected function analyzeOpcodes(methodBody:MethodBody):void {
			for each (var op:Op in _opcodes) {
				if (stackModifiers[op.opcode] != null) {
					stack(stackModifiers[op.opcode]);
				}
				switch (op.opcode) {
					case Opcode.dxns:
						_hasDXNS = true;
						break;
					case Opcode.newactivation:
						_needActivation = true;
						break;
					case Opcode.label:
						break;
					case Opcode.pushscope:
					case Opcode.pushwith:
						scope(1);
						break;
					case Opcode.call:
						stack(1 - (op.parameters[0] + 2));
						break;
					case Opcode.construct:
					case Opcode.callmethod:
					case Opcode.callstatic:
						stack(1 - (op.parameters[1] + 1));
						break;
					case Opcode.constructsuper:
						stack(op.parameters[0] + 1);
						break;
					case Opcode.findproperty:
					case Opcode.findpropstrict:
						stack(1 - (0 + (hasRuntimeNamespace(op.parameters[0]) ? 1 : 0)) + (hasRuntimeMultiname(op.parameters[0]) ? 1 : 0));
						break;
					case Opcode.deleteproperty:
					case Opcode.getdescendants:
					case Opcode.getproperty:
					case Opcode.getsuper:
						stack(1 - (1 + (hasRuntimeNamespace(op.parameters[0]) ? 1 : 0)) + (hasRuntimeMultiname(op.parameters[0]) ? 1 : 0));
						break;
					case Opcode.initproperty:
					case Opcode.setproperty:
					case Opcode.setsuper:
						stack(0 - (2 + (hasRuntimeNamespace(op.parameters[0]) ? 1 : 0)) + (hasRuntimeMultiname(op.parameters[0]) ? 1 : 0));
						break;
					case Opcode.callsuper:
					case Opcode.callproperty:
					case Opcode.constructprop:
					case Opcode.callproplex:
						stack(1 - (1 + (hasRuntimeNamespace(op.parameters[0]) ? 1 : 0) + (hasRuntimeMultiname(op.parameters[0]) ? 1 : 0) + op.parameters[1]));
						break;
					case Opcode.callsupervoid:
					case Opcode.callpropvoid:
						stack(0 - (1 + (hasRuntimeNamespace(op.parameters[0]) ? 1 : 0) + (hasRuntimeMultiname(op.parameters[0]) ? 1 : 0) + op.parameters[1]));
						break;
					case Opcode.newarray:
						stack(1 - op.parameters[0]);
						break;
					case Opcode.newobject:
						stack(1 - (2 * op.parameters[0]));
						break;
				}
			}
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

		/**
		 * @inheritDoc
		 */
		public function addOpcode(opcode:Opcode, params:Array = null):IMethodBodyBuilder {
			_opcodes[opcodes.length] = new Op(opcode, params);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addOp(opcode:Op):IMethodBodyBuilder {
			_opcodes[opcodes.length] = opcode;
			return this;
		}


		/**
		 * @inheritDoc
		 */
		public function addAsmSource(source:String):IMethodBodyBuilder {
			Assert.hasText(source, "source argument must not be empty or null");
			var result:Array = asm.parseAndConvert(source);
			addOpcodes(result[0]);
			return addBackPatches(result[1]);
		}

		/**
		 * @inheritDoc
		 */
		public function defineJump(triggerOpcode:Op, targetOpcode:Op, isDefault:Boolean = false):IMethodBodyBuilder {
			if (Opcode.jumpOpcodes[triggerOpcode.opcode] == null) {
				throw new IllegalOperationError(StringUtils.substitute(ILLEGAL_JUMP_OPCODE_ERROR, triggerOpcode.opcode));
			}
			if (_opcodes.indexOf(targetOpcode) < 0) {
				_opcodes[opcodes.length] = targetOpcode;
			}
			if (_opcodes.indexOf(triggerOpcode) < 0) {
				_opcodes[opcodes.length] = triggerOpcode;
			}
			var jpd:JumpTargetData;
			if (_jumpDataLookup[triggerOpcode] == null) {
				jpd = new JumpTargetData(triggerOpcode, targetOpcode);
				_backpatches[_backpatches.length] = jpd;
			} else {
				jpd = _jumpDataLookup[triggerOpcode];
				jpd.addTarget(targetOpcode);
			}
			return this;
		}

		public function addOpcodes(newOpcodes:Array):IMethodBodyBuilder {
			_opcodes = _opcodes.concat(newOpcodes);
			return this;
		}

		public function addBackPatches(newBackpatches:Array):IMethodBodyBuilder {
			_backpatches = _backpatches.concat(newBackpatches);
			return this;
		}

		private function stack(n:int):void {
			_currentStack += n;
			if (_currentStack > _maxStack) {
				_maxStack = _currentStack;
			}
		}

		private function scope(n:int):void {
			_currentScope += n;
			if (_currentScope > _maxScope) {
				_maxScope = _currentScope;
			}
		}

	}
}