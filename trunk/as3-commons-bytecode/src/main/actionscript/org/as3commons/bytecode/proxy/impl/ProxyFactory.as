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
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.as3commons_bytecode_proxy;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.impl.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.proxy.IAccessorProxyFactory;
	import org.as3commons.bytecode.proxy.IClassIntroducer;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IConstructorProxyFactory;
	import org.as3commons.bytecode.proxy.IMethodProxyFactory;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.ProxyScope;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyCreationEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.proxy.event.ProxyNameCreationEvent;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.IVisibleMember;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetadataContainer;
	import org.as3commons.reflect.Type;

	/**
	 * @inheritDoc
	 */
	[Event(name="createProxyPackageName", type="org.as3commons.bytecode.proxy.event.ProxyNameCreationEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="createProxyClassName", type="org.as3commons.bytecode.proxy.event.ProxyNameCreationEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="getMethodInvocationInterceptor", type="org.as3commons.bytecode.proxy.event.ProxyFactoryEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="beforeGetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="afterGetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="beforeSetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="afterSetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="beforeMethodBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="afterMethodBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="beforeConstructorBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="afterConstructorBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="afterProxyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * @inheritDoc
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]
	/**
	 * Basic implementation of the <code>IProxyFactory</code> interface.
	 * @author Roland Zwaga
	 */
	public class ProxyFactory extends AbstractProxyFactory implements IProxyFactory {

		//used namespaces
		use namespace as3commons_bytecode_proxy;

		//public static constants
		public static var proxyCreationDispatcher:IEventDispatcher = new EventDispatcher();

		//private static constants
		private static const AS3COMMONSBYTECODEPROXY:String = "as3commons_bytecode_proxy";
		private static const CHARACTERS:String = "abcdefghijklmnopqrstuvwxys";
		private static const CONSTRUCTOR:String = "constructor";
		private static const INTERCEPTOR_PROPERTYNAME:String = "methodInvocationInterceptor";
		private static const IS_FINAL_FIELD_NAME:String = 'isFinal';
		private static const IS_STATIC_FIELD_NAME:String = 'isStatic';
		private static const LOGGER:ILogger = getLogger(ProxyFactory);
		private static const MULTINAME_NAME:String = "intercept";
		private static const NAMESPACE_URI_FIELD_NAME:String = 'namespaceURI';
		private static const NS_FILENAME_SUFFIX:String = '.as$666';
		private static const OBJECT_DECLARINGTYPE_NAME:String = 'Object';
		private static const ORGAS3COMMONSBYTECODE:String = "org.as3commons.bytecode";
		private static const PROXY_PACKAGE_NAME_PREFIX:String = "_as3commons_bytecode_generated_";
		private static const VISIBILITY_FIELD_NAME:String = 'visibility';

		/**
		 * Translates the specified <code>member.visibility</code> value to a valid <code>MemberVisibility</code> enum instance.
		 * @param member The specified <code>IVisibleMember</code> instance.
		 * @return A valid <code>MemberVisibility</code> enum instance.
		 */
		public static function getMemberVisibility(member:IVisibleMember):MemberVisibility {
			switch (member.visibility) {
				case NamespaceKind.PACKAGE_NAMESPACE:
					return MemberVisibility.PUBLIC;
					break;
				case NamespaceKind.PROTECTED_NAMESPACE:
					return MemberVisibility.PROTECTED;
					break;
				case NamespaceKind.PRIVATE_NAMESPACE:
					return MemberVisibility.PRIVATE;
					break;
				case NamespaceKind.NAMESPACE:
					return MemberVisibility.NAMESPACE;
					break;
				default:
					return MemberVisibility.PUBLIC;
					break;
			}
		}

		/**
		 * Creates a new <code>ProxyFactory</code> instance.
		 */
		public function ProxyFactory() {
			super();
			_domains = new Dictionary();
			_classProxyLookup = new Dictionary();
			_proxyClassLookup = new Dictionary();
			_generatedMultinames = new Dictionary();
			proxyCreationDispatcher.addEventListener(ProxyCreationEvent.PROXY_CREATED, proxyCreatedHandler);
			LOGGER.debug("ProxyFactory created and initialized");
		}

		private var _abcBuilder:IAbcBuilder;
		private var _accessorProxyFactory:IAccessorProxyFactory;
		private var _classIntroducer:IClassIntroducer;
		private var _classProxyLookup:Dictionary;
		private var _constructorProxyFactory:IConstructorProxyFactory;
		private var _domains:Dictionary;
		private var _generatedMultinames:Dictionary;
		private var _isGenerating:Boolean = false;
		private var _methodProxyFactory:IMethodProxyFactory;
		private var _proxyClassLookup:Dictionary;

		/**
		 *
		 */
		public function get accessorProxyFactory():IAccessorProxyFactory {
			return _accessorProxyFactory ||= new AccessorProxyFactory();
		}

		/**
		 * @private
		 */
		public function set accessorProxyFactory(value:IAccessorProxyFactory):void {
			removeAccessorProxyFactoryListeners(_accessorProxyFactory);
			_accessorProxyFactory = value;
			addAccessorProxyFactoryListeners(_accessorProxyFactory);
		}

		/**
		 *
		 */
		public function get classIntroducer():IClassIntroducer {
			return _classIntroducer ||= new ClassIntroducer(constructorProxyFactory, methodProxyFactory, accessorProxyFactory);
		}

		/**
		 * @private
		 */
		public function set classIntroducer(value:IClassIntroducer):void {
			_classIntroducer = value;
		}

		/**
		 *
		 */
		public function get constructorProxyFactory():IConstructorProxyFactory {
			return _constructorProxyFactory ||= new ConstructorProxyFactory();
		}

		/**
		 * @private
		 */
		public function set constructorProxyFactory(value:IConstructorProxyFactory):void {
			removeConstructorProxyFactoryListeners(_constructorProxyFactory);
			_constructorProxyFactory = value;
			addConstructorProxyFactoryListeners(_constructorProxyFactory);
		}

		/**
		 * A <code>Dictionary</code> lookup of <code>ApplicationDomain</code>-&gt;<code>Array</code>-of-<code>ClassProxyInfo</code>.
		 */
		public function get domains():Dictionary {
			return _domains;
		}

		/**
		 *
		 */
		public function get methodProxyFactory():IMethodProxyFactory {
			return _methodProxyFactory ||= new MethodProxyFactory();
		}

		/**
		 * @private
		 */
		public function set methodProxyFactory(value:IMethodProxyFactory):void {
			removeMethodProxyFactoryListeners(_methodProxyFactory);
			_methodProxyFactory = value;
			addMethodProxyFactoryListeners(_methodProxyFactory);
		}

		/**
		 * @throws ProxyBuildError.UNKNOWN_PROXIED_CLASS if the specified class has not been proxied.
		 * @inheritDoc
		 */
		public function createProxy(clazz:Class, constructorArgs:Array=null):* {
			var proxyInfo:ProxyInfo = _classProxyLookup[clazz];
			if (proxyInfo != null) {
				LOGGER.debug("Creating proxy for class {0} with arguments: {1}", [clazz, (constructorArgs != null) ? constructorArgs.join(',') : ""]);
				return ClassUtils.newInstance(proxyInfo.proxyClass, constructorArgs);
			}
			throw new ProxyBuildError(ProxyBuildError.UNKNOWN_PROXIED_CLASS, clazz.toString());
		}

		/**
		 * @inheritDoc
		 */
		public function defineProxy(proxiedClass:Class, methodInvocationInterceptorClass:Class=null, applicationDomain:ApplicationDomain=null):IClassProxyInfo {
			methodInvocationInterceptorClass ||= BasicMethodInvocationInterceptor;
			applicationDomain ||= Type.currentApplicationDomain;
			if (ClassUtils.isImplementationOf(methodInvocationInterceptorClass, IMethodInvocationInterceptor, applicationDomain) == false) {
				throw new IllegalOperationError("methodInvocationInterceptorClass argument must be a class that implements IMethodInvocationInterceptor");
			}
			var infos:Array = _domains[applicationDomain] ||= [];
			var info:IClassProxyInfo = new ClassProxyInfo(proxiedClass, methodInvocationInterceptorClass);
			infos[infos.length] = info;
			LOGGER.debug("Defined proxy class for {0}", [proxiedClass]);
			return info;
		}

		/**
		 * @inheritDoc
		 */
		public function generateProxyClasses():IAbcBuilder {
			_isGenerating = true;
			_abcBuilder ||= new AbcBuilder();
			try {
				for (var domain:* in _domains) {
					var infos:Array = _domains[domain];
					for each (var info:IClassProxyInfo in infos) {
						if (_classProxyLookup[info.proxiedClass] == null) {
							var proxyInfo:ProxyInfo = buildProxyClass(info, domain);
							proxyInfo.proxiedClass = info.proxiedClass;
							proxyInfo.interceptorFactory = info.interceptorFactory;
							_classProxyLookup[info.proxiedClass] = proxyInfo;
							proxyInfo.methodInvocationInterceptorClass = info.methodInvocationInterceptorClass;
						}
					}
				}
			} finally {
				_isGenerating = false;
				_domains = new Dictionary();
				LOGGER.debug("Finished generating proxy classes");
			}
			return _abcBuilder;
		}

		/**
		 * @inheritDoc
		 */
		public function getProxyInfoForClass(proxiedClass:Class):ProxyInfo {
			return _classProxyLookup[proxiedClass] as ProxyInfo;
		}

		public function hasProxy(clazz:Class):Boolean {
			return (_classProxyLookup[clazz] != null)
		}

		/**
		 * @inheritDoc
		 */
		public function loadProxyClasses(applicationDomain:ApplicationDomain=null):void {
			if (_isGenerating) {
				throw new ProxyBuildError(ProxyBuildError.PROXY_FACTORY_IS_BUSY_GENERATING);
			}
			applicationDomain ||= Type.currentApplicationDomain;
			var proxyInfo:ProxyInfo;
			for (var cls:* in _classProxyLookup) {
				proxyInfo = _classProxyLookup[cls];
				if (proxyInfo.applicationDomain == null) {
					proxyInfo.applicationDomain = applicationDomain;
				}
			}
			_abcBuilder.addEventListener(Event.COMPLETE, redispatch);
			_abcBuilder.addEventListener(IOErrorEvent.IO_ERROR, redispatch);
			_abcBuilder.addEventListener(IOErrorEvent.VERIFY_ERROR, redispatch, false, 0, true);
			_abcBuilder.buildAndLoad(applicationDomain);
			LOGGER.debug("Loading proxies into application domain {0}", [applicationDomain]);
		}

		public function exportProxyClasses(applicationDomain:ApplicationDomain=null):ByteArray {
			if (_isGenerating) {
				throw new ProxyBuildError(ProxyBuildError.PROXY_FACTORY_IS_BUSY_GENERATING);
			}
			applicationDomain ||= Type.currentApplicationDomain;
			for (var cls:* in _classProxyLookup) {
				ProxyInfo(_classProxyLookup[cls]).applicationDomain = applicationDomain;
			}
			return _abcBuilder.buildAndExport(applicationDomain);
		}

		/**
		 *
		 * @param accessorProxyFactory
		 */
		protected function addAccessorProxyFactoryListeners(accessorProxyFactory:IAccessorProxyFactory):void {
			if (accessorProxyFactory != null) {
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_SETTER_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		/**
		 *
		 * @param constructorProxyFactory
		 */
		protected function addConstructorProxyFactoryListeners(constructorProxyFactory:IConstructorProxyFactory):void {
			if (constructorProxyFactory != null) {
				constructorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
				constructorProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		/**
		 * Defines a property called 'methodInvocationInterceptor' on the specified <code>IClassBuilder</code>
		 * and scopes it to the <code>as3commons_bytecode_proxy</code> namespace. It the returns a valid <code>QualifiedName</code>
		 * instance that can be used as a parameter for <code>Opcode.findproperty</code> and <code>Opcode.getproperty</code> opcodes
		 * in the generated method bodies.
		 * @param classBuilder The specified <code>IClassBuilder</code>.
		 * @return The specified <code>QualifiedName</code>.
		 */
		protected function addInterceptorProperty(classBuilder:IClassBuilder):QualifiedName {
			CONFIG::debug {
				Assert.notNull(classBuilder, "classBuilder argument must not be null");
			}
			var className:String = ClassUtils.getFullyQualifiedName(IMethodInvocationInterceptor);
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty(INTERCEPTOR_PROPERTYNAME, className);
			propertyBuilder.namespaceURI = as3commons_bytecode_proxy;
			return new QualifiedName(AS3COMMONSBYTECODEPROXY, new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, ORGAS3COMMONSBYTECODE));
		}

		/**
		 *
		 * @param methodProxyFactory
		 */
		protected function addMethodProxyFactoryListeners(methodProxyFactory:IMethodProxyFactory):void {
			if (methodProxyFactory != null) {
				methodProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_METHOD_BODY_BUILD, redispatchBuilderEvent);
				methodProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_METHOD_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		/**
		 * Generates the <code>Class</code> specified by the <code>ClassProxyInfo</code> using the emit API.
		 * @param classProxyInfo The specified <code>ClassProxyInfo</code>.
		 * @param applicationDomain The application domain the proxied <code>Class</code> belongs to.
		 * @return A <code>ProxyInfo</code> instance.
		 * @throws org.as3commons.bytecode.proxy.error.ProxyBuildError When the proxied class is marked as final.
		 */
		protected function buildProxyClass(classProxyInfo:IClassProxyInfo, applicationDomain:ApplicationDomain):ProxyInfo {
			var className:String = ClassUtils.getFullyQualifiedName(classProxyInfo.proxiedClass);
			LOGGER.debug("Preparing to proxy class {0}", [className]);
			var type:ByteCodeType = ByteCodeType.forName(className.replace(MultinameUtil.DOUBLE_COLON, MultinameUtil.PERIOD), applicationDomain);
			if (type == null) {
				throw new ProxyBuildError(ProxyBuildError.NO_BYTECODE_TYPE_FOUND_FOR_CLASS, className);
			}
			if (type.isFinal) {
				throw new ProxyBuildError(ProxyBuildError.FINAL_CLASS_ERROR, className);
			}
			var classParts:Array = className.split(MultinameUtil.DOUBLE_COLON);
			var packageName:String = generateProxyPackagename(classParts);
			var packageBuilder:IPackageBuilder = _abcBuilder.definePackage(packageName);

			var proxyClassName:String = generateProxyClassName(classParts);
			var classBuilder:IClassBuilder = packageBuilder.defineClass(proxyClassName, (type.isInterface ? null : className));
			addMetadata(classBuilder, type.metadata);
			if ((type.isDynamic == false) && (classProxyInfo.makeDynamic == true)) {
				classBuilder.isDynamic = true;
			} else {
				classBuilder.isDynamic = type.isDynamic;
			}
			classBuilder.isFinal = true;
			if (type.isInterface) {
				classBuilder.implementInterface(type.fullName);
			}

			proxyClassName = packageName + MultinameUtil.SINGLE_COLON + proxyClassName;
			var nsMultiname:Multiname = createMultiname(proxyClassName, classParts.join(MultinameUtil.SINGLE_COLON), type.extendsClasses);
			var bytecodeQname:QualifiedName = addInterceptorProperty(classBuilder);

			for each (var introducedClassName:String in classProxyInfo.introductions) {
				classIntroducer.introduce(introducedClassName, classBuilder, applicationDomain);
			}

			var ctorBuilder:ICtorBuilder = constructorProxyFactory.addConstructor(classBuilder, type, classProxyInfo);
			constructorProxyFactory.addConstructorBody(ctorBuilder, bytecodeQname, nsMultiname);

			if (classProxyInfo.accessors.length == 0) {
				reflectAccessors(classProxyInfo, type, applicationDomain);
			}

			if (classProxyInfo.methods.length == 0) {
				reflectMethods(classProxyInfo, type, applicationDomain);
			}

			for each (var interfaze:Class in classProxyInfo.implementedInterfaces) {
				var interfaceType:ByteCodeType = ByteCodeType.forClass(interfaze, applicationDomain);
				classBuilder.implementInterface(interfaceType.fullName);
				reflectInterfaceAccessors(classProxyInfo, interfaceType, applicationDomain);
				reflectInterfaceMethods(classProxyInfo, interfaceType, applicationDomain);
			}

			var memberInfo:MemberInfo;
			var event:ProxyFactoryBuildEvent;
			for each (memberInfo in classProxyInfo.methods) {
				createProxiedMethod(classBuilder, type, memberInfo, event, nsMultiname, bytecodeQname);
			}

			for each (memberInfo in classProxyInfo.interfaceMethods) {
				createProxiedMethod(classBuilder, memberInfo.declaringType, memberInfo, event, nsMultiname, bytecodeQname);
			}

			for each (memberInfo in classProxyInfo.accessors) {
				accessorProxyFactory.proxyAccessor(classBuilder, type, memberInfo, nsMultiname, bytecodeQname);
			}

			for each (memberInfo in classProxyInfo.interfaceAccessors) {
				accessorProxyFactory.proxyAccessor(classBuilder, memberInfo.declaringType, memberInfo, nsMultiname, bytecodeQname);
			}

			dispatchEvent(new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.AFTER_PROXY_BUILD, null, classBuilder, classProxyInfo.proxiedClass));
			LOGGER.debug("Generated proxy class {0} for class {1}", [proxyClassName, classProxyInfo.proxiedClass]);
			return new ProxyInfo(proxyClassName.split(MultinameUtil.SINGLE_COLON).join(MultinameUtil.PERIOD));
		}

		private function generateProxyClassName(classParts:Array):String {
			var proxyClassName:String = null;
			if (hasEventListener(ProxyNameCreationEvent.CREATE_CLASS_NAME)) {
				var event:ProxyNameCreationEvent = new ProxyNameCreationEvent(ProxyNameCreationEvent.CREATE_CLASS_NAME, classParts.join(MultinameUtil.PERIOD));
				dispatchEvent(event);
				proxyClassName = event.proxyName;
			}
			proxyClassName ||= ((classParts.length > 1) ? classParts[1] : classParts[0]) + generateSuffix();
			return proxyClassName;
		}


		private function generateProxyPackagename(classParts:Array):String {
			var packageName:String = null;
			if (hasEventListener(ProxyNameCreationEvent.CREATE_PACKAGE_NAME)) {
				var event:ProxyNameCreationEvent = new ProxyNameCreationEvent(ProxyNameCreationEvent.CREATE_PACKAGE_NAME, classParts.join(MultinameUtil.PERIOD));
				dispatchEvent(event);
				packageName = event.proxyName;
			}
			//packageName ||= (classParts.length > 1) ? classParts[0] + MultinameUtil.PERIOD + generateSuffix() : generateSuffix();
			packageName ||= (classParts.length > 1) ? classParts[0] : "";
			return packageName;
		}

		/**
		 * Creates a valid <code>Multiname</code> for the specified class name, proxied class name and all of its
		 * super classes defined by the extendedClasses <code>Array</code> which is used as the parameter for the <code>Opcode.callproperty</code>
		 * opcode in the generated method bodies.
		 * @param generatedClassName The specified class name.
		 * @param proxiedClassName The specified proxied class name.
		 * @param extendedClasses The specified extendedClasses <code>Array</code>.
		 * @return A valid <code>Multiname</code> instance.
		 */
		protected function createMultiname(generatedClassName:String, proxiedClassName:String, extendedClasses:Array):Multiname {
			if (_generatedMultinames[generatedClassName] != null) {
				return _generatedMultinames[generatedClassName] as Multiname;
			} else {
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
				var nss:NamespaceSet = new NamespaceSet(nsa);
				var multiname:Multiname = new Multiname(MULTINAME_NAME, nss, MultinameKind.MULTINAME);
				_generatedMultinames[generatedClassName] = multiname;
				LOGGER.debug("Created multiname for proxy class {0}:\n{1}", [generatedClassName, multiname]);
				return multiname;
			}
		}

		/**
		 *
		 * @param classBuilder
		 * @param type
		 * @param memberInfo
		 * @param event
		 * @param nsMultiname
		 * @param bytecodeQname
		 */
		protected function createProxiedMethod(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo, event:ProxyFactoryBuildEvent, nsMultiname:Multiname, bytecodeQname:QualifiedName):void {
			var methodBuilder:IMethodBuilder = methodProxyFactory.proxyMethod(classBuilder, type, memberInfo, true);
			event = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.BEFORE_METHOD_BODY_BUILD, methodBuilder);
			dispatchEvent(event);
			methodBuilder = event.methodBuilder;
			if (methodBuilder == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_BUILDER_IS_NULL, "ProxyFactoryBuildEvent");
			}
			if (methodBuilder.opcodes.length < 1) {
				methodProxyFactory.addMethodBody(methodBuilder, nsMultiname, bytecodeQname, type.isInterface);
			}
			event = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.AFTER_METHOD_BODY_BUILD, methodBuilder);
			dispatchEvent(event);
			LOGGER.debug("Generated proxy method {0}", [memberInfo.qName]);
		}

		/**
		 * Generates a sequence of 20 random lower case characters.
		 * @return The generated sequence of characters.
		 */
		protected function generateSuffix():String {
			var len:int = 20;
			var result:Array = new Array(20);
			while (len) {
				result[len--] = CHARACTERS.charAt(Math.floor(Math.random() * 26));
			}
			return PROXY_PACKAGE_NAME_PREFIX + result.join('');
		}

		/**
		 * Determines if the specified <code>NamespaceKind</code> can be proxied or not.
		 * @param namespaceKind The specified <code>NamespaceKind</code>.
		 * @return <code>True</code> if the specified <code>NamespaceKind</code> can be proxied.
		 */
		protected function isEligibleForProxy(member:MetadataContainer, scope:ProxyScope, namespaces:Array):Boolean {
			CONFIG::debug {
				Assert.notNull(member, "member argument must not be null");
			}
			if ((member[IS_STATIC_FIELD_NAME] == true) || (member[IS_FINAL_FIELD_NAME] == true)) {
				return false;
			}
			var result:Boolean = false;
			switch (scope) {
				case ProxyScope.ALL:
					result = ((NamespaceKind(member[VISIBILITY_FIELD_NAME]) === NamespaceKind.PACKAGE_NAMESPACE) || (NamespaceKind(member[VISIBILITY_FIELD_NAME]) === NamespaceKind.PROTECTED_NAMESPACE) || (NamespaceKind(member[VISIBILITY_FIELD_NAME]) === NamespaceKind.NAMESPACE));
					break;
				case ProxyScope.PUBLIC:
					result = ((NamespaceKind(member[VISIBILITY_FIELD_NAME]) === NamespaceKind.PACKAGE_NAMESPACE));
					break;
				case ProxyScope.PROTECTED:
					result = ((NamespaceKind(member[VISIBILITY_FIELD_NAME]) === NamespaceKind.PROTECTED_NAMESPACE));
					break;
				case ProxyScope.PUBLIC_PROTECTED:
					result = ((NamespaceKind(member[VISIBILITY_FIELD_NAME]) === NamespaceKind.PACKAGE_NAMESPACE) || (NamespaceKind(member[VISIBILITY_FIELD_NAME]) === NamespaceKind.PROTECTED_NAMESPACE));
					break;
				case ProxyScope.NONE:
					result = false;
					break;
			}
			if ((!result) && (namespaces != null)) {
				for each (var ns:String in namespaces) {
					if (member[NAMESPACE_URI_FIELD_NAME] == ns) {
						result = true;
						break;
					}
				}
			}
			return result;
		}

		/**
		 *
		 * @param event
		 */
		protected function proxyCreatedHandler(event:ProxyCreationEvent):void {
			var cls:Class;
			if (event.proxyInstance is Proxy) {
				cls = ClassUtils.forInstance(event.proxyInstance);
			} else {
				cls = Object(event.proxyInstance).constructor as Class;
			}
			var proxyInfo:ProxyInfo = _proxyClassLookup[cls];
			if (proxyInfo != null) {
				var factoryEvent:ProxyFactoryEvent = new ProxyFactoryEvent(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, proxyInfo.proxiedClass, event.proxyConstructorArgs, proxyInfo.methodInvocationInterceptorClass);
				dispatchEvent(factoryEvent);
				var interceptorInstance:IMethodInvocationInterceptor;
				if (factoryEvent.methodInvocationInterceptor != null) {
					interceptorInstance = factoryEvent.methodInvocationInterceptor;
					LOGGER.debug("Received method invocation interceptor '{0}' through factory event", [factoryEvent.methodInvocationInterceptor]);
				} else {
					if (proxyInfo.interceptorFactory == null) {
						interceptorInstance = new proxyInfo.methodInvocationInterceptorClass();
						LOGGER.debug("Received method invocation interceptor '{0}' through proxyInfo.methodInvocationInterceptorClass property", [interceptorInstance]);
					} else {
						interceptorInstance = proxyInfo.interceptorFactory.newInstance();
						LOGGER.debug("Received method invocation interceptor '{0}' through proxyInfo.interceptorFactory.newInstance() factory method", [interceptorInstance]);
					}
				}
				event.methodInvocationInterceptor = interceptorInstance;
			}
		}

		/**
		 * Redispatches the specified event.
		 * @param event The specified event.
		 */
		protected function redispatch(event:Event):void {
			if (event.type == Event.COMPLETE) {
				for (var obj:* in _classProxyLookup) {
					var proxyInfo:ProxyInfo = _classProxyLookup[obj];
					try {
						proxyInfo.proxyClass = proxyInfo.applicationDomain.getDefinition(proxyInfo.proxyClassName) as Class;
					} catch (e:Error) {
						throw new ProxyBuildError(ProxyBuildError.UNABLE_TO_RETRIEVE_PROXY_CLASS_ERROR, proxyInfo.proxyClassName);
					}
					_proxyClassLookup[proxyInfo.proxyClass] = proxyInfo;
				}
			}
			_abcBuilder.removeEventListener(Event.COMPLETE, redispatch);
			_abcBuilder.removeEventListener(IOErrorEvent.IO_ERROR, redispatch);
			_abcBuilder = null;
			dispatchEvent(event);
		}

		/**
		 *
		 * @param event
		 */
		protected function redispatchBuilderEvent(event:ProxyFactoryBuildEvent):void {
			dispatchEvent(event.clone());
		}

		/**
		 *
		 * @param classProxyInfo
		 * @param type
		 * @param applicationDomain
		 */
		protected function reflectAccessors(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			CONFIG::debug {
				Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
				Assert.notNull(type, "type argument must not be null");
				Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			}
			for each (var accessor:Accessor in type.accessors) {
				var byteCodeAccessor:ByteCodeAccessor = accessor as ByteCodeAccessor;
				if (byteCodeAccessor != null) {
					if ((byteCodeAccessor.declaringType.name == null) || (byteCodeAccessor.declaringType.name == OBJECT_DECLARINGTYPE_NAME)) {
						continue;
					}
					if (!isEligibleForProxy(byteCodeAccessor, classProxyInfo.proxyAccessorScopes, classProxyInfo.proxyAccessorNamespaces)) {
						continue;
					}
					classProxyInfo.proxyAccessor(byteCodeAccessor.name, byteCodeAccessor.namespaceURI);
					LOGGER.debug("Added accessor '{0}::{1}' to be proxied", [byteCodeAccessor.namespaceURI, byteCodeAccessor.name]);
				}
			}
		}

		/**
		 *
		 * @param classProxyInfo
		 * @param type
		 * @param applicationDomain
		 */
		protected function reflectInterfaceAccessors(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			CONFIG::debug {
				Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
				Assert.notNull(type, "type argument must not be null");
				Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			}
			for each (var byteCodeAccessor:ByteCodeAccessor in type.accessors) {
				if ((byteCodeAccessor.declaringType.name != null) && (byteCodeAccessor.declaringType.name != OBJECT_DECLARINGTYPE_NAME)) {
					classProxyInfo.proxyInterfaceAccessor(byteCodeAccessor.name, type);
					LOGGER.debug("Added interface accessor '{0}' to be proxied", [byteCodeAccessor.name]);
				}
			}
			LOGGER.debug("ClassInfoProxy for class {0}, added interface accessors of interface {1}", [classProxyInfo.proxiedClass, type.fullName]);
		}

		/**
		 *
		 * @param classProxyInfo
		 * @param type
		 * @param applicationDomain
		 */
		protected function reflectInterfaceMethods(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			CONFIG::debug {
				Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
				Assert.notNull(type, "type argument must not be null");
				Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			}
			for each (var byteCodeMethod:ByteCodeMethod in type.methods) {
				if ((byteCodeMethod.declaringType.name != null) && (byteCodeMethod.declaringType.name != OBJECT_DECLARINGTYPE_NAME)) {
					classProxyInfo.proxyInterfaceMethod(byteCodeMethod.name, type);
					LOGGER.debug("Added interface method '{0}' to be proxied", [byteCodeMethod.name]);
				}
			}
			LOGGER.debug("ClassInfoProxy for class {0}, added interface methods of interface {1}", [classProxyInfo.proxiedClass, type.fullName]);
		}

		/**
		 * Uses the specified <code>ByteCodeType</code> to populate the specified <code>ClassProxyInfo</code> instance with all the public members
		 * of the class specified by the <code>ClassProxyInfo.proxiedClass</code> property.
		 * @param classProxyInfo The specified <code>ClassProxyInfo</code> instance.
		 * @param type The specified <code>ByteCodeType</code> instance.
		 * @param applicationDomain The <code>ApplicationDOmain</code> that the <code>ClassProxyInfo.proxiedClass</code> belongs to.
		 */
		protected function reflectMembers(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			CONFIG::debug {
				Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
				Assert.notNull(type, "type argument must not be null");
				Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			}
			reflectMethods(classProxyInfo, type, applicationDomain);
			reflectAccessors(classProxyInfo, type, applicationDomain);
			LOGGER.debug("ClassInfoProxy for class {0} populated based on reflection", [classProxyInfo.proxiedClass]);
		}

		/**
		 *
		 * @param classProxyInfo
		 * @param type
		 * @param applicationDomain
		 */
		protected function reflectMethods(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			CONFIG::debug {
				Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
				Assert.notNull(type, "type argument must not be null");
				Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			}
			for each (var byteCodeMethod:ByteCodeMethod in type.methods) {
				if (byteCodeMethod != null) {
					if ((byteCodeMethod.declaringType.name == null) || (byteCodeMethod.declaringType.name == OBJECT_DECLARINGTYPE_NAME)) {
						continue;
					}
					if (!isEligibleForProxy(byteCodeMethod, classProxyInfo.proxyMethodScopes, classProxyInfo.proxyMethodNamespaces)) {
						continue;
					}
					classProxyInfo.proxyMethod(byteCodeMethod.name, byteCodeMethod.namespaceURI);
					LOGGER.debug("Added method '{0}::{1}' to be proxied", [byteCodeMethod.namespaceURI, byteCodeMethod.name]);
				}
			}
		}

		/**
		 *
		 * @param accessorProxyFactory
		 */
		protected function removeAccessorProxyFactoryListeners(accessorProxyFactory:IAccessorProxyFactory):void {
			if (accessorProxyFactory != null) {
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_SETTER_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		/**
		 *
		 * @param constructorProxyFactory
		 */
		protected function removeConstructorProxyFactoryListeners(constructorProxyFactory:IConstructorProxyFactory):void {
			if (constructorProxyFactory != null) {
				constructorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
				constructorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		/**
		 *
		 * @param methodProxyFactory
		 */
		protected function removeMethodProxyFactoryListeners(methodProxyFactory:IMethodProxyFactory):void {
			if (methodProxyFactory != null) {
				methodProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_METHOD_BODY_BUILD, redispatchBuilderEvent);
				methodProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_METHOD_BODY_BUILD, redispatchBuilderEvent);
			}
		}
	}
}
