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
package org.as3commons.bytecode.proxy.impl {

	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.describeType;

	import flexunit.framework.TestCase;

	import mx.containers.Canvas;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.impl.MemberInitialization;
	import org.as3commons.bytecode.interception.impl.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.io.AbcDeserializer;
	import org.as3commons.bytecode.io.AbcSerializer;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.ProxyScope;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyCreationEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.testclasses.EventDispatcherExImpl;
	import org.as3commons.bytecode.testclasses.Flavour;
	import org.as3commons.bytecode.testclasses.IEventDispatcherEx;
	import org.as3commons.bytecode.testclasses.IFlavour;
	import org.as3commons.bytecode.testclasses.ITestIntroduction;
	import org.as3commons.bytecode.testclasses.InlineTest;
	import org.as3commons.bytecode.testclasses.ProxySubClass;
	import org.as3commons.bytecode.testclasses.SimpleClassWithAccessors;
	import org.as3commons.bytecode.testclasses.SimpleClassWithCustomNamespaceMethod;
	import org.as3commons.bytecode.testclasses.SimpleClassWithMetadata;
	import org.as3commons.bytecode.testclasses.SimpleClassWithMethodWithOptionalArgs;
	import org.as3commons.bytecode.testclasses.SimpleClassWithOneConstructorArgument;
	import org.as3commons.bytecode.testclasses.SimpleClassWithProtectedMethod;
	import org.as3commons.bytecode.testclasses.SimpleClassWithRestParameters;
	import org.as3commons.bytecode.testclasses.SimpleClassWithTwoConstructorArguments;
	import org.as3commons.bytecode.testclasses.SimpleClassWithTwoMethods;
	import org.as3commons.bytecode.testclasses.SimpleClassWithoutConstructorArgument;
	import org.as3commons.bytecode.testclasses.TestEventDispatcher;
	import org.as3commons.bytecode.testclasses.TestEventDispatcher2;
	import org.as3commons.bytecode.testclasses.TestIntroduction;
	import org.as3commons.bytecode.testclasses.TestProxiedClass;
	import org.as3commons.bytecode.testclasses.interceptors.CtorInterceptorFactory;
	import org.as3commons.bytecode.testclasses.interceptors.CustomInterceptorFactory;
	import org.as3commons.bytecode.testclasses.interceptors.EventDispatcherExInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestAccessorInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestCanvasInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestInterfaceMethodInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestMethodInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestOptionalArgInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestProtectedInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestRestMethodInterceptor;
	import org.as3commons.bytecode.util.ApplicationUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertTrue;

	public class ProxyFactoryTest extends TestCase {

		{
			ProxySubClass;
		}

		private var _proxyFactory:ProxyFactory;
		private var _embeddedName:String;

		public function ProxyFactoryTest(methodName:String = null) {
			super(methodName);
			ByteCodeType.getTypeProvider().clearCache();
			ProxySubClass;
		}

		override public function setUp():void {
			ByteCodeType.fromLoader(ApplicationUtils.application.loaderInfo);
			_proxyFactory = new ProxyFactory();
		}

		override public function tearDown():void {
			ByteCodeType.getTypeProvider().clearCache();
		}

		public function testDefineProxy():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(TestProxiedClass, null, applicationDomain);
			assertStrictlyEquals(TestProxiedClass, classProxyInfo.proxiedClass);
			for (var domain:* in _proxyFactory.domains) {
				assertStrictlyEquals(applicationDomain, domain);
			}
		}

		public function testCreateProxyClasses():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(TestProxiedClass, null, applicationDomain);
			var builder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			assertNotNull(builder);
		}

		public function testLoadProxyClassForClassWithOneCtorParam():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithTwoCtorParams():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithTwoConstructorArguments, null, applicationDomain);
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleConstructorTwoParamsTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithOneCtorParamWithInterceptorFactory():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			classProxyInfo.interceptorFactory = new CtorInterceptorFactory();
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithOneCtorParamWithInterceptorFactoryThatReturnsTestMethodInvocationInterceptor():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			classProxyInfo.interceptorFactory = new CustomInterceptorFactory();
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleCustomFactoryConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithMethodWithOptionalArg():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithMethodWithOptionalArgs, null, applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createOptionalArgInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleOptionalArgTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithoutCtorParams():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithProtectedMethod():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithProtectedMethod, null, applicationDomain);
			classProxyInfo.proxyMethod("multiply");
			classProxyInfo.proxyAccessor("stringValue");
			classProxyInfo.proxyAccessor("stringValue2");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createProtectedMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleProtectedMethodTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithTwoMethods():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithTwoMethods, null, applicationDomain);
			classProxyInfo.proxyMethod("returnString");
			classProxyInfo.proxyMethod("returnStringWithParam");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMethodTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testProxyInterface():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(IFlavour, null, applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createInterfaceMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleFlavourTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		/*public function testLoadProxyClassForCanvas():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			for (var info:* in ApplicationUtils.application.systemManager.preloadedRSLs) {
				ByteCodeType.fromLoader(info);
			}
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(Canvas, null, applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createCanvasInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleCanvasTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}*/

		public function testLoadProxyClassForClassWithCustomnamespaceMethod():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithCustomNamespaceMethod, null, applicationDomain);
			classProxyInfo.proxyMethod("custom", "http://www.as3commons.org/bytecode");
			classProxyInfo.proxyAccessor("customProp", "http://www.as3commons.org/bytecode");
			classProxyInfo.proxyAccessor("customSetProp", "http://www.as3commons.org/bytecode");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMethodCustomNamespaceTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyWithRestParameters():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithRestParameters, null, applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createRestArgumentsMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleRestArgumentsMethodTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassAccessors():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithAccessors, null, applicationDomain);
			classProxyInfo.proxyAccessor("getter");
			classProxyInfo.proxyAccessor("setter");
			classProxyInfo.makeDynamic = true;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createAccessorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleAccessorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithMetadata():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithMetadata, null, applicationDomain);
			classProxyInfo.proxyMethod("simpleMethod");
			classProxyInfo.proxyAccessor("getter");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createAccessorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMetadataTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testDefineMultipleProxies():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			_proxyFactory.defineProxy(Flavour, null, applicationDomain);
			_proxyFactory.defineProxy(IFlavour, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithAccessors, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithCustomNamespaceMethod, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithMetadata, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithMethodWithOptionalArgs, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithoutConstructorArgument, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithProtectedMethod, null, applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithTwoMethods, null, applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createAccessorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMultipleProxiesTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testBusyGeneratingError():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			_proxyFactory.defineProxy(Flavour, null, applicationDomain);
			var func:Function = function(event:ProxyFactoryBuildEvent):void {
				var factory:IProxyFactory = IProxyFactory(event.target);
				try {
					factory.loadProxyClasses();
					fail('loadProxyClass() should not be possible to invoke here.');
				} catch (e:ProxyBuildError) {
					assertEquals(e.errorID, ProxyBuildError.PROXY_FACTORY_IS_BUSY_GENERATING);
				}
			};
			_proxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_PROXY_BUILD, func);
			_proxyFactory.generateProxyClasses();
		}

		public function testSerialization():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			_proxyFactory.defineProxy(Flavour, null, applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleSerializationTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		protected function handleSerializationTestComplete(event:Event):void {
			var proxyFactory:IProxyFactory = event.target as IProxyFactory;
			var instance:Flavour = proxyFactory.createProxy(Flavour) as Flavour;
			assertNotNull(instance);
			var cls:Class = Object(instance).constructor as Class;
			registerClassAlias("org.as3commons.bytecode.testclasses.Flavour", cls);

			var ba:ByteArray = new ByteArray();
			ba.writeObject(instance);
			ba.position = 0;

			try {
				var instance2:Flavour = ba.readObject() as Flavour;
				assertNotNull(instance2);
			} catch (e:Error) {
				fail('instance2 was not properly deserialized');
			}
		}

		public function testNestedSerialization():void {
			_embeddedName = null;
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			_proxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_PROXY_BUILD, addProxiedProperty);
			_proxyFactory.defineProxy(InlineTest, null, applicationDomain);
			_proxyFactory.defineProxy(Flavour, null, applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleNestedSerializationTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function addProxiedProperty(event:ProxyFactoryBuildEvent):void {
			if (_embeddedName == null) {
				_embeddedName = event.classBuilder.packageName + '.' + event.classBuilder.name;
			} else {
				var pb:IPropertyBuilder = event.classBuilder.defineProperty("testNest", _embeddedName);
				pb.memberInitialization = new MemberInitialization();
			}
		}

		protected function handleNestedSerializationTestComplete(event:Event):void {
			var proxyFactory:IProxyFactory = event.target as IProxyFactory;
			var instance:Flavour = proxyFactory.createProxy(Flavour) as Flavour;
			assertNotNull(instance);
			assertNotNull(instance['testNest']);
			var cls:Class = Object(instance).constructor as Class;
			var cls2:Class = Object(instance['testNest']).constructor as Class;
			registerClassAlias("org.as3commons.bytecode.testclasses.Flavour", cls);
			registerClassAlias("org.as3commons.bytecode.testclasses.InlineTest", cls2);

			var ba:ByteArray = new ByteArray();
			ba.writeObject(instance);
			ba.position = 0;

			try {
				var instance2:Flavour = ba.readObject() as Flavour;
				assertNotNull(instance2);
				assertNotNull(instance2['testNest']);
			} catch (e:Error) {
				fail('instance2 was not properly deserialized');
			}
		}

		public function testIntroduction():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(Flavour, null, applicationDomain);
			classProxyInfo.introduce(TestIntroduction);
			var abcBuilder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleIntroductionTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testEventDispatcherIntroduction():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(TestEventDispatcher, null, applicationDomain);
			classProxyInfo.introduce(EventDispatcherExImpl);
			classProxyInfo.proxyMethod("addEventListener");
			classProxyInfo.proxyMethod("removeEventListener");
			var abcBuilder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createEventDispatcherIntroductionInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleEventDispatcherIntroductionTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testMultipleIntroductions():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(TestEventDispatcher, null, applicationDomain);
			classProxyInfo.introduce(EventDispatcherExImpl);
			classProxyInfo.proxyMethod("addEventListener");
			classProxyInfo.proxyMethod("removeEventListener");

			classProxyInfo = _proxyFactory.defineProxy(TestEventDispatcher2, null, applicationDomain);
			classProxyInfo.introduce(EventDispatcherExImpl);
			classProxyInfo.proxyMethod("addEventListener");
			classProxyInfo.proxyMethod("removeEventListener");

			var abcBuilder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createEventDispatcherIntroductionInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMultipleIntroductionTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		protected function handleMultipleProxiesTestComplete(event:Event):void {
			assertTrue(true);
		}

		protected function createEventDispatcherIntroductionInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new EventDispatcherExInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function handleEventDispatcherIntroductionTestComplete(event:Event):void {
			var instance:TestEventDispatcher = _proxyFactory.createProxy(TestEventDispatcher) as TestEventDispatcher;
			assertNotNull(instance);
			var testInterface:IEventDispatcherEx = instance as IEventDispatcherEx;
			assertNotNull(testInterface);
			var func1:Function = function(event:Event):void {
			};
			instance.addEventListener(Event.ACTIVATE, func1, false, 0, true);
			assertEquals(1, testInterface.getCountListeners(Event.ACTIVATE));
		}

		protected function handleMultipleIntroductionTestComplete(event:Event):void {
			var instance:TestEventDispatcher = _proxyFactory.createProxy(TestEventDispatcher) as TestEventDispatcher;
			assertNotNull(instance);
			var testInterface:IEventDispatcherEx = instance as IEventDispatcherEx;
			assertNotNull(testInterface);
			var func1:Function = function(event:Event):void {
			};
			instance.addEventListener(Event.ACTIVATE, func1, false, 0, true);
			assertEquals(1, testInterface.getCountListeners(Event.ACTIVATE));

			var instance2:TestEventDispatcher2 = _proxyFactory.createProxy(TestEventDispatcher2) as TestEventDispatcher2;
			assertNotNull(instance2);
			testInterface = instance2 as IEventDispatcherEx;
			assertNotNull(testInterface);
			instance2.addEventListener(Event.ACTIVATE, func1, false, 0, true);
			assertEquals(1, testInterface.getCountListeners(Event.ACTIVATE));
		}

		protected function handleIntroductionTestComplete(event:Event):void {
			var instance:Flavour = _proxyFactory.createProxy(Flavour) as Flavour;
			assertNotNull(instance);
			var testInterface:ITestIntroduction = instance as ITestIntroduction;
			assertNotNull(testInterface);
			assertEquals("test", testInterface.getTest());
			assertEquals("testString", testInterface.testString);
			assertNotNull(testInterface.testObject);
		}

		protected function createCanvasInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestCanvasInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function createAccessorInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestAccessorInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function createProtectedMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestProtectedInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function createConstructorInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function createOptionalArgInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestOptionalArgInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function createMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestMethodInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function createRestArgumentsMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestRestMethodInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function createInterfaceMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestInterfaceMethodInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function handleFlavourTestComplete(event:Event):void {
			var instance:IFlavour = _proxyFactory.createProxy(IFlavour) as IFlavour;
			assertNotNull(instance);
			instance.add(instance);
			instance.combine(1, 2, 3, 4);
			assertEquals("interceptedReturnValue", instance.toString());
			assertEquals("interceptedGetterValue", instance.name);
			assertEquals(1, instance.ingredients.length);
			assertEquals("interceptedGetterValue", instance.ingredients[0]);
		}

		protected function handleCanvasTestComplete(event:Event):void {
			var instance:Canvas = _proxyFactory.createProxy(Canvas) as Canvas;
			assertNotNull(instance);
		}

		protected function handleOptionalArgTestComplete(event:Event):void {
			var instance:SimpleClassWithMethodWithOptionalArgs = _proxyFactory.createProxy(SimpleClassWithMethodWithOptionalArgs) as SimpleClassWithMethodWithOptionalArgs;
			assertNotNull(instance);
			instance.methodWithOptionalArgs("test");
		}

		protected function handleConstructorTestComplete(event:Event):void {
			var instance:SimpleClassWithOneConstructorArgument = _proxyFactory.createProxy(SimpleClassWithOneConstructorArgument, ["testarg"]) as SimpleClassWithOneConstructorArgument;
			assertNotNull(instance);
			assertEquals('intercepted', instance.string);
		}

		protected function handleConstructorTwoParamsTestComplete(event:Event):void {
			var instance:SimpleClassWithTwoConstructorArguments = _proxyFactory.createProxy(SimpleClassWithTwoConstructorArguments, ["testarg", 1]) as SimpleClassWithTwoConstructorArguments;
			assertNotNull(instance);
			assertEquals('intercepted', instance.string);
		}

		protected function handleCustomFactoryConstructorTestComplete(event:Event):void {
			var instance:SimpleClassWithOneConstructorArgument = _proxyFactory.createProxy(SimpleClassWithOneConstructorArgument, ["testarg"]) as SimpleClassWithOneConstructorArgument;
			assertNotNull(instance);
			assertEquals('testarg', instance.string);
		}

		protected function handleMethodTestComplete(event:Event):void {
			var instance:SimpleClassWithTwoMethods = _proxyFactory.createProxy(SimpleClassWithTwoMethods) as SimpleClassWithTwoMethods;
			assertNotNull(instance);
			assertEquals('interceptedReturnValue', instance.returnString());
			assertEquals('interceptedReturnValue', instance.returnStringWithParam('test'));
		}

		protected function handleMethodCustomNamespaceTestComplete(event:Event):void {
			var instance:SimpleClassWithCustomNamespaceMethod = _proxyFactory.createProxy(SimpleClassWithCustomNamespaceMethod) as SimpleClassWithCustomNamespaceMethod;
			var instance2:SimpleClassWithCustomNamespaceMethod = new SimpleClassWithCustomNamespaceMethod();
			assertNotNull(instance);
			assertEquals('interceptedGetterValue', instance.as3commons_bytecode::customProp);
			instance.as3commons_bytecode::customSetProp = "test";
			assertEquals('interceptedSetterValue', instance.checkCustomSetter());
		}

		protected function handleRestArgumentsMethodTestComplete(event:Event):void {
			var instance:SimpleClassWithRestParameters = _proxyFactory.createProxy(SimpleClassWithRestParameters) as SimpleClassWithRestParameters;
			assertNotNull(instance);
			var arr:Array = instance.restArguments('test1', 'test2', 'test3');
			assertEquals(3, arr.length);
			assertEquals('intercept1', arr[0]);
			assertEquals('intercept2', arr[1]);
			assertEquals('intercept3', arr[2]);
			arr = instance.restArgumentsAndNormalParam('test1', 'test2', 'test3', 'test4');
			assertEquals(4, arr.length);
			assertEquals('intercept1', arr[0]);
			assertEquals('intercept2', arr[1]);
			assertEquals('intercept3', arr[2]);
			assertEquals('intercept4', arr[3]);
		}

		protected function handleProtectedMethodTestComplete(event:Event):void {
			var instance:SimpleClassWithProtectedMethod = _proxyFactory.createProxy(SimpleClassWithProtectedMethod) as SimpleClassWithProtectedMethod;
			var xml:XML = describeType(instance);
			assertNotNull(instance);
			instance.doMultiply();
			assertEquals(1000, instance.result);
			assertEquals("intercepted", instance.stringVal);
		}

		protected function handleAccessorTestComplete(event:Event):void {
			var instance:SimpleClassWithAccessors = _proxyFactory.createProxy(SimpleClassWithAccessors) as SimpleClassWithAccessors;
			instance['dynamicProperty'] = "test";
			assertEquals("test", instance['dynamicProperty']);
			assertNotNull(instance);
			assertEquals(100, instance.getter);
			instance.setter = 1000;
			assertEquals(100, instance.checkSetter());
		}

		protected function handleMetadataTestComplete(event:Event):void {
			var instance:SimpleClassWithMetadata = _proxyFactory.createProxy(SimpleClassWithMetadata) as SimpleClassWithMetadata;
			var type:Type = Type.forInstance(instance);
			assertTrue(type.hasMetadata('Transient'));
			var metadata:Metadata = type.getMetadata('Transient')[0];
			assertEquals(1, metadata.arguments.length);
			assertEquals('arg', metadata.arguments[0].key);
			assertEquals('classtest', metadata.arguments[0].value);

			var method:Method = type.getMethod('simpleMethod');
			assertTrue(method.hasMetadata('Transient'));
			metadata = method.getMetadata('Transient')[0];
			assertEquals(1, metadata.arguments.length);
			assertEquals('arg', metadata.arguments[0].key);
			assertEquals('methodtest', metadata.arguments[0].value);

			var accessor:Accessor = type.getField('getter') as Accessor;
			assertTrue(accessor.hasMetadata('Transient'));
			metadata = accessor.getMetadata('Transient')[0];
			assertEquals(1, metadata.arguments.length);
			assertEquals('arg', metadata.arguments[0].key);
			assertEquals('accessortest', metadata.arguments[0].value);
		}
	}
}