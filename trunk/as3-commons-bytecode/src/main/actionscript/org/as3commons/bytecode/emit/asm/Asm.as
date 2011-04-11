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
package org.as3commons.bytecode.emit.asm {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.JumpTargetData;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public class Asm {

		private const _parseSequence:Array = [whitespace, instruction, whitespace, operands];
		private static const SINGLE_SPACE:String = ' ';
		private static const INCORRECT_OPERAND_COUNT_ERROR:String = "{0} has incorrect number of operands, expected {1}, got {2}";
		private static const INSTRUCTION_REGEXP:RegExp = /\t|\s|\n|\r/;
		private static const WHITESPACE_REGEXP:RegExp = /\t| /;
		private static const NEXT_INSTRUCTION_REGEXP:RegExp = /\n|\r/;
		private static const OPERAND_REGEXP:RegExp = /\n|\r/;
		private static const EMPTY_STRING:String = '';
		private static const UNRESOLVED_LABEL_NAME_ERROR:String = "label '{0}' could not be resolved";

		private var _currentToken:Array = [];
		private var _tokens:Array = [];
		private var _currentMethod:Function;
		private var _currentIndex:int = 0;
		private var _methodIndex:int;
		private var _labelLookup:Dictionary;

		private var _params:Dictionary = new Dictionary();

		public function Asm() {
			super();
			init();
		}

		protected function init():void {
			_params[Opcode.add] = [];
			_params[Opcode.add_d] = [];
			_params[Opcode.add_i] = [];
			_params[Opcode.applytype] = [addParameter];
			_params[Opcode.astype] = [addMultinameParameter];
			_params[Opcode.astypelate] = [];
			_params[Opcode.bitand] = [];
			_params[Opcode.bitnot] = [];
			_params[Opcode.bitor] = [];
			_params[Opcode.bitxor] = [];
			_params[Opcode.bkpt] = [];
			_params[Opcode.bkptline] = [addParameter];
			_params[Opcode.call] = [addParameter];
			_params[Opcode.callinterface] = [addMultinameParameter, addParameter];
			_params[Opcode.callmethod] = [addParameter, addParameter];
			_params[Opcode.callproperty] = [addMultinameParameter, addParameter];
			_params[Opcode.callproplex] = [addMultinameParameter, addParameter];
			_params[Opcode.callpropvoid] = [addMultinameParameter, addParameter];
			_params[Opcode.callstatic] = [addParameter, addParameter];
			_params[Opcode.callsuper] = [addMultinameParameter, addParameter];
			_params[Opcode.callsuperid] = [];
			_params[Opcode.callsupervoid] = [addMultinameParameter, addParameter];
			_params[Opcode.checkfilter] = [];
			_params[Opcode.coerce] = [addMultinameParameter];
			_params[Opcode.coerce_a] = [];
			_params[Opcode.coerce_b] = [];
			_params[Opcode.coerce_d] = [];
			_params[Opcode.coerce_i] = [];
			_params[Opcode.coerce_o] = [];
			_params[Opcode.coerce_s] = [];
			_params[Opcode.coerce_u] = [];
			_params[Opcode.concat] = [];
			_params[Opcode.construct] = [addParameter];
			_params[Opcode.constructprop] = [addMultinameParameter, addParameter];
			_params[Opcode.constructsuper] = [addParameter];
			_params[Opcode.convert_b] = [];
			_params[Opcode.convert_d] = [];
			_params[Opcode.convert_i] = [];
			_params[Opcode.convert_o] = [];
			_params[Opcode.convert_s] = [];
			_params[Opcode.convert_u] = [];
			_params[Opcode.debug] = [addParameter, addParameter, addParameter, addParameter];
			_params[Opcode.debugfile] = [addParameter];
			_params[Opcode.debugline] = [addParameter];
			_params[Opcode.declocal] = [addParameter];
			_params[Opcode.declocal_i] = [addParameter];
			_params[Opcode.decrement] = [];
			_params[Opcode.decrement_i] = [];
			_params[Opcode.deleteproperty] = [addMultinameParameter];
			_params[Opcode.deletepropertylate] = [];
			_params[Opcode.divide] = [];
			_params[Opcode.dup] = [];
			_params[Opcode.dxns] = [addParameter];
			_params[Opcode.dxnslate] = [];
			_params[Opcode.equals] = [];
			_params[Opcode.esc_xattr] = [];
			_params[Opcode.esc_xelem] = [];
			_params[Opcode.finddef] = [addMultinameParameter];
			_params[Opcode.findpropglobalstrict] = [addMultinameParameter];
			_params[Opcode.findpropglobal] = [addMultinameParameter];
			_params[Opcode.findproperty] = [addMultinameParameter];
			_params[Opcode.findpropstrict] = [addMultinameParameter];
			_params[Opcode.getdescendants] = [addMultinameParameter];
			_params[Opcode.getglobalscope] = [];
			_params[Opcode.getglobalslot] = [addParameter];
			_params[Opcode.getlex] = [addMultinameParameter];
			_params[Opcode.getlocal] = [addParameter];
			_params[Opcode.getlocal_0] = [];
			_params[Opcode.getlocal_1] = [];
			_params[Opcode.getlocal_2] = [];
			_params[Opcode.getlocal_3] = [];
			_params[Opcode.getouterscope] = [addMultinameParameter];
			_params[Opcode.getproperty] = [addMultinameParameter];
			_params[Opcode.getscopeobject] = [addParameter];
			_params[Opcode.getslot] = [addParameter];
			_params[Opcode.getsuper] = [addMultinameParameter];
			_params[Opcode.greaterequals] = [];
			_params[Opcode.greaterthan] = [];
			_params[Opcode.hasnext2] = [addParameter, addParameter];
			_params[Opcode.hasnext] = [];
			_params[Opcode.ifeq] = [addJump];
			_params[Opcode.iffalse] = [addJump];
			_params[Opcode.ifge] = [addJump];
			_params[Opcode.ifgt] = [addJump];
			_params[Opcode.ifle] = [addJump];
			_params[Opcode.iflt] = [addJump];
			_params[Opcode.ifne] = [addJump];
			_params[Opcode.ifnge] = [addJump];
			_params[Opcode.ifnle] = [addJump];
			_params[Opcode.ifnlt] = [addJump];
			_params[Opcode.ifngt] = [addJump];
			_params[Opcode.ifstricteq] = [addJump];
			_params[Opcode.ifstrictne] = [addJump];
			_params[Opcode.iftrue] = [addJump];
			_params[Opcode.in_op] = [];
			_params[Opcode.inclocal] = [addParameter];
			_params[Opcode.inclocal_i] = [addParameter];
			_params[Opcode.increment] = [];
			_params[Opcode.increment_i] = [];
			_params[Opcode.initproperty] = [addMultinameParameter];
			_params[Opcode.instance_of] = [];
			_params[Opcode.istype] = [addMultinameParameter];
			_params[Opcode.istypelate] = [];
			_params[Opcode.jump] = [addJump];
			_params[Opcode.kill] = [addParameter];
			_params[Opcode.label] = [];
			_params[Opcode.lessequals] = [];
			_params[Opcode.lessthan] = [];
			_params[Opcode.lookupswitch] = [addSwitchJumps];
			_params[Opcode.lshift] = [];
			_params[Opcode.modulo] = [];
			_params[Opcode.multiply] = [];
			_params[Opcode.multiply_i] = [];
			_params[Opcode.negate] = [];
			_params[Opcode.negate_i] = [];
			_params[Opcode.newactivation] = [];
			_params[Opcode.newarray] = [addParameter];
			_params[Opcode.newcatch] = [addExceptionInfo];
			_params[Opcode.newclass] = [addClassInfo];
			_params[Opcode.newfunction] = [addParameter];
			_params[Opcode.newobject] = [addParameter];
			_params[Opcode.nextname] = [];
			_params[Opcode.nextvalue] = [];
			_params[Opcode.nop] = [];
			_params[Opcode.not] = [];
			_params[Opcode.pop] = [];
			_params[Opcode.popscope] = [];
			_params[Opcode.pushbyte] = [addParameter];
			_params[Opcode.pushconstant] = [addParameter];
			_params[Opcode.pushdouble] = [addParameter];
			_params[Opcode.pushfalse] = [];
			_params[Opcode.pushint] = [addParameter];
			_params[Opcode.pushnamespace] = [addNamespace];
			_params[Opcode.pushnan] = [];
			_params[Opcode.pushnull] = [];
			_params[Opcode.pushscope] = [];
			_params[Opcode.pushshort] = [addParameter];
			_params[Opcode.pushstring] = [addParameter];
			_params[Opcode.pushtrue] = [];
			_params[Opcode.pushuint] = [addParameter];
			_params[Opcode.pushundefined] = [];
			_params[Opcode.pushwith] = [];
			_params[Opcode.returnvalue] = [];
			_params[Opcode.returnvoid] = [];
			_params[Opcode.rshift] = [];
			_params[Opcode.setglobalslot] = [addParameter];
			_params[Opcode.setlocal] = [addParameter];
			_params[Opcode.setlocal_0] = [];
			_params[Opcode.setlocal_1] = [];
			_params[Opcode.setlocal_2] = [];
			_params[Opcode.setlocal_3] = [];
			_params[Opcode.setproperty] = [addMultinameParameter];
			_params[Opcode.setpropertylate] = [];
			_params[Opcode.setslot] = [addParameter];
			_params[Opcode.setsuper] = [addMultinameParameter];
			_params[Opcode.strictequals] = [];
			_params[Opcode.subtract] = [];
			_params[Opcode.subtract_i] = [];
			_params[Opcode.swap] = [];
			_params[Opcode.throw_op] = [];
			_params[Opcode.typeof_op] = [];
			_params[Opcode.urshift] = [];
		}

		public function parseAndConvert(source:String):Array {
			var tokens:Array = parse(source);
			return convert(tokens);
		}

		public function convert(tokens:Array):Array {
			_labelLookup = new Dictionary();
			var opcodes:Array = [];
			var backpatches:Array = [];
			var result:Array = [opcodes, backpatches];
			var currentOp:Op;
			var currentParameterMethods:Array;
			var labelNameLookup:Dictionary = new Dictionary();
			for each (var token:AsmToken in tokens) {
				switch (token.kind) {
					case TokenKind.INSTRUCTION:
						currentOp = Opcode.fromName(token.value).op();
						opcodes[opcodes.length] = currentOp;
						currentParameterMethods = _params[currentOp.opcode];
						break;
					case TokenKind.LABEL:
						currentOp = Opcode.label.op();
						opcodes[opcodes.length] = currentOp;
						var lbl:String = token.value.substring(0, token.value.length - 1);
						labelNameLookup[lbl] = currentOp;
						break;
					default:
						var rawParams:Array = token.value.split(SINGLE_SPACE);
						Assert.isTrue(currentParameterMethods.length == rawParams.length, StringUtils.substitute(INCORRECT_OPERAND_COUNT_ERROR, currentOp, currentParameterMethods.length, rawParams.length));
						var len:int = rawParams.length;
						for (var i:int = 0; i < len; ++i) {
							currentParameterMethods[i](currentOp, rawParams[i]);
						}
						break;
				}
			}
			for (var name:String in _labelLookup) {
				var jumpCodes:Array = _labelLookup[name];
				var labelOp:Op = labelNameLookup[name];
				Assert.notNull(labelOp, StringUtils.substitute(UNRESOLVED_LABEL_NAME_ERROR, name));
				for each (var op:Op in jumpCodes) {
					var existingJmp:JumpTargetData = null;
					for each (var jmp:JumpTargetData in backpatches) {
						if (jmp.jumpOpcode === op) {
							existingJmp = jmp;
							break;
						}
					}
					if (existingJmp == null) {
						backpatches[backpatches.length] = new JumpTargetData(op, labelOp);
					} else {
						existingJmp.addTarget(labelOp);
					}
				}
			}
			return result;
		}

		public function parse(input:String):Array {
			_tokens = [];
			_currentToken = [];
			var idx:int = 0;
			_methodIndex = 0;
			_currentMethod = _parseSequence[_methodIndex];
			while (idx < input.length) {
				if (!_currentMethod(input.charAt(idx))) {
					_methodIndex++;
					if (_methodIndex == _parseSequence.length) {
						_methodIndex = 0;
					}
					_currentMethod = _parseSequence[_methodIndex];
				} else {
					idx++;
				}
			}
			if (_currentToken.length > 0) {
				if (_currentMethod === instruction) {
					createInstructionOrLabelToken();
				} else if (_currentMethod === operands) {
					createOperandToken();
				}
			}
			return _tokens;
		}

		public function instruction(char:String):Boolean {
			if (char.match(INSTRUCTION_REGEXP) == null) {
				_currentToken[_currentToken.length] = char;
				return true;
			}
			createInstructionOrLabelToken();
			return false;
		}

		protected function createInstructionOrLabelToken():void {
			var value:String = _currentToken.join(EMPTY_STRING);
			var kind:TokenKind = (value.charAt(value.length - 1) == ':') ? TokenKind.LABEL : TokenKind.INSTRUCTION;
			_tokens[_tokens.length] = new AsmToken(value, kind);
			_currentToken = [];
		}

		public function whitespace(char:String):Boolean {
			if (char.match(WHITESPACE_REGEXP) != null) {
				return true;
			} else if (char.match(NEXT_INSTRUCTION_REGEXP) != null) {
				_methodIndex = 0;
				return true;
			}
			return false;
		}

		public function operands(char:String):Boolean {
			if (char.match(OPERAND_REGEXP) == null) {
				_currentToken[_currentToken.length] = char;
				return true;
			}
			createOperandToken();
			return false;
		}

		protected function createOperandToken():void {
			_tokens[_tokens.length] = new AsmToken(_currentToken.join(EMPTY_STRING), TokenKind.OPERAND);
			_currentToken = [];
		}

		protected function addParameter(op:Op, parameter:*):void {
			Assert.notNull(op, "op argument must not be null");
			op.parameters[op.parameters.length] = parameter;
		}

		protected function addMultinameParameter(op:Op, multiNameString:String):void {
			Assert.notNull(op, "op argument must not be null");
			Assert.hasText(multiNameString, "multiNameString must not be empty or null");
			var bm:BaseMultiname = MultinameUtil.toArgumentMultiName(multiNameString);
			op.parameters[op.parameters.length] = bm;
		}

		protected function addSwitchJumps(op:Op, params:Array):void {
			Assert.notNull(op, "op argument must not be null");
			addJump(op, params.shift());
			op.parameters[op.parameters.length] = params.length;
			var len:int = params.length;
			for (var i:int = 0; i < len; ++i) {
				addlabelLookup(op, params[i]);
				params[i] = 0;
			}
			op.parameters[op.parameters.length] = params;
		}

		protected function addClassInfo(op:Op, classInfoString:String):void {
			Assert.notNull(op, "op argument must not be null");
			var qualifiedName:QualifiedName = MultinameUtil.toQualifiedName(classInfoString);
			op.parameters[op.parameters.length] = new ClassInfoReference(qualifiedName);
		}

		protected function addExceptionInfo(op:Op, exceptionInfoString:String):void {
			Assert.notNull(op, "op argument must not be null");
			op.parameters[op.parameters.length] = exceptionInfoString;
		}

		protected function addNamespace(op:Op, namespaceString:String):void {
			Assert.notNull(op, "op argument must not be null");
			var parts:Array = namespaceString.split(':');
			if (parts[0].length == 0) {
				parts[0] = NamespaceKind.PACKAGE_NAMESPACE.description;
			}
			var ns:LNamespace = MultinameUtil.toLNamespace(String(parts[1]), NamespaceKind.determineKindByName(String(parts[0])));
			op.parameters[op.parameters.length] = ns;
		}

		protected function addJump(op:Op, labelName:String):void {
			//In praise of Iron Maiden's excellent album:
			op.parameters[op.parameters.length] = 666;
			addlabelLookup(op, labelName);
		}

		protected function addlabelLookup(op:Op, labelName:String):void {
			if (_labelLookup[labelName] == null) {
				_labelLookup[labelName] = [];
			}
			var arr:Array = _labelLookup[labelName];
			arr[arr.length] = op;
		}
	}
}