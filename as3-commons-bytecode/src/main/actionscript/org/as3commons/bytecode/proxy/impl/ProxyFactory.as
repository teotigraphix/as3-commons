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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

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
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyCreationEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.IVisibleMember;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaDataContainer;
	import org.as3commons.reflect.Method;

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

		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(ProxyFactory);

		//used namespaces
		use namespace as3commons_bytecode_proxy;

		//private static constants
		private static const CHARACTERS:String = "abcdefghijklmnopqrstuvwxys";
		private static const INTERCEPTOR_PROPERTYNAME:String = "methodInvocationInterceptor";
		private static const NS_FILENAME_SUFFIX:String = '.as$666';
		private static const MULTINAME_NAME:String = "intercept";
		private static const AS3COMMONSBYTECODEPROXY:String = "as3commons_bytecode_proxy";
		private static const ORGAS3COMMONSBYTECODE:String = "org.as3commons.bytecode";
		private static const CONSTRUCTOR:String = "constructor";
		private static const PROXY_PACKAGE_NAME_PREFIX:String = "as3commons_bytecode_generated_";

		//public static constants
		public static var proxyCreationDispatcher:IEventDispatcher = new EventDispatcher();

		//private variables
		private var _isGenerating:Boolean = false;
		private var _generatedMultinames:Dictionary;
		private var _classProxyLookup:Dictionary;
		private var _abcBuilder:IAbcBuilder;
		private var _domains:Dictionary;
		private var _classIntroducer:IClassIntroducer;
		private var _methodProxyFactory:IMethodProxyFactory;
		private var _constructorProxyFactory:IConstructorProxyFactory;
		private var _accessorProxyFactory:IAccessorProxyFactory;

		/**
		 * Creates a new <code>ProxyFactory</code> instance.
		 */
		public function ProxyFactory() {
			super();
			initProxyFactory();
		}

		public function get methodProxyFactory():IMethodProxyFactory {
			if (_methodProxyFactory == null) {
				methodProxyFactory = new MethodProxyFactory();
			}
			return _methodProxyFactory;
		}

		public function set methodProxyFactory(value:IMethodProxyFactory):void {
			removeMethodProxyFactoryListeners(_methodProxyFactory);
			_methodProxyFactory = value;
			addMethodProxyFactoryListeners(_methodProxyFactory);
		}

		public function get constructorProxyFactory():IConstructorProxyFactory {
			if (_constructorProxyFactory == null) {
				constructorProxyFactory = new ConstructorProxyFactory();
			}
			return _constructorProxyFactory;
		}

		public function set constructorProxyFactory(value:IConstructorProxyFactory):void {
			removeConstructorProxyFactoryListeners(_constructorProxyFactory);
			_constructorProxyFactory = value;
			addConstructorProxyFactoryListeners(_constructorProxyFactory);
		}

		public function get accessorProxyFactory():IAccessorProxyFactory {
			if (_accessorProxyFactory == null) {
				accessorProxyFactory = new AccessorProxyFactory();
			}
			return _accessorProxyFactory;
		}

		public function set accessorProxyFactory(value:IAccessorProxyFactory):void {
			removeAccessorProxyFactoryListeners(_accessorProxyFactory);
			_accessorProxyFactory = value;
			addAccessorProxyFactoryListeners(_accessorProxyFactory);
		}

		public function get classIntroducer():IClassIntroducer {
			if (_classIntroducer == null) {
				_classIntroducer = new ClassIntroducer(constructorProxyFactory, methodProxyFactory, accessorProxyFactory);
			}
			return _classIntroducer;
		}

		public function set classIntroducer(value:IClassIntroducer):void {
			_classIntroducer = value;
		}

		/**
		 * A <code>Dictionary</code> lookup of <code>ApplicationDomain</code>-&gt;<code>Array</code>-of-<code>ClassProxyInfo</code>.
		 */
		public function get domains():Dictionary {
			return _domains;
		}

		/**
		 * Initializes the current <code>ProxyFactory</code>.
		 */
		protected function initProxyFactory():void {
			_abcBuilder = new AbcBuilder();
			_domains = new Dictionary();
			_classProxyLookup = new Dictionary();
			_generatedMultinames = new Dictionary();
			LOGGER.debug("ProxyFactory created and initialized");
		}

		protected function addConstructorProxyFactoryListeners(constructorProxyFactory:IConstructorProxyFactory):void {
			if (constructorProxyFactory != null) {
				constructorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
				constructorProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		protected function addMethodProxyFactoryListeners(methodProxyFactory:IMethodProxyFactory):void {
			if (methodProxyFactory != null) {
				methodProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_METHOD_BODY_BUILD, redispatchBuilderEvent);
				methodProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_METHOD_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		protected function removeMethodProxyFactoryListeners(methodProxyFactory:IMethodProxyFactory):void {
			if (methodProxyFactory != null) {
				methodProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_METHOD_BODY_BUILD, redispatchBuilderEvent);
				methodProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_METHOD_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		protected function removeConstructorProxyFactoryListeners(constructorProxyFactory:IConstructorProxyFactory):void {
			if (constructorProxyFactory != null) {
				constructorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
				constructorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_CONSTRUCTOR_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		protected function addAccessorProxyFactoryListeners(accessorProxyFactory:IAccessorProxyFactory):void {
			if (accessorProxyFactory != null) {
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_SETTER_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		protected function removeAccessorProxyFactoryListeners(accessorProxyFactory:IAccessorProxyFactory):void {
			if (accessorProxyFactory != null) {
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_GETTER_BODY_BUILD, redispatchBuilderEvent);
				accessorProxyFactory.removeEventListener(ProxyFactoryBuildEvent.AFTER_SETTER_BODY_BUILD, redispatchBuilderEvent);
			}
		}

		protected function redispatchBuilderEvent(event:ProxyFactoryBuildEvent):void {
			dispatchEvent(event.clone());
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
		 * @inheritDoc
		 */
		public function defineProxy(proxiedClass:Class, methodInvocationInterceptorClass:Class = null, applicationDomain:ApplicationDomain = null):IClassProxyInfo {
			methodInvocationInterceptorClass ||= BasicMethodInvocationInterceptor;
			Assert.state(ClassUtils.isImplementationOf(methodInvocationInterceptorClass, IMethodInvocationInterceptor, applicationDomain) == true, "methodInvocationInterceptorClass argument must be a class that implements IMethodInvocationInterceptor");
			applicationDomain ||= ApplicationDomain.currentDomain;
			if (_domains[applicationDomain] == null) {
				_domains[applicationDomain] = [];
			}
			var infos:Array = _domains[applicationDomain] as Array;
			var info:IClassProxyInfo = new ClassProxyInfo(proxiedClass, methodInvocationInterceptorClass);
			infos[infos.length] = info;
			LOGGER.debug("Defined proxy class for {0}", proxiedClass);
			return info;
		}

		/**
		 * @inheritDoc
		 */
		public function generateProxyClasses():IAbcBuilder {
			_isGenerating = true;
			try {
				for (var domain:* in _domains) {
					var infos:Array = _domains[domain] as Array;
					for each (var info:IClassProxyInfo in infos) {
						var proxyInfo:ProxyInfo = buildProxyClass(info, domain);
						proxyInfo.proxiedClass = info.proxiedClass;
						proxyInfo.interceptorFactory = info.interceptorFactory;
						_classProxyLookup[info.proxiedClass] = proxyInfo;
						proxyInfo.methodInvocationInterceptorClass = info.methodInvocationInterceptorClass;
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

		/**
		 * @inheritDoc
		 */
		public function loadProxyClasses(applicationDomain:ApplicationDomain = null):void {
			if (_isGenerating) {
				throw new ProxyBuildError(ProxyBuildError.PROXY_FACTORY_IS_BUSY_GENERATING);
			}
			applicationDomain ||= ApplicationDomain.currentDomain;
			for (var cls:* in _classProxyLookup) {
				ProxyInfo(_classProxyLookup[cls]).applicationDomain = applicationDomain;
			}
			_abcBuilder.addEventListener(Event.COMPLETE, redispatch);
			_abcBuilder.addEventListener(IOErrorEvent.IO_ERROR, redispatch);
			_abcBuilder.addEventListener(IOErrorEvent.VERIFY_ERROR, redispatch);
			_abcBuilder.buildAndLoad(applicationDomain);
			LOGGER.debug("Loading proxies into application domain {0}", applicationDomain);
		}

		/**
		 * @inheritDoc
		 */
		public function createProxy(clazz:Class, constructorArgs:Array = null):Object {
			var proxyInfo:ProxyInfo = _classProxyLookup[clazz] as ProxyInfo;
			if (proxyInfo != null) {
				if (proxyInfo.proxyClass == null) {
					proxyInfo.proxyClass = proxyInfo.applicationDomain.getDefinition(proxyInfo.proxyClassName) as Class;
				}
				var proxyCreatedHandler:Function = function(event:ProxyCreationEvent):void {
					IEventDispatcher(event.target).removeEventListener(ProxyCreationEvent.PROXY_CREATED, proxyCreatedHandler);
					var factoryEvent:ProxyFactoryEvent = new ProxyFactoryEvent(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, clazz, constructorArgs, proxyInfo.methodInvocationInterceptorClass);
					dispatchEvent(factoryEvent);
					var interceptorInstance:IMethodInvocationInterceptor;
					if (factoryEvent.methodInvocationInterceptor != null) {
						interceptorInstance = factoryEvent.methodInvocationInterceptor;
					} else {
						if (proxyInfo.interceptorFactory == null) {
							interceptorInstance = new proxyInfo.methodInvocationInterceptorClass();
						} else {
							interceptorInstance = proxyInfo.interceptorFactory.newInstance();
						}
					}
					event.methodInvocationInterceptor = interceptorInstance;
				};
				proxyCreationDispatcher.addEventListener(ProxyCreationEvent.PROXY_CREATED, proxyCreatedHandler);
				LOGGER.debug("Creating proxy for class {0} with arguments: {1}", clazz, constructorArgs);
				return ClassUtils.newInstance(proxyInfo.proxyClass, constructorArgs);
			}
			return null;
		}

		/**
		 * Redispatches the specified event.
		 * @param event The specified event.
		 */
		protected function redispatch(event:Event):void {
			_abcBuilder.removeEventListener(Event.COMPLETE, redispatch);
			_abcBuilder.removeEventListener(IOErrorEvent.IO_ERROR, redispatch);
			_abcBuilder.removeEventListener(IOErrorEvent.VERIFY_ERROR, redispatch);
			dispatchEvent(event);
		}

		/**
		 * Generates the <code>Class</code> specified by the <code>ClassProxyInfo</code> using the emit API.
		 * @param classProxyInfo The specified <code>ClassProxyInfo</code>.
		 * @param applicationDomain The application domain the proxied <code>Class</code> belongs to.
		 * @return A <code>ProxyInfo</code> instance.
		 * @throws org.as3commons.bytecode.proxy.error.ProxyError When the proxied class is marked as final.
		 */
		protected function buildProxyClass(classProxyInfo:IClassProxyInfo, applicationDomain:ApplicationDomain):ProxyInfo {
			var className:String = ClassUtils.getFullyQualifiedName(classProxyInfo.proxiedClass);
			var type:ByteCodeType = ByteCodeType.forName(className.replace(MultinameUtil.DOUBLE_COLON, MultinameUtil.PERIOD), applicationDomain);
			if (type.isFinal) {
				throw new ProxyBuildError(ProxyBuildError.FINAL_CLASS_ERROR, className);
			}
			var classParts:Array = className.split(MultinameUtil.DOUBLE_COLON);
			var packageName:String = classParts[0] + MultinameUtil.PERIOD + generateSuffix();
			var packageBuilder:IPackageBuilder = _abcBuilder.definePackage(packageName);

			var classBuilder:IClassBuilder = packageBuilder.defineClass(classParts[1], (type.isInterface ? null : className));
			addMetadata(classBuilder, type.metaData);
			if ((type.isDynamic == false) && (classProxyInfo.makeDynamic == true)) {
				classBuilder.isDynamic = true;
			} else {
				classBuilder.isDynamic = type.isDynamic;
			}
			classBuilder.isFinal = true;
			if (type.isInterface) {
				classBuilder.implementInterface(type.fullName);
			}

			var proxyClassName:String = packageName + MultinameUtil.SINGLE_COLON + classParts[1];
			var nsMultiname:Multiname = createMultiname(proxyClassName, classParts.join(MultinameUtil.SINGLE_COLON), type.extendsClasses);
			var bytecodeQname:QualifiedName = addInterceptorProperty(classBuilder);

			for each (var introducedClassName:String in classProxyInfo.introductions) {
				classIntroducer.introduce(introducedClassName, classBuilder);
			}

			var ctorBuilder:ICtorBuilder = constructorProxyFactory.addConstructor(classBuilder, type, classProxyInfo);
			constructorProxyFactory.addConstructorBody(ctorBuilder, bytecodeQname, nsMultiname);

			if ((classProxyInfo.proxyAll == true) && (classProxyInfo.onlyProxyConstructor == false)) {
				reflectMembers(classProxyInfo, type, applicationDomain);
			}
			if (classProxyInfo.proxyAllAccessors == true) {
				reflectAccessors(classProxyInfo, type, applicationDomain);
			}
			if (classProxyInfo.proxyAllMethods == true) {
				reflectMethods(classProxyInfo, type, applicationDomain);
			}

			var memberInfo:MemberInfo;
			var event:ProxyFactoryBuildEvent;
			for each (memberInfo in classProxyInfo.methods) {
				var methodBuilder:IMethodBuilder = methodProxyFactory.proxyMethod(classBuilder, type, memberInfo);
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
			}

			for each (memberInfo in classProxyInfo.accessors) {
				accessorProxyFactory.proxyAccessor(classBuilder, type, memberInfo, nsMultiname, bytecodeQname);
			}

			dispatchEvent(new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.AFTER_PROXY_BUILD, null, classBuilder, classProxyInfo.proxiedClass));
			LOGGER.debug("Generated proxy class {0} for class {1}", proxyClassName, classProxyInfo.proxiedClass);
			return new ProxyInfo(proxyClassName.split(MultinameUtil.SINGLE_COLON).join(MultinameUtil.PERIOD));
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
				LOGGER.debug("Created multiname for proxy class {0}:\n{1}", generatedClassName, multiname);
				return multiname;
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
			Assert.notNull(classBuilder, "classBuilder argument must not be null");
			var className:String = ClassUtils.getFullyQualifiedName(IMethodInvocationInterceptor);
			var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty(INTERCEPTOR_PROPERTYNAME, className);
			propertyBuilder.namespaceURI = as3commons_bytecode_proxy;
			return new QualifiedName(AS3COMMONSBYTECODEPROXY, new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, ORGAS3COMMONSBYTECODE));
		}

		/**
		 * Uses the specified <code>ByteCodeType</code> to populate the specified <code>ClassProxyInfo</code> instance with all the public members
		 * of the class specified by the <code>ClassProxyInfo.proxiedClass</code> property.
		 * @param classProxyInfo The specified <code>ClassProxyInfo</code> instance.
		 * @param type The specified <code>ByteCodeType</code> instance.
		 * @param applicationDomain The <code>ApplicationDOmain</code> that the <code>ClassProxyInfo.proxiedClass</code> belongs to.
		 */
		protected function reflectMembers(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			reflectMethods(classProxyInfo, type, applicationDomain);
			reflectAccessors(classProxyInfo, type, applicationDomain);
			LOGGER.debug("ClassInfoProxy for class {0} populated based on reflection", classProxyInfo.proxiedClass);
		}

		protected function reflectMethods(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			for each (var method:Method in type.methods) {
				var byteCodeMethod:ByteCodeMethod = method as ByteCodeMethod;
				if (byteCodeMethod != null) {
					if (!isEligibleForProxy(byteCodeMethod)) {
						continue;
					}
					classProxyInfo.proxyMethod(byteCodeMethod.name, byteCodeMethod.namespaceURI);
				}
			}
		}

		protected function reflectAccessors(classProxyInfo:IClassProxyInfo, type:ByteCodeType, applicationDomain:ApplicationDomain):void {
			Assert.notNull(classProxyInfo, "classProxyInfo argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			for each (var accessor:Accessor in type.accessors) {
				var byteCodeAccessor:ByteCodeAccessor = accessor as ByteCodeAccessor;
				if (byteCodeAccessor != null) {
					if (!isEligibleForProxy(byteCodeAccessor)) {
						continue;
					}
					classProxyInfo.proxyAccessor(byteCodeAccessor.name, byteCodeAccessor.namespaceURI);
				}
			}
		}

		/**
		 * Determines if the specified <code>NamespaceKind</code> can be proxied or not.
		 * @param namespaceKind The specified <code>NamespaceKind</code>.
		 * @return <code>True</code> if the specified <code>NamespaceKind</code> can be proxied.
		 */
		protected function isEligibleForProxy(member:MetaDataContainer):Boolean {
			Assert.notNull(member, "member argument must not be null");
			if ((member['isStatic'] == true) || (member['isFinal'] == true)) {
				return false;
			}
			return ((NamespaceKind(member['visibility']) === NamespaceKind.PACKAGE_NAMESPACE) || (NamespaceKind(member['visibility']) === NamespaceKind.PROTECTED_NAMESPACE) || (NamespaceKind(member['visibility']) === NamespaceKind.NAMESPACE));
		}


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

	}
}