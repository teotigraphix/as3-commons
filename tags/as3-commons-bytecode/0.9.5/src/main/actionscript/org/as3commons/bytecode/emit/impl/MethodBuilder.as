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
package org.as3commons.bytecode.emit.impl {
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IExceptionInfoBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.typeinfo.Argument;
	import org.as3commons.bytecode.util.EmitUtil;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public class MethodBuilder extends EmitMember implements IMethodBuilder {

		public static const METHOD_NAME:String = "{0}/{1}{2}";

		private var _returnType:String = BuiltIns.VOID.fullName;
		private var _arguments:Array = [];
		private var _methodBodyBuilder:IMethodBodyBuilder;
		private var _hasRestArguments:Boolean;
		protected var methodInfo:MethodInfo;

		public function MethodBuilder(name:String = null, visibility:MemberVisibility = null, nameSpace:String = null) {
			super(name, visibility, nameSpace);
		}

		as3commons_bytecode function setMethodInfo(methodInfo:MethodInfo):void {
			Assert.notNull(methodInfo, "methodInfo argument must not be null");
			this.methodInfo = methodInfo;
			var parts:Array = this.methodInfo.methodName.split('/');
			name = parts[1];
			packageName = parts[0];
			if (methodInfo.returnType != null) {
				_returnType = QualifiedName(methodInfo.returnType).fullName;
			}
			_hasRestArguments = MethodFlag.flagPresent(methodInfo.flags, MethodFlag.NEED_REST);
			if (methodInfo.methodBody != null) {
				methodBodyBuilder.as3commons_bytecode::setMethodBody(methodInfo.methodBody);
			}
			visibility = EmitUtil.getMemberVisibilityFromQualifiedName(methodInfo.as3commonsByteCodeAssignedMethodTrait.traitMultiname);
			for each (var arg:Argument in methodInfo.argumentCollection) {
				var ma:MethodArgument = new MethodArgument();
				ma.as3commons_bytecode::setArgument(arg);
				_arguments[_arguments.length] = ma;
			}
		}

		as3commons_bytecode function setMethodBody(methodBody:MethodBody):void {
			methodBodyBuilder.as3commons_bytecode::setMethodBody(methodBody);
		}

		protected function get methodBodyBuilder():IMethodBodyBuilder {
			if (_methodBodyBuilder == null) {
				_methodBodyBuilder = new MethodBodyBuilder();
			}
			return _methodBodyBuilder;
		}

		public function get arguments():Array {
			return _arguments;
		}

		public function set arguments(value:Array):void {
			_arguments = value;
		}

		public function get returnType():String {
			return _returnType;
		}

		public function set returnType(value:String):void {
			_returnType = value;
		}

		public function get hasRestArguments():Boolean {
			return _hasRestArguments;
		}

		public function set hasRestArguments(value:Boolean):void {
			_hasRestArguments = value;
		}

		public function get hasOptionalArguments():Boolean {
			for each (var arg:MethodArgument in _arguments) {
				if (arg.isOptional) {
					return true;
				}
			}
			return false;
		}

		public function get setDXNS():Boolean {
			return (_methodBodyBuilder) ? _methodBodyBuilder.setDXNS : false;
		}

		public function get needActivation():Boolean {
			return (_methodBodyBuilder) ? _methodBodyBuilder.needActivation : false;
		}

		public function get needArguments():Boolean {
			return (_methodBodyBuilder) ? _methodBodyBuilder.needArguments : false;
		}

		public function defineArgument(type:String = "", isOptional:Boolean = false, defaultValue:Object = null):MethodArgument {
			var arg:MethodArgument = new MethodArgument();
			arg.type = type;
			arg.isOptional = isOptional;
			arg.defaultValue = defaultValue;
			_arguments[_arguments.length] = arg;
			return arg;
		}

		public function build(initScopeDepth:uint = 1):MethodInfo {
			var mi:MethodInfo = (methodInfo != null) ? methodInfo : new MethodInfo();
			for each (var methodArg:MethodArgument in _arguments) {
				var arg:Argument = methodArg.build();
				mi.addArgument(arg);
			}
			if (_methodBodyBuilder != null) {
				var extraLocalCount:uint = mi.argumentCollection.length + ((_hasRestArguments) ? 1 : 0);
				mi.methodBody = _methodBodyBuilder.buildBody(initScopeDepth, extraLocalCount);
				mi.methodBody.methodSignature = mi;
			}
			trait = buildTrait();
			MethodTrait(trait).traitMethod = mi;
			trait.addMetadataList(buildMetadata());
			mi.as3commonsByteCodeAssignedMethodTrait = MethodTrait(trait);
			mi.returnType = MultinameUtil.toQualifiedName(_returnType);
			mi.methodName = createMethodName(mi);
			mi.as3commonsBytecodeName = name;
			setMethodFlags(mi, setDXNS, needActivation, needArguments);
			return mi;
		}

		protected function setMethodFlags(methodInfo:MethodInfo, setDXNS:Boolean, needActivation:Boolean, needArguments:Boolean):void {
			if (hasOptionalArguments) {
				methodInfo.flags = MethodFlag.addFlag(methodInfo.flags, MethodFlag.HAS_OPTIONAL);
			} else {
				methodInfo.flags = MethodFlag.removeFlag(methodInfo.flags, MethodFlag.HAS_OPTIONAL);
			}

			if (_methodBodyBuilder != null) {

				if (_methodBodyBuilder.setDXNS) {
					methodInfo.flags = MethodFlag.addFlag(methodInfo.flags, MethodFlag.SET_DXNS);
				} else {
					methodInfo.flags = MethodFlag.removeFlag(methodInfo.flags, MethodFlag.SET_DXNS);
				}

				if (_methodBodyBuilder.needActivation) {
					methodInfo.flags = MethodFlag.addFlag(methodInfo.flags, MethodFlag.NEED_ACTIVATION);
				} else {
					methodInfo.flags = MethodFlag.removeFlag(methodInfo.flags, MethodFlag.NEED_ACTIVATION);
				}

				if (_methodBodyBuilder.needArguments) {
					methodInfo.flags = MethodFlag.addFlag(methodInfo.flags, MethodFlag.NEED_ARGUMENTS);
				} else {
					methodInfo.flags = MethodFlag.removeFlag(methodInfo.flags, MethodFlag.NEED_ARGUMENTS);
				}
			}

			if (hasRestArguments) {
				methodInfo.flags = MethodFlag.addFlag(methodInfo.flags, MethodFlag.NEED_REST);
			} else {
				methodInfo.flags = MethodFlag.removeFlag(methodInfo.flags, MethodFlag.NEED_REST);
			}
		}

		protected function createMethodName(methodInfo:MethodInfo):String {
			var scope:String = "";
			switch (visibility) {
				case MemberVisibility.PROTECTED:
					scope = "protected:"
					break;
				case MemberVisibility.PRIVATE:
					scope = "private:"
					break;
				case MemberVisibility.NAMESPACE:
					scope = scopeName + ":"
					break;
				case MemberVisibility.INTERNAL:
					scope = packageName.split(MultinameUtil.SINGLE_COLON)[0] + ":"
					break;
			}
			return StringUtils.substitute(METHOD_NAME, packageName, scope, name);
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildTrait():TraitInfo {
			Assert.hasText(name, "name property must not be null or empty");
			Assert.notNull(visibility, "visibility property must not be null");
			var trait:MethodTrait = (methodInfo != null) ? MethodTrait(methodInfo.as3commonsByteCodeAssignedMethodTrait) : new MethodTrait();
			trait.traitKind = TraitKind.METHOD;
			trait.isFinal = isFinal;
			trait.isOverride = isOverride;
			var ns:LNamespace = createTraitNamespace();
			var traitMultiname:QualifiedName = createTraitMultiname(name, ns);
			if (traitMultiname.equals(trait.traitMultiname) == false) {
				trait.traitMultiname = traitMultiname;
			}
			return trait;
		}

		protected function createTraitMultiname(name:String, nameSpace:LNamespace):QualifiedName {
			return new QualifiedName(name, nameSpace);
		}

		/**
		 * @inheritDoc
		 */
		public function get opcodes():Array {
			return methodBodyBuilder.opcodes;
		}

		/**
		 * @inheritDoc
		 */
		public function set opcodes(value:Array):void {
			methodBodyBuilder.opcodes = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get exceptionInfos():Array {
			return methodBodyBuilder.exceptionInfos;
		}

		/**
		 * @inheritDoc
		 */
		public function set exceptionInfos(value:Array):void {
			methodBodyBuilder.exceptionInfos = value;
		}

		/**
		 * @inheritDoc
		 */
		public function addOpcode(opcode:Opcode, params:Array = null):IMethodBodyBuilder {
			return methodBodyBuilder.addOpcode(opcode, params);
		}

		/**
		 * @inheritDoc
		 */
		public function addOpcodes(newOpcodes:Array):IMethodBodyBuilder {
			return methodBodyBuilder.addOpcodes(newOpcodes);
		}

		/**
		 * @inheritDoc
		 */
		public function addAsmSource(source:String):IMethodBodyBuilder {
			return methodBodyBuilder.addAsmSource(source);
		}

		/**
		 * @inheritDoc
		 */
		public function addBackPatches(newBackpatches:Array):IMethodBodyBuilder {
			return methodBodyBuilder.addBackPatches(newBackpatches);
		}

		/**
		 * @inheritDoc
		 */
		public function addOp(opcode:Op):IMethodBodyBuilder {
			return methodBodyBuilder.addOp(opcode);
		}

		/**
		 * @inheritDoc
		 */
		public function defineJump(triggerOpcode:Op, targetOpcode:Op, isDefault:Boolean = false):IMethodBodyBuilder {
			return methodBodyBuilder.defineJump(triggerOpcode, targetOpcode);
		}

		/**
		 * @inheritDoc
		 */
		public function defineExceptionInfo():IExceptionInfoBuilder {
			return methodBodyBuilder.defineExceptionInfo();
		}

		/**
		 * @inheritDoc
		 */
		public function buildBody(initScopeDepth:uint = 1, extraLocalCount:uint = 0):MethodBody {
			return methodBodyBuilder.buildBody(initScopeDepth, extraLocalCount);
		}

	}
}