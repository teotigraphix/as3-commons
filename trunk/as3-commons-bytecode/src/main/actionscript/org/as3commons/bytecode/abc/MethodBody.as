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
package org.as3commons.bytecode.abc {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.util.CloneUtils;

	/**
	 * as3commons-bytecode representation of <code>method_body_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Method body" in the AVM Spec (page 32)
	 */
	public final class MethodBody implements ICloneable, IEquals {
		/**
		 * Containes <code>Opcode</code> instances with appropriate arguments, representing the body of this method.
		 *
		 * @see Opcode
		 * @see Opcode#op()
		 */
		public var opcodes:Vector.<Op>;
		public var rawOpcodes:ByteArray;
		public var methodSignature:MethodInfo;
		public var maxStack:int = 1;
		public var localCount:int = 1;
		public var initScopeDepth:int = 1;
		public var maxScopeDepth:int = 1;
		public var exceptionInfos:Vector.<ExceptionInfo>;
		public var traits:Vector.<TraitInfo>;
		public var jumpTargets:Vector.<JumpTargetData>;
		public var opcodeBaseLocations:Dictionary;

		public function MethodBody() {
			super();
			opcodes = new Vector.<Op>;
			exceptionInfos = new Vector.<ExceptionInfo>();
			traits = new Vector.<TraitInfo>();
		}

		public function addExceptionInfo(exceptionInfo:ExceptionInfo):uint {
			var idx:int = exceptionInfos.indexOf(exceptionInfo);
			if (idx < 0) {
				idx = (exceptionInfos.push(exceptionInfo) - 1);
			}
			return (idx);
		}

		public function toString():String {
			return StringUtils.substitute("\n\t{0}\n\t{\t\n\t\t//maxStack={1}, localCount={2}, initScopeDepth={3}, maxScopeDepth={4}\n\t\t{5}\n\t}\ntraits={6}", methodSignature, maxStack, localCount, initScopeDepth, maxScopeDepth, opcodes.join("\n\t\t"), (traits.length == 0) ? "(no traits)" : ("[\n\t" + traits + "]\n"));
		}

		public function clone():* {
			var clone:MethodBody = new MethodBody();
			clone.opcodes = AbcFileUtil.cloneVector(opcodes);
			if (rawOpcodes != null) {
				clone.rawOpcodes = AbcSpec.newByteArray();
				clone.rawOpcodes.writeBytes(rawOpcodes);
				clone.rawOpcodes.position = 0;
			}
			clone.maxStack = maxStack;
			clone.localCount = localCount;
			clone.initScopeDepth = initScopeDepth;
			clone.maxScopeDepth = maxScopeDepth;
			clone.jumpTargets = new Vector.<JumpTargetData>();
			for each (var op:Op in clone.opcodes) {
				if (op.opcode === Opcode.newcatch) {
					clone.exceptionInfos[clone.exceptionInfos.length] = op.parameters[0];
				}
			}
			var jumpIndex:int;
			var targetIndex:int;
			var targetOp:Op;
			var newJumpTargetData:JumpTargetData;
			for each (var jumpTargetData:JumpTargetData in this.jumpTargets) {
				jumpIndex = this.opcodes.indexOf(jumpTargetData.jumpOpcode);
				targetIndex = this.opcodes.indexOf(jumpTargetData.targetOpcode);
				targetOp = (targetIndex == -1) ? Opcode.END_OF_BODY.op() : clone.opcodes[targetIndex];
				newJumpTargetData = new JumpTargetData(clone.opcodes[jumpIndex], targetOp);
				clone.jumpTargets[clone.jumpTargets.length] = newJumpTargetData;
				for each (op in jumpTargetData.extraOpcodes) {
					newJumpTargetData.addTarget(clone.opcodes[this.opcodes.indexOf(op)]);
				}
			}
			clone.traits = AbcFileUtil.cloneVector(traits);
			return clone;
		}

		public function equals(other:Object):Boolean {
			var otherBody:MethodBody = other as MethodBody;
			if (otherBody != null) {
				var len:int;
				var i:int;
				if (this.initScopeDepth != otherBody.initScopeDepth) {
					return false;
				}
				if (this.localCount != otherBody.localCount) {
					return false;
				}
				if (this.maxScopeDepth != otherBody.maxScopeDepth) {
					return false;
				}
				if (this.maxStack != otherBody.maxStack) {
					return false;
				}
				if (this.traits.length != otherBody.traits.length) {
					return false;
				}
				len = this.traits.length;
				var trait:TraitInfo;
				var otherTrait:TraitInfo;
				for (i = 0; i < len; ++i) {
					trait = this.traits[i];
					otherTrait = otherBody.traits[i];
					if (!trait.equals(otherTrait)) {
						return false;
					}
				}
				if (this.jumpTargets.length != otherBody.jumpTargets.length) {
					return false;
				}
				len = this.jumpTargets.length;
				var len2:int;
				var j:int;
				var target:JumpTargetData;
				var otherTarget:JumpTargetData;
				var op:Op;
				var otherOp:Op;
				for (i = 0; i < len; ++i) {
					target = this.jumpTargets[i];
					otherTarget = otherBody.jumpTargets[i];
					if (target.extraOpcodes != null) {
						if (otherTarget.extraOpcodes == null) {
							return false;
						}
						if (target.extraOpcodes.length != otherTarget.extraOpcodes.length) {
							return false;
						}
						len2 = target.extraOpcodes.length;
						for (j = 0; j < len2; ++j) {
							op = target.extraOpcodes[j];
							otherOp = otherTarget.extraOpcodes[j];
							if (!op.equals(otherOp)) {
								return false;
							}
						}
					}
				}
				len = this.opcodes.length;
				for (i = 0; i < len; ++i) {
					op = opcodes[i];
					otherOp = otherBody.opcodes[i];
					if (!op.equals(otherOp)) {
						op.equals(otherOp);
						return false;
					}
				}
				return true;
			}
			return false;
		}

	}
}
