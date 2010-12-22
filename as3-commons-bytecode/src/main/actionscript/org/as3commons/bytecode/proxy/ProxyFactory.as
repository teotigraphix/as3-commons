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
package org.as3commons.bytecode.proxy {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameL;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.RuntimeQualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.as3commons_bytecode_proxy;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.interception.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeParameter;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeVariable;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Variable;

	/**
	 * Dispatched when the proxy factory has finished loading the SWF/ABC bytecode in the Flash Player/AVM.
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the proxy factory has encountered an IO related error.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Dispatched when the proxy factory has encountered a SWF verification error.
	 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]
	/**
	 *
	 * @author Roland Zwaga
	 */
	public class ProxyFactory extends EventDispatcher implements IProxyFactory {

		//used namespaces
		use namespace as3commons_bytecode_proxy;

		//private static constants
		private static const CHARACTERS:String = "abcdefghijklmnopqrstuvwxys";
		private static const INTERCEPTOR_PROPERTYNAME:String = "methodInvocationInterceptor";
		private static const NS_FILENAME_SUFFIX:String = '.as$4';
		private static const MULTINAME_NAME:String = "intercept";
		private static const AS3COMMONSBYTECODEPROXY:String = "as3commons_bytecode_proxy";
		private static const ORGAS3COMMONSBYTECODE:String = "org.as3commons.bytecode";
		private static const CONSTRUCTOR:String = "constructor";

		//private variables
		private var _classProxyLookup:Dictionary;
		private var _abcBuilder:IAbcBuilder;
		private var _domains:Dictionary;
		private var _namespaceQualifiedName:QualifiedName = new QualifiedName("Namespace", LNamespace.PUBLIC, MultinameKind.QNAME);
		private var _arrayQualifiedName:QualifiedName = new QualifiedName("Array", LNamespace.PUBLIC, MultinameKind.QNAME);
		private var _interceptorRTQName:RuntimeQualifiedName = new RuntimeQualifiedName("methodInvocationInterceptor", MultinameKind.RTQNAME);
		private var _interceptQName:QualifiedName = new QualifiedName("intercept", new LNamespace(NamespaceKind.NAMESPACE, "org.as3commons.bytecode.interception:IMethodInvocationInterceptor"));
		private var _methodInvocationInterceptorFunction:Function;

		public function get methodInvocationInterceptorFunction():Function {
			return _methodInvocationInterceptorFunction;
		}

		public function set methodInvocationInterceptorFunction(value:Function):void {
			_methodInvocationInterceptorFunction = value;
		}

		public function ProxyFactory() {
			super();
			initProxyFactory();
		}

		public function get domains():Dictionary {
			return _domains;
		}

		protected function initProxyFactory():void {
			_abcBuilder = new AbcBuilder();
			_domains = new Dictionary();
			_classProxyLookup = new Dictionary();
		}

		protected function generateSuffix():String {
			var len:int = 20;
			var result:Array = new Array(20);
			while (len--) {
				result[len] = CHARACTERS.charAt(Math.floor(Math.random() * 26));
			}
			return result.join('');
		}

		public function defineProxy(proxiedClass:Class, methodInvocationInterceptorClass:Class = null, applicationDomain:ApplicationDomain = null):ClassProxyInfo {
			methodInvocationInterceptorClass = (methodInvocationInterceptorClass != null) ? methodInvocationInterceptorClass : BasicMethodInvocationInterceptor;
			Assert.state(ClassUtils.isImplementationOf(methodInvocationInterceptorClass, IMethodInvocationInterceptor, applicationDomain) == true, "methodInvocationInterceptorClass argument must be a class that implements IMethodInvocationInterceptor");
			applicationDomain = (applicationDomain != null) ? applicationDomain : ApplicationDomain.currentDomain;
			if (_domains[applicationDomain] == null) {
				_domains[applicationDomain] = [];
			}
			var infos:Array = _domains[applicationDomain] as Array;
			var info:ClassProxyInfo = new ClassProxyInfo(proxiedClass, methodInvocationInterceptorClass);
			infos[infos.length] = info;
			return info;
		}

		public function createProxyClasses():IAbcBuilder {
			for (var domain:* in _domains) {
				var infos:Array = _domains[domain] as Array;
				for each (var info:ClassProxyInfo in infos) {
					var proxyInfo:ProxyInfo = buildProxy(info, domain);
					_classProxyLookup[info.proxiedClass] = proxyInfo;
					proxyInfo.methodInvocationInterceptorClass = info.methodInvocationInterceptorClass;
				}
			}
			_domains = new Dictionary();
			return _abcBuilder;
		}

		public function loadProxyClasses(applicationDomain:ApplicationDomain = null):void {
			applicationDomain = (applicationDomain != null) ? applicationDomain : ApplicationDomain.currentDomain;
			for (var cls:* in _classProxyLookup) {
				ProxyInfo(_classProxyLookup[cls]).applicationDomain = applicationDomain;
			}
			_abcBuilder.addEventListener(Event.COMPLETE, redispatch);
			_abcBuilder.addEventListener(IOErrorEvent.IO_ERROR, redispatch);
			_abcBuilder.addEventListener(IOErrorEvent.VERIFY_ERROR, redispatch);
			_abcBuilder.buildAndLoad(applicationDomain);
		}

		public function createProxy(clazz:Class, constructorArgs:Array = null):Object {
			var proxyInfo:ProxyInfo = _classProxyLookup[clazz] as ProxyInfo;
			if (proxyInfo != null) {
				var cls:Class = proxyInfo.applicationDomain.getDefinition(proxyInfo.proxyClassName) as Class;
				var interceptorInstance:IMethodInvocationInterceptor;
				if (_methodInvocationInterceptorFunction == null) {
					interceptorInstance = new proxyInfo.methodInvocationInterceptorClass();
				} else {
					interceptorInstance = IMethodInvocationInterceptor(_methodInvocationInterceptorFunction(clazz, constructorArgs, proxyInfo.methodInvocationInterceptorClass));
				}
				constructorArgs = (constructorArgs != null) ? [interceptorInstance].concat(constructorArgs) : [interceptorInstance];
				return ClassUtils.newInstance(cls, constructorArgs);
			}
			return null;
		}

		protected function redispatch(event:Event):void {
			_abcBuilder.removeEventListener(Event.COMPLETE, redispatch);
			_abcBuilder.removeEventListener(IOErrorEvent.IO_ERROR, redispatch);
			_abcBuilder.removeEventListener(IOErrorEvent.VERIFY_ERROR, redispatch);
			dispatchEvent(event);
		}

		protected function buildProxy(classProxyInfo:ClassProxyInfo, applicationDomain:ApplicationDomain):ProxyInfo {
			var className:String = ClassUtils.getFullyQualifiedName(classProxyInfo.proxiedClass);
			var type:ByteCodeType = ByteCodeType.forName(className.replace(MultinameUtil.DOUBLE_COLON, MultinameUtil.PERIOD), applicationDomain);
			var classParts:Array = className.split(MultinameUtil.DOUBLE_COLON);
			var packageName:String = classParts[0] + MultinameUtil.PERIOD + generateSuffix();
			var packageBuilder:IPackageBuilder = _abcBuilder.definePackage(packageName);
			var classBuilder:IClassBuilder = packageBuilder.defineClass(classParts[1], className);
			var proxyClassName:String = packageName + MultinameUtil.SINGLE_COLON + classParts[1];
			var nsMultiname:Multiname = createMultiname(proxyClassName, classParts.join(MultinameUtil.SINGLE_COLON), type.extendsClasses);
			var bytecodeQname:QualifiedName = addInterceptorProperty(classBuilder);
			var ctorBuilder:ICtorBuilder = addConstructor(classBuilder, type, classProxyInfo, nsMultiname);
			addConstructorBody(ctorBuilder, bytecodeQname, nsMultiname);
			var accessorBuilder:IAccessorBuilder;
			if ((classProxyInfo.proxyAll == true) && (classProxyInfo.onlyProxyConstructor == false)) {
				reflectMembers(classProxyInfo, type, applicationDomain);
			}
			var memberInfo:MemberInfo;
			for each (memberInfo in classProxyInfo.methods) {
				var methodBuilder:IMethodBuilder = proxyMethod(classBuilder, type, memberInfo);
				addMethodBody(methodBuilder, nsMultiname, bytecodeQname);
			}
			for each (memberInfo in classProxyInfo.accessors) {
				accessorBuilder = proxyAccessor(classBuilder, type, memberInfo);
				addAccessorBodies(accessorBuilder, nsMultiname, bytecodeQname);
			}
			for each (memberInfo in classProxyInfo.properties) {
				accessorBuilder = proxyProperty(classBuilder, type, memberInfo)
				addPropertyAccessorBodies(accessorBuilder, nsMultiname, bytecodeQname);
			}
			return new ProxyInfo(proxyClassName.split(MultinameUtil.SINGLE_COLON).join(MultinameUtil.PERIOD));
		}

		protected function createMultiname(generatedClassName:String, proxiedClassName:String, extendedClasses:Array):Multiname {
			var classNameParts:Array = generatedClassName.split(MultinameUtil.SINGLE_COLON);
			var className:String = String(classNameParts[1]);
			var nsa:Array = [];
			nsa[nsa.length] = new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, generatedClassName);
			nsa[nsa.length] = LNamespace.PUBLIC;
			nsa[nsa.length] = new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, className + NS_FILENAME_SUFFIX);
			nsa[nsa.length] = new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, String(classNameParts[0]));
			nsa[nsa.length] = new LNamespace(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE, String(classNameParts[0]));
			nsa[nsa.length] = LNamespace.BUILTIN;
			nsa[nsa.length] = new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, generatedClassName);
			nsa[nsa.length] = new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, generatedClassName);
			nsa[nsa.length] = new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, proxiedClassName);
			for each (var name:String in extendedClasses) {
				nsa[nsa.length] = new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, name);
			}
			//nsa[nsa.length] = new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, BuiltIns.OBJECT.name);
			var nss:NamespaceSet = new NamespaceSet(nsa);
			return new Multiname(MULTINAME_NAME, nss, MultinameKind.MULTINAME);
		}

		protected function addInterceptorProperty(classBuilder:IClassBuilder):QualifiedName {
			Assert.notNull(classBuilder, "classBuilder argument must not be null");
			var className:String = ClassUtils.getFullyQualifiedName(IMethodInvocationInterceptor);
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty(INTERCEPTOR_PROPERTYNAME, className);
			propertyBuilder.namespace = as3commons_bytecode_proxy;
			return new QualifiedName(AS3COMMONSBYTECODEPROXY, new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, ORGAS3COMMONSBYTECODE));
		}

		protected function addConstructor(classBuilder:IClassBuilder, type:ByteCodeType, classProxyInfo:ClassProxyInfo, nsMultiname:Multiname):ICtorBuilder {
			var ctorBuilder:ICtorBuilder = classBuilder.defineConstructor();
			var interceptorClassName:String = ClassUtils.getFullyQualifiedName(classProxyInfo.methodInvocationInterceptorClass);
			ctorBuilder.defineArgument(interceptorClassName);
			for each (var param:ByteCodeParameter in type.constructor.parameters) {
				ctorBuilder.defineArgument(param.type.fullName, param.isOptional, param.defaultValue);
			}
			return ctorBuilder;
		}

		protected function addConstructorBody(ctorBuilder:ICtorBuilder, bytecodeQname:QualifiedName, multiName:Multiname):void {
			var len:int = ctorBuilder.arguments.length;
			var paramLocal:int = len;
			ctorBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.findpropstrict, [_interceptorRTQName]) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.getlocal_1) //
				.addOpcode(Opcode.setproperty, [_interceptorRTQName]);
			if (len > 1) {
				for (var i:int = 1; i < len; ++i) {
					ctorBuilder.addOpcode(Opcode.getlocal, [(i + 1)]);
				}
				ctorBuilder.addOpcode(Opcode.newarray, [len - 1]) //
					.addOpcode(Opcode.coerce, [_arrayQualifiedName]) //
					.addOpcode(Opcode.setlocal, [paramLocal]) //
					.addOpcode(Opcode.getlocal_1) //
					.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.pushstring, [CONSTRUCTOR]) //
					.addOpcode(Opcode.pushnull) //
					.addOpcode(Opcode.getlocal, [paramLocal]) //
					.addOpcode(Opcode.callproperty, [multiName, 4]) //
					.addOpcode(Opcode.pop) //
					.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.getlocal, [paramLocal]) //
					.addOpcode(Opcode.pushbyte, [0]) //
					.addOpcode(Opcode.getproperty, [new MultinameL(multiName.namespaceSet)]) //
					.addOpcode(Opcode.constructsuper, [len - 1]) //
					.addOpcode(Opcode.returnvoid);
			} else {
				ctorBuilder.addOpcode(Opcode.getlocal_1) //
					.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.pushstring, [CONSTRUCTOR]) //
					.addOpcode(Opcode.pushnull) //
					.addOpcode(Opcode.callproperty, [_interceptQName, 3]) //
					.addOpcode(Opcode.pop) //
					.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.constructsuper, [0]) //
					.addOpcode(Opcode.returnvoid); //
			}
		}

		protected function reflectMembers(classProxyInfo:ClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			var isProtected:Boolean;
			var vsb:NamespaceKind;
			for each (var method:Method in type.methods) {
				var byteCodeMethod:ByteCodeMethod = method as ByteCodeMethod;
				if (byteCodeMethod != null) {
					if ((byteCodeMethod.isStatic) || (byteCodeMethod.isFinal)) {
						continue;
					}
					vsb = byteCodeMethod.visibility;
					isProtected = (vsb === NamespaceKind.PROTECTED_NAMESPACE);
					if (!isPublicOrProtected(vsb)) {
						return;
					}
					classProxyInfo.proxyMethod(byteCodeMethod.name, byteCodeMethod.namespaceURI, isProtected);
				}
			}
			for each (var accessor:Accessor in type.accessors) {
				var byteCodeAccessor:ByteCodeAccessor = accessor as ByteCodeAccessor;
				if (byteCodeAccessor != null) {
					if ((byteCodeAccessor.isStatic) || (byteCodeAccessor.isFinal)) {
						continue;
					}
					vsb = byteCodeAccessor.visibility;
					isProtected = (vsb === NamespaceKind.PROTECTED_NAMESPACE);
					if (!isPublicOrProtected(vsb)) {
						return;
					}
					classProxyInfo.proxyAccessor(byteCodeAccessor.name, byteCodeAccessor.namespaceURI, isProtected);
				}
			}
			for each (var variable:Variable in type.variables) {
				var byteCodeVariable:ByteCodeVariable = variable as ByteCodeVariable;
				if (byteCodeVariable != null) {
					if ((byteCodeVariable.isStatic) || (byteCodeVariable.isFinal)) {
						continue;
					}
					vsb = byteCodeVariable.visibility;
					isProtected = (vsb === NamespaceKind.PROTECTED_NAMESPACE);
					if (!isPublicOrProtected(vsb)) {
						return;
					}
					classProxyInfo.proxyProperty(byteCodeVariable.name, byteCodeVariable.namespaceURI, isProtected);
				}
			}
		}

		protected function isPublicOrProtected(namespaceKind:NamespaceKind):Boolean {
			Assert.notNull(namespaceKind, "namespaceKind argument must not be null");
			return ((namespaceKind === NamespaceKind.PACKAGE_NAMESPACE) || (namespaceKind === NamespaceKind.PROTECTED_NAMESPACE));
		}

		protected function proxyMethod(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo):IMethodBuilder {
			Assert.notNull(classBuilder, "classBuilder argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(memberInfo, "memberInfo argument must not be null");
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod(memberInfo.qName.localName, memberInfo.qName.uri);
			methodBuilder.isOverride = true;
			var method:ByteCodeMethod = type.getMethod(memberInfo.qName.localName, memberInfo.qName.uri) as ByteCodeMethod;
			if (method != null) {
				methodBuilder.returnType = method.returnType.fullName;
				for each (var arg:ByteCodeParameter in method.parameters) {
					methodBuilder.defineArgument(arg.type.fullName, arg.isOptional, arg.defaultValue);
				}
			}
			return methodBuilder;
		}

		protected function proxyAccessor(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo):IAccessorBuilder {
			Assert.notNull(classBuilder, "classBuilder argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(memberInfo, "memberInfo argument must not be null");
			var accessor:ByteCodeAccessor = type.getField(memberInfo.qName.localName, memberInfo.qName.uri) as ByteCodeAccessor;
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor(accessor.name, accessor.type.fullName, accessor.initializedValue);
			accessorBuilder.namespace = memberInfo.qName.uri;
			accessorBuilder.isOverride = true;
			accessorBuilder.access = accessor.access;
			return accessorBuilder;
		}

		protected function proxyProperty(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo):IAccessorBuilder {
			Assert.notNull(classBuilder, "classBuilder argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(memberInfo, "memberInfo argument must not be null");
			var variable:ByteCodeVariable = type.getField(memberInfo.qName.localName, memberInfo.qName.uri) as ByteCodeVariable;
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor(variable.name, variable.type.fullName, variable.initializedValue);
			accessorBuilder.namespace = memberInfo.qName.uri;
			accessorBuilder.isOverride = true;
			accessorBuilder.access = AccessorAccess.READ_WRITE;
			return accessorBuilder;
		}

		protected function addMethodBody(methodBuilder:IMethodBuilder, multiName:Multiname, bytecodeQname:QualifiedName):void {
			Assert.notNull(methodBuilder, "methodBuilder argument must not be null");
			var len:int = methodBuilder.arguments.length;
			var methodQName:QualifiedName = createMethodQName(methodBuilder);
			methodBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.findpropstrict, [_interceptorRTQName]) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_interceptorRTQName]) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushstring, [methodBuilder.name]) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.getsuper, [methodQName]);
			if (len > 0) {
				for (var i:int = 0; i < len; ++i) {
					methodBuilder.addOpcode(Opcode.getlocal, [(i + 1)]);
				}
				methodBuilder.addOpcode(Opcode.newarray, [len - 1]) //
				methodBuilder.addOpcode(Opcode.callproperty, [multiName, 4]);
			} else {
				methodBuilder.addOpcode(Opcode.callproperty, [multiName, 3]);
			}
			if (methodBuilder.returnType == BuiltIns.VOID.fullName) {
				methodBuilder.addOpcode(Opcode.pop).addOpcode(Opcode.returnvoid);
			} else {
				methodBuilder.addOpcode(Opcode.returnvalue);
			}
		}

		protected function createMethodQName(methodBuilder:IMethodBuilder):QualifiedName {
			var ns:LNamespace = (methodBuilder.visibility == MemberVisibility.PUBLIC) ? LNamespace.PUBLIC : new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, "");
			return new QualifiedName(methodBuilder.name, ns);
		}

		protected function addAccessorBodies(accessorBuilder:IAccessorBuilder, multiName:Multiname, bytecodeQname:QualifiedName):void {
			Assert.notNull(accessorBuilder, "accessorBuilder argument must not be null");
			//TODO: generate the darn opcodes...
		}

		protected function addPropertyAccessorBodies(accessorBuilder:IAccessorBuilder, multiName:Multiname, bytecodeQname:QualifiedName):void {
			Assert.notNull(accessorBuilder, "accessorBuilder argument must not be null");
			//TODO: generate the darn opcodes...
		}

	}
}