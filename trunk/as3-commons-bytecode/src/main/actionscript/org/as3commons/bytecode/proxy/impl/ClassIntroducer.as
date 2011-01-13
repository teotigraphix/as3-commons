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
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.BaseMultiname;
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
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.io.AbcDeserializer;
	import org.as3commons.bytecode.proxy.IClassIntroducer;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeVariable;
	import org.as3commons.bytecode.util.AbcSpec;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Method;

	public class ClassIntroducer extends AbstractProxyFactory implements IClassIntroducer {

		private var _methodProxyFactory:MethodProxyFactory;
		private var _accessorProxyFactory:AccessorProxyFactory;

		public function ClassIntroducer(methodProxyFactory:MethodProxyFactory, accessorProxyFactory:AccessorProxyFactory) {
			super();
			initClassIntroducer(methodProxyFactory, accessorProxyFactory);
		}

		protected function initClassIntroducer(methodProxyFactory:MethodProxyFactory, accessorProxyFactory:AccessorProxyFactory):void {
			Assert.notNull(methodProxyFactory, "methodProxyFactory argument must not be null");
			Assert.notNull(accessorProxyFactory, "accessorProxyFactory argument must not be null");
			_methodProxyFactory = methodProxyFactory;
			_accessorProxyFactory = accessorProxyFactory;
		}

		public function introduce(className:String, classBuilder:IClassBuilder):void {
			var type:ByteCodeType = ByteCodeType.forName(className);
			if (type != null) {
				internalIntroduce(type, classBuilder);
			} else {
				throw new ProxyBuildError(ProxyBuildError.INTRODUCED_CLASS_NOT_FOUND, className);
			}
		}

		protected function internalIntroduce(type:ByteCodeType, classBuilder:IClassBuilder):void {
			classBuilder.implementInterfaces(type.interfaces);
			for each (var field:Field in type.fields) {
				introduceField(field, classBuilder, type);
			}
			for each (var method:Method in type.methods) {
				if (method is ByteCodeMethod) {
					introduceMethod(ByteCodeMethod(method), classBuilder, type);
				}
			}
		}

		protected function introduceMethod(method:ByteCodeMethod, classBuilder:IClassBuilder, type:ByteCodeType):void {
			var memberInfo:MemberInfo = new MemberInfo(method.name, method.namespaceURI);
			var methodBuilder:IMethodBuilder = _methodProxyFactory.proxyMethod(classBuilder, type, memberInfo, false);
			cloneMethod(methodBuilder, method, type, classBuilder);
		}

		private function cloneMethod(methodBuilder:IMethodBuilder, method:ByteCodeMethod, type:ByteCodeType, classBuilder:IClassBuilder):void {
			methodBuilder.isOverride = false;
			var methodBody:MethodBody = new MethodBody();
			methodBody.initScopeDepth = method.initScopeDepth;
			methodBody.maxStack = method.maxStack;
			methodBody.localCount = method.localCount;
			methodBody.maxScopeDepth = method.maxScopeDepth;
			var originalPosition:int = type.byteArray.position;
			try {
				type.byteArray.position = method.bodyStartPosition;
				methodBody.opcodes = Opcode.parse(type.byteArray, method.bodyLength, methodBody, type.constantPool);
				var newScopeName:String = classBuilder.packageName + MultinameUtil.SINGLE_COLON + classBuilder.name;
				translateOpcodesNamespaces(methodBody.opcodes, makeScopeName(type.fullName), newScopeName);
				methodBody.exceptionInfos = extractExceptionInfos(type.byteArray, type, newScopeName + '/' + classBuilder.name);
				for each (var op:Op in methodBody.opcodes) {
					var idx:int = AbcDeserializer.getExceptionInfoArgumentIndex(op);
					if (idx > -1) {
						var exceptionIndex:int = op.parameters[idx];
						op.parameters[idx] = methodBody.exceptionInfos[exceptionIndex];
					}
				}
			} finally {
				type.byteArray.position = originalPosition;
			}
			methodBuilder.as3commons_bytecode::setMethodBody(methodBody);
		}


		protected function makeScopeName(fullName:String):String {
			var idx:int = fullName.lastIndexOf(MultinameUtil.PERIOD);
			var arr:Array = fullName.split('');
			arr[idx] = MultinameUtil.SINGLE_COLON;
			return arr.join('');
		}

		protected function translateOpcodesNamespaces(opcodes:Array, oldScopeName:String, newScopeName:String):void {
			for each (var op:Op in opcodes) {
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

		protected function extractExceptionInfos(input:ByteArray, type:ByteCodeType, newExceptionName:String):Array {
			var exceptionInfos:Array = [];
			var exceptionCount:int = AbcSpec.readU30(input);
			for (var exceptionIndex:int = 0; exceptionIndex < exceptionCount; ++exceptionIndex) {
				var exceptionInfo:ExceptionInfo = new ExceptionInfo();
				exceptionInfo.exceptionEnabledFromCodePosition = AbcSpec.readU30(input);
				exceptionInfo.exceptionEnabledToCodePosition = AbcSpec.readU30(input);
				exceptionInfo.codePositionToJumpToOnException = AbcSpec.readU30(input);
				AbcSpec.skipU30(input);
				exceptionInfo.exceptionTypeName = newExceptionName;
				exceptionInfo.nameOfVariableReceivingException = type.constantPool.stringPool[AbcSpec.readU30(input)];
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
			propertyBuilder.visibility = ProxyFactory.getMemberVisibility(byteCodeVariable);
			//addMetadata(propertyBuilder, byteCodeVariable.metaData);
		}

		protected function introduceAccessor(byteCodeAccessor:ByteCodeAccessor, classBuilder:IClassBuilder, type:ByteCodeType):void {
			var memberInfo:MemberInfo = new MemberInfo(byteCodeAccessor.name, byteCodeAccessor.namespaceURI);
			if ((byteCodeAccessor.access === AccessorAccess.READ_ONLY) || (byteCodeAccessor.access === AccessorAccess.READ_WRITE)) {
				var getterFunc:Function = function(event:ProxyFactoryBuildEvent):void {
					if ((event.methodBuilder.name == byteCodeAccessor.name) && (event.methodBuilder.namespaceURI == byteCodeAccessor.namespaceURI)) {
						IEventDispatcher(event.target).removeEventListener(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, getterFunc);
						copyGetterBody(event.methodBuilder, byteCodeAccessor, classBuilder, type);
					}
				};
				_accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, getterFunc);
			}
			if ((byteCodeAccessor.access === AccessorAccess.WRITE_ONLY) || (byteCodeAccessor.access === AccessorAccess.READ_WRITE)) {
				var setterFunc:Function = function(event:ProxyFactoryBuildEvent):void {
					if ((event.methodBuilder.name == byteCodeAccessor.name) && (event.methodBuilder.namespaceURI == byteCodeAccessor.namespaceURI)) {
						IEventDispatcher(event.target).removeEventListener(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, setterFunc);
						copySetterBody(event.methodBuilder, byteCodeAccessor, classBuilder, type);
					}
				};
				_accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, setterFunc);
			}
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