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
	import org.as3commons.bytecode.emit.IMetadataContainer;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.event.AccessorBuilderEvent;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.emit.impl.MetaDataArgument;
	import org.as3commons.bytecode.emit.impl.MethodBuilder;
	import org.as3commons.bytecode.interception.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.proxy.IClassIntroducer;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyCreationEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeParameter;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.IVisibleMember;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
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
	[Event(name="beforeSetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="beforeMethodBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="beforeConstructorBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
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

		//public static constants
		public static var proxyCreationDispatcher:IEventDispatcher = new EventDispatcher();

		//private variables
		private var _generatedMultinames:Dictionary;
		private var _classProxyLookup:Dictionary;
		private var _abcBuilder:IAbcBuilder;
		private var _domains:Dictionary;
		private var _classIntroducer:IClassIntroducer;
		private var _methodProxyFactory:MethodProxyFactory;
		private var _namespaceQualifiedName:QualifiedName = new QualifiedName("Namespace", LNamespace.PUBLIC, MultinameKind.QNAME);
		private var _arrayQualifiedName:QualifiedName = new QualifiedName("Array", LNamespace.PUBLIC, MultinameKind.QNAME);
		private var _invocationKindQualifiedName:QualifiedName = new QualifiedName("InvocationKind", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.interception"), MultinameKind.QNAME);
		private var _interceptorQName:QualifiedName = new QualifiedName("methodInvocationInterceptor", LNamespace.PUBLIC);
		private var _interceptorRTQName:RuntimeQualifiedName = new RuntimeQualifiedName("methodInvocationInterceptor", MultinameKind.RTQNAME);
		private var _interceptQName:QualifiedName = new QualifiedName("intercept", new LNamespace(NamespaceKind.NAMESPACE, "org.as3commons.bytecode.interception:IMethodInvocationInterceptor"));
		private var _proxyEventQName:QualifiedName = new QualifiedName("ProxyCreationEvent", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.proxy.event"));
		private var _proxyEventTypeQName:QualifiedName = new QualifiedName("PROXY_CREATED", LNamespace.PUBLIC);
		private var _proxyFactoryQName:QualifiedName = new QualifiedName("ProxyFactory", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.proxy.impl"));
		private var _dispatchEventQName:QualifiedName = new QualifiedName("dispatchEvent", new LNamespace(NamespaceKind.NAMESPACE, "flash.events:IEventDispatcher"));
		private var _proxyCreationDispatcherQName:QualifiedName = new QualifiedName("proxyCreationDispatcher", LNamespace.PUBLIC);
		private var _ConstructorKindQName:QualifiedName = new QualifiedName("CONSTRUCTOR", LNamespace.PUBLIC);
		private var _MethodKindQName:QualifiedName = new QualifiedName("METHOD", LNamespace.PUBLIC);
		private var _GetterKindQName:QualifiedName = new QualifiedName("GETTER", LNamespace.PUBLIC);
		private var _SetterKindQName:QualifiedName = new QualifiedName("SETTER", LNamespace.PUBLIC);
		private var _qnameQname:QualifiedName = new QualifiedName("QName", LNamespace.PUBLIC);
		private var _concatQName:QualifiedName = new QualifiedName("concat", LNamespace.BUILTIN);

		/**
		 * Creates a new <code>ProxyFactory</code> instance.
		 */
		public function ProxyFactory() {
			super();
			initProxyFactory();
		}


		public function get classIntroducer():IClassIntroducer {
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
			_methodProxyFactory = new MethodProxyFactory();
			_classIntroducer = new ClassIntroducer(_methodProxyFactory);
			LOGGER.debug("ProxyFactory created and initialized");
		}

		/**
		 * Generates a sequence of 20 random lower case characters.
		 * @return The generated sequence of characters.
		 */
		protected function generateSuffix():String {
			var len:int = 20;
			var result:Array = new Array(20);
			while (len--) {
				result[len] = CHARACTERS.charAt(Math.floor(Math.random() * 26));
			}
			return result.join('');
		}

		/**
		 * @inheritDoc
		 */
		public function defineProxy(proxiedClass:Class, methodInvocationInterceptorClass:Class = null, applicationDomain:ApplicationDomain = null):IClassProxyInfo {
			methodInvocationInterceptorClass = (methodInvocationInterceptorClass != null) ? methodInvocationInterceptorClass : BasicMethodInvocationInterceptor;
			Assert.state(ClassUtils.isImplementationOf(methodInvocationInterceptorClass, IMethodInvocationInterceptor, applicationDomain) == true, "methodInvocationInterceptorClass argument must be a class that implements IMethodInvocationInterceptor");
			applicationDomain = (applicationDomain != null) ? applicationDomain : ApplicationDomain.currentDomain;
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
			_domains = new Dictionary();
			LOGGER.debug("Finished generating proxy classes");
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
			applicationDomain = (applicationDomain != null) ? applicationDomain : ApplicationDomain.currentDomain;
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
				proxyCreationDispatcher.addEventListener(ProxyCreationEvent.PROXY_CREATED, function(event:ProxyCreationEvent):void {
					proxyCreationDispatcher.removeEventListener(ProxyCreationEvent.PROXY_CREATED, arguments.callee);
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
				});
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
			var ctorBuilder:ICtorBuilder = addConstructor(classBuilder, type, classProxyInfo);
			addConstructorBody(ctorBuilder, bytecodeQname, nsMultiname);

			var accessorBuilder:IAccessorBuilder;
			if ((classProxyInfo.proxyAll == true) && (classProxyInfo.onlyProxyConstructor == false)) {
				reflectMembers(classProxyInfo, type, applicationDomain);
			}

			var memberInfo:MemberInfo;
			for each (memberInfo in classProxyInfo.methods) {
				var methodBuilder:IMethodBuilder = _methodProxyFactory.proxyMethod(classBuilder, type, memberInfo);
				addMethodBody(methodBuilder, nsMultiname, bytecodeQname, type.isInterface);
			}

			for each (memberInfo in classProxyInfo.accessors) {
				accessorBuilder = proxyAccessor(classBuilder, type, memberInfo, nsMultiname, bytecodeQname);
			}

			for each (var introducedClassName:String in classProxyInfo.introductions) {
				_classIntroducer.introduce(introducedClassName, classBuilder);
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
		 * Defines a constructor on the specified <code>IClassBuilder</code> with the same arguments as the proxied class
		 * plus one extra argument that represents the <code>IMethodInvocationInterceptor</code> which will be injected into
		 * the proxy instance.
		 * @param classBuilder The specified <code>IClassBuilder</code>.
		 * @param type The <code>ByteCodeType</code> instance used to retrieve the constructor argument information.
		 * @param classProxyInfo The <code>ClassProxyInfo</code> that specified the <code>IMethodInvocationInterceptor</code> class.
		 * @return A <code>ICtorBuilder</code> instance that represents the generated constructor.
		 */
		protected function addConstructor(classBuilder:IClassBuilder, type:ByteCodeType, classProxyInfo:IClassProxyInfo):ICtorBuilder {
			var ctorBuilder:ICtorBuilder = classBuilder.defineConstructor();
			//var interceptorClassName:String = ClassUtils.getFullyQualifiedName(IMethodInvocationInterceptor);
			//ctorBuilder.defineArgument(interceptorClassName);
			for each (var param:ByteCodeParameter in type.constructor.parameters) {
				ctorBuilder.defineArgument(param.type.fullName, param.isOptional, param.defaultValue);
			}
			return ctorBuilder;
		}

		/**
		* Creates the necessary opcodes that represent the constructor's method body. It assigns the first parameter (the <code>IMethodInvocationInterceptor</code> instance)
		* to the <code>methodInvocationInterceptor</code> property generated by the <code>addInterceptorProperty()</code> method, then it invokes the <code>intercept()</code>
		* method on the <code>IMethodInvocationInterceptor</code> instance and passes the current instance, <code>InvocationKind.CONSTRUCTOR</code>, null and an <code>Array</code>
		* that holds the constructor arguments to it.
		* <p>The actionscript for such a constructor would look like this:</p>
		* <listing version="3.0">
		* public function ProxySubClass(interceptor:IMethodInvocationInterceptor, target:IEventDispatcher = null, somethingElse:Object = null) {
		* 	as3commons_bytecode_proxy::methodInvocationInterceptor = interceptor;
		* 	var params:Array = [target, somethingElse];
		* 	interceptor.intercept(this, InvocationKind.CONSTRUCTOR, null, params);
		* 	super(params[0], params[1]);
		* }
		* </listing>
		* <p>This allows the constructor arguments to be potentially changed by an <code>IInterceptor</code> instance.</p>
		* @param ctorBuilder The specified <code>ICtorBuilder</code> instance that will receieve the generated method body.
		* @param bytecodeQname The <code>QualifiedName</code> instance which is used for the <code>Opcode.findpropstrict</code> and <code>Opcode.getproperty</code> to retrieve the <code>as3commons_bytecode_proxy</code> namespace.
		* @param multiName The <code>Multiname</code> instance used as the parameter for the <code>Opcode.callproperty</code> opcode.
		*/
		protected function addConstructorBody(ctorBuilder:ICtorBuilder, bytecodeQname:QualifiedName, multiName:Multiname):void {
			var event:ProxyFactoryBuildEvent = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.BEFORE_CONSTRUCTOR_BODY_BUILD, ctorBuilder);
			dispatchEvent(event);
			ctorBuilder = event.methodBuilder as ICtorBuilder;
			if (ctorBuilder == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_BUILDER_IS_NULL, "ProxyFactoryBuildEvent");
			}
			if (ctorBuilder.opcodes.length > 0) {
				return;
			}
			var len:int = ctorBuilder.arguments.length;
			var paramLocal:int = len + 1;
			var eventLocal:int = paramLocal++;
			ctorBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.findpropstrict, [_proxyEventQName]) //
				.addOpcode(Opcode.findpropstrict, [_proxyEventQName]) //
				.addOpcode(Opcode.getproperty, [_proxyEventQName]) //
				.addOpcode(Opcode.getproperty, [_proxyEventTypeQName]) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.constructprop, [_proxyEventQName, 2]) //
				.addOpcode(Opcode.coerce, [_proxyEventQName]) //
				.addOpcode(Opcode.setlocal, [eventLocal]) //
				.addOpcode(Opcode.findpropstrict, [_proxyFactoryQName]) //
				.addOpcode(Opcode.getproperty, [_proxyFactoryQName]) //
				.addOpcode(Opcode.getproperty, [_proxyCreationDispatcherQName]) //
				.addOpcode(Opcode.getlocal, [eventLocal]) //
				.addOpcode(Opcode.callproperty, [_dispatchEventQName, 1]) //
				.addOpcode(Opcode.pop) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.findpropstrict, [_interceptorRTQName]) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.getlocal, [eventLocal]) //
				.addOpcode(Opcode.getproperty, [_interceptorQName]) //
				.addOpcode(Opcode.setproperty, [_interceptorRTQName]);
			if (len > 0) {
				for (var i:int = 0; i < len; ++i) {
					var idx:int = i + 1;
					switch (idx) {
						case 1:
							ctorBuilder.addOpcode(Opcode.getlocal_1);
							break;
						case 2:
							ctorBuilder.addOpcode(Opcode.getlocal_2);
							break;
						case 3:
							ctorBuilder.addOpcode(Opcode.getlocal_3);
							break;
						default:
							ctorBuilder.addOpcode(Opcode.getlocal, [idx]);
							break;
					}
				}
				ctorBuilder.addOpcode(Opcode.newarray, [len]) //
					.addOpcode(Opcode.coerce, [_arrayQualifiedName]) //
					.addOpcode(Opcode.setlocal, [paramLocal]) //
					.addOpcode(Opcode.getlocal, [eventLocal]) //
					.addOpcode(Opcode.getproperty, [_interceptorQName]) //
					.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.findpropstrict, [_invocationKindQualifiedName]) //
					.addOpcode(Opcode.getproperty, [_invocationKindQualifiedName]) //
					.addOpcode(Opcode.getproperty, [_ConstructorKindQName]) //
					.addOpcode(Opcode.pushnull) //
					.addOpcode(Opcode.getlocal, [paramLocal]) //
					.addOpcode(Opcode.callproperty, [_interceptQName, 4]) //
					.addOpcode(Opcode.pop) //
					.addOpcode(Opcode.getlocal_0);
				for (i = 0; i < len; ++i) {
					ctorBuilder.addOpcode(Opcode.getlocal, [paramLocal]) //
						.addOpcode(Opcode.pushbyte, [i]) //
						.addOpcode(Opcode.getproperty, [new MultinameL(multiName.namespaceSet)]) //
				}
			} else {
				ctorBuilder.addOpcode(Opcode.getlocal_1) //
					.addOpcode(Opcode.getproperty, [_interceptorQName]) //
					.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.findpropstrict, [_invocationKindQualifiedName]) //
					.addOpcode(Opcode.getproperty, [_invocationKindQualifiedName]) //
					.addOpcode(Opcode.getproperty, [_ConstructorKindQName]) //
					.addOpcode(Opcode.pushnull) //
					.addOpcode(Opcode.pushnull) //
					.addOpcode(Opcode.callproperty, [_interceptQName, 4]) //
					.addOpcode(Opcode.pop) //
					.addOpcode(Opcode.getlocal_0); //
			}
			ctorBuilder.addOpcode(Opcode.constructsuper, [len]) //
				.addOpcode(Opcode.returnvoid);
			LOGGER.debug("Constructor generated");
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
			var vsb:NamespaceKind;
			for each (var method:Method in type.methods) {
				var byteCodeMethod:ByteCodeMethod = method as ByteCodeMethod;
				if (byteCodeMethod != null) {
					if (!isEligibleForProxy(byteCodeMethod)) {
						continue;
					}
					classProxyInfo.proxyMethod(byteCodeMethod.name, byteCodeMethod.namespaceURI);
				}
			}
			for each (var accessor:Accessor in type.accessors) {
				var byteCodeAccessor:ByteCodeAccessor = accessor as ByteCodeAccessor;
				if (byteCodeAccessor != null) {
					if (!isEligibleForProxy(byteCodeAccessor)) {
						continue;
					}
					classProxyInfo.proxyAccessor(byteCodeAccessor.name, byteCodeAccessor.namespaceURI);
				}
			}
			LOGGER.debug("ClassInfoProxy for class {0} populated based on reflection", classProxyInfo.proxiedClass);
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
				case NamespaceKind.NAMESPACE:
					return MemberVisibility.NAMESPACE;
					break;
				default:
					return MemberVisibility.PUBLIC;
					break;
			}
		}

		/**
		 * Creates an overridden accessor on the specified <code>IClassBuilder</code> instance. Which accessor is determined by the specified <code>MemberInfo</code>
		 * instance.
		 * @param classBuilder The specified <code>IClassBuilder</code> instance.
		 * @param type The specified <code>ByteCodeType</code> instance.
		 * @param memberInfo The specified <code>MemberInfo</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 * @return The <code>IAccessorBuilder</code> representing the generated accessor.
		 * @throws org.as3commons.bytecode.proxy.error.ProxyError When the proxied accessor is marked as final.
		 */
		protected function proxyAccessor(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo, multiName:Multiname, bytecodeQname:QualifiedName):IAccessorBuilder {
			Assert.notNull(classBuilder, "classBuilder argument must not be null");
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(memberInfo, "memberInfo argument must not be null");
			var accessor:ByteCodeAccessor = type.getField(memberInfo.qName.localName, memberInfo.qName.uri) as ByteCodeAccessor;
			if (accessor == null) {
				throw new ProxyBuildError(ProxyBuildError.ACCESSOR_NOT_EXISTS, classBuilder.name, memberInfo.qName.localName);
			}
			if (accessor.isFinal) {
				throw new ProxyBuildError(ProxyBuildError.FINAL_ACCESSOR_ERROR, accessor.name);
			}
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor(accessor.name, accessor.type.fullName, accessor.initializedValue);
			addMetadata(accessorBuilder, accessor.metaData);
			accessorBuilder.namespaceURI = accessor.namespaceURI;
			accessorBuilder.scopeName = accessor.scopeName;
			accessorBuilder.isOverride = (!type.isInterface);
			accessorBuilder.access = accessor.access;
			accessorBuilder.createPrivateProperty = false;
			accessorBuilder.visibility = (!type.isInterface) ? getMemberVisibility(accessor) : MemberVisibility.PUBLIC;
			accessorBuilder.addEventListener(AccessorBuilderEvent.BUILD_GETTER, function(event:AccessorBuilderEvent):void {
				accessorBuilder.removeEventListener(AccessorBuilderEvent.BUILD_GETTER, arguments.callee);
				event.builder = createGetter(event.accessorBuilder, multiName, bytecodeQname, type.isInterface);
			});
			accessorBuilder.addEventListener(AccessorBuilderEvent.BUILD_SETTER, function(event:AccessorBuilderEvent):void {
				accessorBuilder.removeEventListener(AccessorBuilderEvent.BUILD_SETTER, arguments.callee);
				event.builder = createSetter(event.accessorBuilder, multiName, bytecodeQname, type.isInterface);
			});
			return accessorBuilder;
		}

		/**
		 * Generates a method body that passes the method's arguments to the generated <code>methodInvocationInterceptor</code> property value's <code>intercept</code> method,
		 * along with a reference to the current instance, a <code>QName</code> for the current method, and a reference to the super method instance.
		 * <p>The actionscript would look like this:</code>
		 * <listing version="3.0">
		 * override public function returnStringWithParameters(param:String):String {
		 *  return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "returnStringWithParameters"), [param], super.returnStringWithParameters);
		 * }
		 * </listing>
		 * <p>A method without parameters will be generated like this:</p>
		 * <listing version="3.0">
		 * override public function returnString():String {
		 *  return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "returnString"), null, super.returnString);
		 * }
		 * </listing>
		 * <p>And, lastly, a method without a return value would end up looking like this:</p>
		 * <listing version="3.0">
		 * override public function voidWithParameters(param:String):void {
		 *  as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.METHOD, new QName("", "voidWithParameters"), [param], super.voidWithParameters);
		 * }
		 * </listing>
		 * @param methodBuilder The specified <code>IMethodBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 */
		protected function addMethodBody(methodBuilder:IMethodBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):void {
			Assert.notNull(methodBuilder, "methodBuilder argument must not be null");
			var event:ProxyFactoryBuildEvent = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.BEFORE_METHOD_BODY_BUILD, methodBuilder);
			dispatchEvent(event);
			methodBuilder = event.methodBuilder;
			if (methodBuilder == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_BUILDER_IS_NULL, "ProxyFactoryBuildEvent");
			}
			if (methodBuilder.opcodes.length > 0) {
				return;
			}
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
				.addOpcode(Opcode.findpropstrict, [_invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_MethodKindQName]) //
				.addOpcode(Opcode.findpropstrict, [_qnameQname]) //
				.addOpcode(Opcode.pushstring, [StringUtils.hasText(methodBuilder.namespaceURI) ? methodBuilder.namespaceURI : ""]) //
				.addOpcode(Opcode.pushstring, [methodBuilder.name]) //
				.addOpcode(Opcode.constructprop, [_qnameQname, 2]) //
			if (len > 0) {
				for (var i:int = 0; i < len; ++i) {
					var idx:int = i + 1;
					switch (idx) {
						case 1:
							methodBuilder.addOpcode(Opcode.getlocal_1);
							break;
						case 2:
							methodBuilder.addOpcode(Opcode.getlocal_2);
							break;
						case 3:
							methodBuilder.addOpcode(Opcode.getlocal_3);
							break;
						default:
							methodBuilder.addOpcode(Opcode.getlocal, [idx]);
							break;
					}
				}
				methodBuilder.addOpcode(Opcode.newarray, [len]);
				if (methodBuilder.hasRestArguments) {
					methodBuilder.addOpcode(Opcode.getlocal, [len + 1]);
					methodBuilder.addOpcode(Opcode.callproperty, [_concatQName, 1]);
				}
			} else if (methodBuilder.hasRestArguments) {
				methodBuilder.addOpcode(Opcode.getlocal_1);
			} else {
				methodBuilder.addOpcode(Opcode.pushnull);
			}
			if (!isInterface) {
				methodBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.getsuper, [methodQName]);
			} else {
				methodBuilder.addOpcode(Opcode.pushnull);
			}
			methodBuilder.addOpcode(Opcode.callproperty, [multiName, 5]);
			if (methodBuilder.returnType == BuiltIns.VOID.fullName) {
				methodBuilder.addOpcode(Opcode.pop) //
					.addOpcode(Opcode.returnvoid);
			} else {
				methodBuilder.addOpcode(Opcode.returnvalue);
			}
		}

		/**
		 * Creates a basic <code>IMethodBuilder</code> for the specified <code>IAccessorBuilder</code>,
		 * it uses the <code>IAccessorBuilder</code> to retrieve the name, namespace, isFinal, and packageName
		 * values.
		 * @param accessorBuilder The specified <code>IAccessorBuilder</code> instance.
		 * @return The new <code>IMethodBuilder</code> instance.
		 */
		protected function createMethod(accessorBuilder:IAccessorBuilder):IMethodBuilder {
			Assert.notNull(accessorBuilder, "accessorBuilder argument must not be null");
			var mb:MethodBuilder = new MethodBuilder();
			mb.name = accessorBuilder.name;
			mb.namespaceURI = accessorBuilder.namespaceURI;
			mb.scopeName = accessorBuilder.scopeName;
			mb.isFinal = accessorBuilder.isFinal;
			mb.isOverride = accessorBuilder.isOverride;
			mb.packageName = accessorBuilder.packageName;
			mb.visibility = accessorBuilder.visibility;
			return mb;
		}

		/**
		 * Generates a getter method for the specified <code>IAccessorBuilder</code> instance.
		 * <p>The specified <code>Multiname</code> and <code>QualifiedName</code> instances are passed on to the <code>addGetterBody()</code> method.
		 * @param accessorBuilder The specified <code>IAccessorBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 * @return The new <code>IMethodBuilder</code> instance.
		 */
		protected function createGetter(accessorBuilder:IAccessorBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):IMethodBuilder {
			var mb:IMethodBuilder = createMethod(accessorBuilder);
			mb.returnType = accessorBuilder.type;
			addGetterBody(mb, multiName, bytecodeQname, isInterface);
			return mb;
		}

		/**
		 * Generates a setter method for the specified <code>IAccessorBuilder</code> instance.
		 * <p>The specified <code>Multiname</code> and <code>QualifiedName</code> instances are passed on to the <code>addSetterBody()</code> method.
		 * @param accessorBuilder The specified <code>IAccessorBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 * @return The new <code>IMethodBuilder</code> instance.
		 */
		protected function createSetter(accessorBuilder:IAccessorBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):IMethodBuilder {
			var mb:IMethodBuilder = createMethod(accessorBuilder);
			mb.returnType = BuiltIns.VOID.fullName;
			mb.defineArgument(accessorBuilder.type);
			addSetterBody(mb, accessorBuilder, multiName, bytecodeQname, isInterface);
			return mb;
		}

		/**
		 * Generates a method body for a getter method in the specified <code>IMethodBuilder</code> instance.
		 * <p>The actionscript for the generated body would look like this:</p>
		 * <listing version="3.0">
		 * override public function get getter():uint {
		 *  return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.GETTER, new QName("", "getter"), [super.getter]);
		 * }
		 * </listing>
		 * <p>It will pass the current value of the getter in the arguments <code>Array</code> so that it may be examined by any <code>IInterceptor</code>
		 * instances.</p>
		 * @param methodBuilder The specified <code>IMethodBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 */
		protected function addGetterBody(methodBuilder:IMethodBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):void {
			Assert.notNull(methodBuilder, "methodBuilder argument must not be null");
			var event:ProxyFactoryBuildEvent = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, methodBuilder);
			dispatchEvent(event);
			methodBuilder = event.methodBuilder;
			if (methodBuilder == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_BUILDER_IS_NULL, "ProxyFactoryBuildEvent");
			}
			if (methodBuilder.opcodes.length > 0) {
				return;
			}
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
				.addOpcode(Opcode.findpropstrict, [_invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_GetterKindQName]) //
				.addOpcode(Opcode.findpropstrict, [_qnameQname]) //
				.addOpcode(Opcode.pushstring, [StringUtils.hasText(methodBuilder.namespaceURI) ? methodBuilder.namespaceURI : ""]) //
				.addOpcode(Opcode.pushstring, [methodBuilder.name]) //
				.addOpcode(Opcode.constructprop, [_qnameQname, 2]) //
			if (!isInterface) {
				methodBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.getsuper, [createMethodQName(methodBuilder)]) //
			} else {
				methodBuilder.addOpcode(Opcode.pushnull);
			}
			methodBuilder.addOpcode(Opcode.newarray, [1]) //
				.addOpcode(Opcode.callproperty, [multiName, 4]) //
				.addOpcode(Opcode.returnvalue);
		}

		/**
		 * Generates a method body for a setter method in the specified <code>IMethodBuilder</code> instance.
		 * <p>The actionscript for the generated body would look like this:</p>
		 * <listing version="3.0">
		 * override public function set setter(value:uint):void {
		 *  super.getterSetter = as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.SETTER, new QName("", "setter"), [value, super.setter]);
		 * }
		 * </listing>
		 * <p>If the specified accessor is read and write enabled it will pass the current value of the getter as the second argument, the first argument is the new value.</p>
		 * <p>In the case of a write only accessor the code will be generated like this:</p>
		 * <listing version="3.0">
		 * override public function set setter(value:uint):void {
		 *  super.getterSetter = as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.SETTER, new QName("", "setter"), [value]);
		 * }
		 * </listing>
		 * <p>In this case the intercepting logic needs to be able to return a valid value for the setter method in the case where the nw value is rejected by some kind of business rule.</p>
		 * @param methodBuilder The specified <code>IMethodBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 */
		protected function addSetterBody(methodBuilder:IMethodBuilder, accessorBuilder:IAccessorBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):void {
			Assert.notNull(methodBuilder, "methodBuilder argument must not be null");
			var event:ProxyFactoryBuildEvent = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, methodBuilder);
			dispatchEvent(event);
			methodBuilder = event.methodBuilder;
			if (methodBuilder == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_BUILDER_IS_NULL, "ProxyFactoryBuildEvent");
			}
			if (methodBuilder.opcodes.length > 0) {
				return;
			}
			var methodQName:QualifiedName = createMethodQName(methodBuilder);
			var argLen:int = 1;
			var superSetter:QualifiedName = (!isInterface) ? createMethodQName(methodBuilder) : null;
			methodBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.findpropstrict, [_interceptorRTQName]) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [_namespaceQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_interceptorRTQName]) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.findpropstrict, [_invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [_SetterKindQName]) //
				.addOpcode(Opcode.findpropstrict, [_qnameQname]) //
				.addOpcode(Opcode.pushstring, [StringUtils.hasText(methodBuilder.namespaceURI) ? methodBuilder.namespaceURI : ""]) //
				.addOpcode(Opcode.pushstring, [methodBuilder.name]) //
				.addOpcode(Opcode.constructprop, [_qnameQname, 2]) //
				.addOpcode(Opcode.getlocal_1);
			if ((accessorBuilder.access === AccessorAccess.READ_WRITE) && (superSetter != null)) {
				methodBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.getsuper, [superSetter]);
				argLen = 2;
			}
			methodBuilder.addOpcode(Opcode.newarray, [argLen]) //
				.addOpcode(Opcode.callproperty, [multiName, 4]);
			if (!isInterface) {
				methodBuilder.addOpcode(Opcode.setsuper, [superSetter]);
			}
			methodBuilder.addOpcode(Opcode.returnvoid);
		}

		/**
		 * Creates a <code>QualifiedName</code> instance for the specified <code>IMethodBuilder</code> to be used
		 * a the parameter for the <code>Opcode.getsuper</code> opcode.
		 * @param methodBuilder The specified <code>IMethodBuilder</code>.
		 * @return The new <code>QualifiedName</code> instance.
		 */
		protected function createMethodQName(methodBuilder:IMethodBuilder):QualifiedName {
			var ns:LNamespace;
			switch (methodBuilder.visibility) {
				case MemberVisibility.PUBLIC:
					ns = LNamespace.PUBLIC;
					break;
				case MemberVisibility.PROTECTED:
					ns = MultinameUtil.toLNamespace(removeProxyPackage(methodBuilder.packageName), NamespaceKind.PROTECTED_NAMESPACE);
					break;
				case MemberVisibility.NAMESPACE:
					ns = new LNamespace(NamespaceKind.NAMESPACE, methodBuilder.namespaceURI);
					break;
			}
			return new QualifiedName(methodBuilder.name, ns);
		}

		protected function removeProxyPackage(packageName:String):String {
			Assert.hasText(packageName, "packageName argument must not be empty or null");
			var parts:Array = packageName.split(MultinameUtil.PERIOD);
			parts.splice(parts.length - 2, 1)
			var newPackage:String = parts.join(MultinameUtil.PERIOD);
			return newPackage;
		}
	}
}