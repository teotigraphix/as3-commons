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
package org.as3commons.bytecode.proxy.impl {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.MultinameL;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.io.AbcDeserializer;
	import org.as3commons.bytecode.proxy.IAccessorProxyFactory;
	import org.as3commons.bytecode.proxy.IClassIntroducer;
	import org.as3commons.bytecode.proxy.IConstructorProxyFactory;
	import org.as3commons.bytecode.proxy.IMethodProxyFactory;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeVariable;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.as3commons_reflect;

	public class ClassIntroducer extends AbstractProxyFactory implements IClassIntroducer {

		private var _methodProxyFactory:IMethodProxyFactory;
		private var _accessorProxyFactory:IAccessorProxyFactory;
		private var _constructorProxyFactory:IConstructorProxyFactory;
		private var _getterBuilders:Dictionary;
		private var _setterBuilders:Dictionary;

		public function ClassIntroducer(constructorProxyFactory:IConstructorProxyFactory, methodProxyFactory:IMethodProxyFactory, accessorProxyFactory:IAccessorProxyFactory) {
			super();
			initClassIntroducer(constructorProxyFactory, methodProxyFactory, accessorProxyFactory);
		}

		protected function initClassIntroducer(constructorProxyFactory:IConstructorProxyFactory, methodProxyFactory:IMethodProxyFactory, accessorProxyFactory:IAccessorProxyFactory):void {
			Assert.notNull(methodProxyFactory, "methodProxyFactory argument must not be null");
			Assert.notNull(accessorProxyFactory, "accessorProxyFactory argument must not be null");
			_methodProxyFactory = methodProxyFactory;
			_accessorProxyFactory = accessorProxyFactory;
			_accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, beforeGetterBodyBuildHandler, false, 0, true);
			_accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, beforeSetterBodyBuildHandler, false, 0, true);
			_constructorProxyFactory = constructorProxyFactory;
			_getterBuilders = new Dictionary();
			_setterBuilders = new Dictionary();
		}

		public function introduce(className:String, classBuilder:IClassBuilder):void {
			var type:ByteCodeType = ByteCodeType.forName(className);
			if (type.isInterface) {
				throw new ProxyBuildError(ProxyBuildError.CANNOT_INTRODUCE_INTERFACE, className);
			}
			if (type.isNative) {
				throw new ProxyBuildError(ProxyBuildError.CANNOT_INTRODUCE_NATIVE_CLASS, className);
			}
			if (type != null) {
				internalIntroduce(type, classBuilder);
			} else {
				throw new ProxyBuildError(ProxyBuildError.INTRODUCED_CLASS_NOT_FOUND, className);
			}
		}

		protected function internalIntroduce(type:ByteCodeType, classBuilder:IClassBuilder):void {
			classBuilder.implementInterfaces(type.interfaces);

			var newScopeName:String = classBuilder.packageName + MultinameUtil.SINGLE_COLON + classBuilder.name;
			var oldScopeName:String = makeScopeName(type.fullName);
			var constructorBody:MethodBody = deserializeMethodBody(type, type.instanceConstructor, newScopeName);
			constructorBody.opcodes.pop();
			var constrSuperIdx:int = 0;
			var dropped:Array = [];
			var foundPushscope:Boolean = false;
			for each (var op:Op in constructorBody.opcodes) {
				switch (op.opcode) {
					case Opcode.debug:
					case Opcode.debugfile:
					case Opcode.debugline:
						dropped[dropped.length] = constrSuperIdx;
						break;
					case Opcode.pushscope:
						if (!foundPushscope) {
							foundPushscope = true;
							dropped[dropped.length] = (constrSuperIdx - 1);
							dropped[dropped.length] = constrSuperIdx;
						}
						break;
					case Opcode.constructsuper:
						dropped[dropped.length] = (constrSuperIdx - 1);
						dropped[dropped.length] = constrSuperIdx;
						break;
				}
				constrSuperIdx++;
				translateOpcodeNamespaces(op, oldScopeName, newScopeName);
			}
			dropped = dropped.reverse();
			for each (constrSuperIdx in dropped) {
				constructorBody.opcodes.splice(constrSuperIdx, 1);
			}
			if (constructorBody.opcodes.length > 0) {
				constructorBody.opcodes[constructorBody.opcodes.length] = Opcode.getlocal_0.op();
				var mergeConstructor:Function = function(event:ProxyFactoryBuildEvent):void {
					var ctorBuilder:ICtorBuilder = event.methodBuilder as ICtorBuilder;
					var trailingOpcodes:Array = ctorBuilder.opcodes.splice(2, ctorBuilder.opcodes.length);
					ctorBuilder.opcodes.push.apply(ctorBuilder.opcodes, constructorBody.opcodes);
					ctorBuilder.opcodes.push.apply(ctorBuilder.opcodes, trailingOpcodes);
				};
				_constructorProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_CONSTRUCTOR_BODY_BUILD, mergeConstructor);
			}

			for each (var field:Field in type.fields) {
				introduceField(field, classBuilder, type);
			}
			for each (var method:ByteCodeMethod in type.methods) {
				//methods with body length 0 are native methods
				if (method.bodyLength > 0) {
					introduceMethod(ByteCodeMethod(method), classBuilder, type);
				}
			}
		}

		protected function introduceMethod(method:ByteCodeMethod, classBuilder:IClassBuilder, type:ByteCodeType):void {
			var memberInfo:MemberInfo = new MemberInfo(method.name, method.namespaceURI);
			var methodBuilder:IMethodBuilder = _methodProxyFactory.proxyMethod(classBuilder, type, memberInfo, false);
			cloneMethod(methodBuilder, method, type, classBuilder);
		}

		protected function cloneMethod(methodBuilder:IMethodBuilder, method:ByteCodeMethod, type:ByteCodeType, classBuilder:IClassBuilder):void {
			methodBuilder.isOverride = false;
			var newScopeName:String = classBuilder.packageName + MultinameUtil.SINGLE_COLON + classBuilder.name;
			var oldScopeName:String = makeScopeName(type.fullName);
			var methodBody:MethodBody = deserializeMethodBody(type, method, newScopeName);
			methodBody.initScopeDepth = method.initScopeDepth;
			methodBody.maxStack = method.maxStack;
			methodBody.localCount = method.localCount;
			methodBody.maxScopeDepth = method.maxScopeDepth;
			translateOpcodesNamespaces(methodBody.opcodes, oldScopeName, newScopeName);
			for each (var info:ExceptionInfo in methodBody.exceptionInfos) {
				translateNamespace(info.variableReceivingException.nameSpace, oldScopeName, newScopeName);
			}
			methodBuilder.as3commons_bytecode::setMethodBody(methodBody);
		}

		protected function deserializeMethodBody(type:ByteCodeType, method:ByteCodeMethod, newScopeName:String):MethodBody {
			if (method.methodBody == null) {
				method.as3commons_reflect::setMethodBody(new MethodBody());
				var originalPosition:int = type.byteArray.position;
				try {
					type.byteArray.position = method.bodyStartPosition;
					method.methodBody.opcodes = Opcode.parse(type.byteArray, method.bodyLength, method.methodBody, type.constantPool);
					method.methodBody.exceptionInfos = extractExceptionInfos(type.byteArray, type);
					for each (var op:Op in method.methodBody.opcodes) {
						var idx:int = AbcDeserializer.getExceptionInfoArgumentIndex(op);
						if (idx > -1) {
							var exceptionIndex:int = op.parameters[idx];
							op.parameters[idx] = method.methodBody.exceptionInfos[exceptionIndex];
						}
					}
				} finally {
					type.byteArray.position = originalPosition;
				}
			}
			return MethodBody(method.methodBody.clone());
		}

		protected function makeScopeName(fullName:String):String {
			var idx:int = fullName.lastIndexOf(MultinameUtil.PERIOD);
			var arr:Array = fullName.split('');
			arr[idx] = MultinameUtil.SINGLE_COLON;
			return arr.join('');
		}

		protected function translateOpcodesNamespaces(opcodes:Array, oldScopeName:String, newScopeName:String):void {
			for each (var op:Op in opcodes) {
				translateOpcodeNamespaces(op, oldScopeName, newScopeName);
			}
		}

		protected function translateOpcodeNamespaces(op:Op, oldScopeName:String, newScopeName:String):void {
			var len:int = op.parameters.length;
			for (var i:int = 0; i < len; ++i) {
				var param:* = op.parameters[i];
				switch (true) {
					case (param is Multiname):
						translateNamespaceSet(Multiname(param).namespaceSet, oldScopeName, newScopeName);
						break;
					case (param is LNamespace):
						translateNamespace(LNamespace(param), oldScopeName, newScopeName);
						break;
					case (param is MultinameG):
						translateNamespace(MultinameG(param).qualifiedName.nameSpace, oldScopeName, newScopeName);
						break;
					case (param is MultinameL):
						translateNamespaceSet(MultinameL(param).namespaceSet, oldScopeName, newScopeName);
						break;
					case (param is QualifiedName):
						translateNamespace(QualifiedName(param).nameSpace, oldScopeName, newScopeName);
						break;
					case (param is NamespaceSet):
						translateNamespaceSet(NamespaceSet(param), oldScopeName, newScopeName);
						break;
				}
			}
		}

		protected function translateNamespaceSet(namespaceSet:NamespaceSet, oldScopeName:String, newScopeName:String):void {
			for each (var ns:LNamespace in namespaceSet) {
				translateNamespace(ns, oldScopeName, newScopeName);
			}
		}

		protected function translateNamespace(ns:LNamespace, oldScopeName:String, newScopeName:String):void {
			if (ns.name == oldScopeName) {
				ns.name = newScopeName;
			}
		}

		protected function extractExceptionInfos(input:ByteArray, type:ByteCodeType):Array {
			var exceptionInfos:Array = [];
			var exceptionCount:int = AbcSpec.readU30(input);
			for (var exceptionIndex:int = 0; exceptionIndex < exceptionCount; ++exceptionIndex) {
				var exceptionInfo:ExceptionInfo = new ExceptionInfo();
				exceptionInfo.exceptionEnabledFromCodePosition = AbcSpec.readU30(input);
				exceptionInfo.exceptionEnabledToCodePosition = AbcSpec.readU30(input);
				exceptionInfo.codePositionToJumpToOnException = AbcSpec.readU30(input);
				exceptionInfo.exceptionType = type.constantPool.multinamePool[AbcSpec.readU30(input)];
				exceptionInfo.variableReceivingException = type.constantPool.multinamePool[AbcSpec.readU30(input)];
				exceptionInfos[exceptionInfos.length] = exceptionInfo;
			}
			return exceptionInfos;
		}

		protected function introduceField(field:Field, classBuilder:IClassBuilder, type:ByteCodeType):void {
			if (field is ByteCodeAccessor) {
				introduceAccessor(ByteCodeAccessor(field), classBuilder, type);
			} else if (field is ByteCodeVariable) {
				introduceVariable(ByteCodeVariable(field), classBuilder);
			}
		}

		protected function introduceVariable(byteCodeVariable:ByteCodeVariable, classBuilder:IClassBuilder):void {
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty(byteCodeVariable.name, byteCodeVariable.type.fullName, byteCodeVariable.initializedValue);
			propertyBuilder.namespaceURI = byteCodeVariable.namespaceURI;
			propertyBuilder.scopeName = byteCodeVariable.scopeName;
			propertyBuilder.isStatic = byteCodeVariable.isStatic;
			propertyBuilder.visibility = ProxyFactory.getMemberVisibility(byteCodeVariable);
			addMetadata(propertyBuilder, byteCodeVariable.metadata);
		}

		protected function beforeGetterBodyBuildHandler(event:ProxyFactoryBuildEvent):void {
			var key:String = StringUtils.substitute("{0}.{1}.{2}", event.classBuilder.name, event.methodBuilder.namespaceURI, event.methodBuilder.name);
			var arr:Array = _getterBuilders[key];
			if (arr != null) {
				var byteCodeAccessor:ByteCodeAccessor = ByteCodeAccessor(arr[0]);
				var type:ByteCodeType = ByteCodeType(arr[1]);
				copyGetterBody(event.methodBuilder, byteCodeAccessor, event.classBuilder, type);
				delete _getterBuilders[key];
			}
		}

		protected function beforeSetterBodyBuildHandler(event:ProxyFactoryBuildEvent):void {
			var key:String = StringUtils.substitute("{0}.{1}.{2}", event.classBuilder.name, event.methodBuilder.namespaceURI, event.methodBuilder.name);
			var arr:Array = _setterBuilders[key];
			if (arr != null) {
				var byteCodeAccessor:ByteCodeAccessor = ByteCodeAccessor(arr[0]);
				var type:ByteCodeType = ByteCodeType(arr[1]);
				copySetterBody(event.methodBuilder, byteCodeAccessor, event.classBuilder, type);
				delete _setterBuilders[key];
			}
		}

		protected function introduceAccessor(byteCodeAccessor:ByteCodeAccessor, classBuilder:IClassBuilder, type:ByteCodeType):void {
			if ((byteCodeAccessor.access === AccessorAccess.READ_ONLY) || (byteCodeAccessor.access === AccessorAccess.READ_WRITE)) {
				_getterBuilders[StringUtils.substitute("{0}.{1}.{2}", classBuilder.name, byteCodeAccessor.namespaceURI, byteCodeAccessor.name)] = [byteCodeAccessor, type];
			}
			if ((byteCodeAccessor.access === AccessorAccess.WRITE_ONLY) || (byteCodeAccessor.access === AccessorAccess.READ_WRITE)) {
				_setterBuilders[StringUtils.substitute("{0}.{1}.{2}", classBuilder.name, byteCodeAccessor.namespaceURI, byteCodeAccessor.name)] = [byteCodeAccessor, type];
			}
			var memberInfo:MemberInfo = new MemberInfo(byteCodeAccessor.name, byteCodeAccessor.namespaceURI);
			_accessorProxyFactory.proxyAccessor(classBuilder, type, memberInfo, null, null, false);
		}

		private function copyGetterBody(methodBuilder:IMethodBuilder, byteCodeAccessor:ByteCodeAccessor, classBuilder:IClassBuilder, type:ByteCodeType):void {
			cloneMethod(methodBuilder, byteCodeAccessor.getterMethod, type, classBuilder);
		}

		private function copySetterBody(methodBuilder:IMethodBuilder, byteCodeAccessor:ByteCodeAccessor, classBuilder:IClassBuilder, type:ByteCodeType):void {
			cloneMethod(methodBuilder, byteCodeAccessor.setterMethod, type, classBuilder);
		}
	}
}