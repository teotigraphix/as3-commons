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

	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.registerClassAlias;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	import mx.containers.Canvas;
	import mx.core.FlexGlobals;
	import mx.messaging.ChannelSet;
	import mx.rpc.remoting.RemoteObject;
	
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.SimpleConstantPool;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.impl.MemberInitialization;
	import org.as3commons.bytecode.interception.impl.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.io.AbcDeserializer;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.ProxyScope;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.testclasses.ClassWithVectorTypedProperty;
	import org.as3commons.bytecode.testclasses.EventDispatcherExImpl;
	import org.as3commons.bytecode.testclasses.EventDispatcherSubclass;
	import org.as3commons.bytecode.testclasses.EventDispatcherSubclass2;
	import org.as3commons.bytecode.testclasses.EventDispatcherSubclass3;
	import org.as3commons.bytecode.testclasses.Flavour;
	import org.as3commons.bytecode.testclasses.IEventDispatcherEx;
	import org.as3commons.bytecode.testclasses.IFlavour;
	import org.as3commons.bytecode.testclasses.ITestIntroduction;
	import org.as3commons.bytecode.testclasses.Inline;
	import org.as3commons.bytecode.testclasses.IntroductionImpl;
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
	import org.as3commons.bytecode.testclasses.interceptors.AccessorInterceptorImpl;
	import org.as3commons.bytecode.testclasses.interceptors.CanvasInterceptorImpl;
	import org.as3commons.bytecode.testclasses.interceptors.CtorInterceptorFactory;
	import org.as3commons.bytecode.testclasses.interceptors.CustomInterceptorFactory;
	import org.as3commons.bytecode.testclasses.interceptors.EventDispatcherExInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.InterceptorImpl;
	import org.as3commons.bytecode.testclasses.interceptors.InterfaceMethodInterceptorImpl;
	import org.as3commons.bytecode.testclasses.interceptors.MethodInterceptorImpl;
	import org.as3commons.bytecode.testclasses.interceptors.OptionalArgInterceptorImpl;
	import org.as3commons.bytecode.testclasses.interceptors.ProtectedInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.RestMethodInterceptor;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;

	public class ProxyFactoryTest {

		ProxySubClass;

		private var _applicationDomain:ApplicationDomain;
		private var _proxyFactory:ProxyFactory;
		private var _embeddedName:String;

		public function ProxyFactoryTest() {
			ByteCodeType.getTypeProvider().clearCache();
		}

		[Before]
		public function setUp():void {
			var loaderInfo:LoaderInfo = FlexGlobals.topLevelApplication.loaderInfo;
			_applicationDomain = loaderInfo.applicationDomain;
			ByteCodeType.fromLoader(loaderInfo, _applicationDomain);
			_proxyFactory = new ProxyFactory();
		}

		[After]
		public function tearDown():void {
			ByteCodeType.getTypeProvider().clearCache();
		}

		[Test]
		public function testProxyObjectWithVectorTypedProperty():void {
			_proxyFactory.defineProxy(ClassWithVectorTypedProperty, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, createVectorPropertyProxy);
			_proxyFactory.loadProxyClasses();
		}

		public function createVectorPropertyProxy(event:Event):void {
			var instance:ClassWithVectorTypedProperty = _proxyFactory.createProxy(ClassWithVectorTypedProperty);
		}

		[Test]
		public function testMultipleCreationsInSubsequentCalls():void {
			_proxyFactory.defineProxy(IEventDispatcher, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, createNextProxy);
			_proxyFactory.loadProxyClasses();
		}

		protected function createNextProxy(event:Event):void {
			_proxyFactory.removeEventListener(Event.COMPLETE, createNextProxy);
			_proxyFactory.addEventListener(Event.COMPLETE, createProxy);
			_proxyFactory.defineProxy(EventDispatcher, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.loadProxyClasses();
		}

		protected function createProxy(event:Event):void {
			_proxyFactory.removeEventListener(Event.COMPLETE, createProxy);
			assertTrue(true);
		}

		[Test]
		public function testDefineProxy():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(EventDispatcherSubclass3, null, _applicationDomain);
			assertStrictlyEquals(EventDispatcherSubclass3, classProxyInfo.proxiedClass);
			for (var domain:* in _proxyFactory.domains) {
				assertStrictlyEquals(_applicationDomain, domain);
			}
		}

		[Test]
		public function testCreateProxyClasses():void {
			_proxyFactory.defineProxy(EventDispatcherSubclass3, null, _applicationDomain);
			var builder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			assertNotNull(builder);
		}

		[Test(async)]
		public function testCreateRemoteObjectProxy():void {
			_proxyFactory.defineProxy(RemoteObject, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleRemoteObjectProxyTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		protected function handleRemoteObjectProxyTestComplete(event:Event, obj:Object):void {
			var ro:RemoteObject = _proxyFactory.createProxy(RemoteObject);
			ro.channelSet = new ChannelSet();
		}

		[Test(async)]
		public function testLoadProxyClassInDefaultPackage():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(ClassInDefaultPackage, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleClassInDefaultPackageTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithOneCtorParam():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, _applicationDomain);
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithTwoCtorParams():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithTwoConstructorArguments, null, _applicationDomain);
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleConstructorTwoParamsTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithOneCtorParamWithInterceptorFactory():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, _applicationDomain);
			classProxyInfo.interceptorFactory = new CtorInterceptorFactory();
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithOneCtorParamWithInterceptorFactoryThatReturnsTestMethodInvocationInterceptor():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, _applicationDomain);
			classProxyInfo.interceptorFactory = new CustomInterceptorFactory();
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleCustomFactoryConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithMethodWithOptionalArg():void {
			var handler:Function = function(event:Event, data:*):void {
				var instance:SimpleClassWithMethodWithOptionalArgs = _proxyFactory.createProxy(SimpleClassWithMethodWithOptionalArgs) as SimpleClassWithMethodWithOptionalArgs;
				assertNotNull(instance);
				instance.methodWithOptionalArgs("test");
			};

			_proxyFactory.defineProxy(SimpleClassWithMethodWithOptionalArgs, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createOptionalArgInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithoutCtorParams():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, _applicationDomain);
			classProxyInfo.proxyAccessorScopes = ProxyScope.NONE;
			classProxyInfo.proxyMethodScopes = ProxyScope.NONE;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithProtectedMethod():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithProtectedMethod, null, _applicationDomain);
			classProxyInfo.proxyMethod("multiply");
			classProxyInfo.proxyAccessor("stringValue");
			classProxyInfo.proxyAccessor("stringValue2");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createProtectedMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleProtectedMethodTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithTwoMethods():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithTwoMethods, null, _applicationDomain);
			classProxyInfo.proxyMethod("returnString");
			classProxyInfo.proxyMethod("returnStringWithParam");

			var handler:Function = function(event:Event, data:*):void {
				var instance:SimpleClassWithTwoMethods = _proxyFactory.createProxy(SimpleClassWithTwoMethods) as SimpleClassWithTwoMethods;
				assertNotNull(instance);
				assertEquals('interceptedReturnValue', instance.returnString());
				assertEquals('interceptedReturnValue', instance.returnStringWithParam('test'));
			};

			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testProxyInterface():void {
			_proxyFactory.defineProxy(IFlavour, null, _applicationDomain);

			var handler:Function = function(event:Event, data:*):void {
				var instance:IFlavour = _proxyFactory.createProxy(IFlavour) as IFlavour;
				assertNotNull(instance);
				instance.add(instance);
				instance.combine(1, 2, 3, 4);
				assertEquals("interceptedReturnValue", instance.toString());
				assertEquals("interceptedGetterValue", instance.name);
				assertEquals(1, instance.ingredients.length);
				assertEquals("interceptedGetterValue", instance.ingredients[0]);
			};

			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createInterfaceMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testProxyClassThatImplementsExtraInterface():void {
			var clsInfo:IClassProxyInfo = _proxyFactory.defineProxy(IEventDispatcher, null, _applicationDomain);
			clsInfo.implementInterface(IFlavour);

			var handler:Function = function(event:Event, data:*):void {
				var instance:IEventDispatcher = _proxyFactory.createProxy(IEventDispatcher);
				assertNotNull(instance);
				var flavour:IFlavour = instance as IFlavour;
				flavour.add(flavour);
				flavour.combine(1, 2, 3, 4);
				assertEquals("interceptedReturnValue", flavour.toString());
				assertEquals("interceptedGetterValue", flavour.name);
				assertEquals(1, flavour.ingredients.length);
				assertEquals("interceptedGetterValue", flavour.ingredients[0]);
			};

			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createClassWithExtraInterfaceMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		/*[Test] public function testLoadProxyClassForCanvas():void {

		 for (var info:* in ApplicationUtils.application.systemManager.preloadedRSLs) {
		 ByteCodeType.fromLoader(info);
		 }
		 var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(Canvas, null, _applicationDomain);
		 _proxyFactory.generateProxyClasses();
		 _proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createCanvasInterceptor);
		 _proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler( this, handleCanvasTestComplete, 1000));
		 _proxyFactory.loadProxyClasses();
		 }*/

		[Test(async)]
		public function testLoadProxyClassForClassWithCustomNamespaceMethod():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithCustomNamespaceMethod, null, _applicationDomain);
			classProxyInfo.proxyMethod("custom", "http://www.as3commons.org/bytecode");
			classProxyInfo.proxyAccessor("customProp", "http://www.as3commons.org/bytecode");
			classProxyInfo.proxyAccessor("customSetProp", "http://www.as3commons.org/bytecode");

			var handler:Function = function(event:Event, data:*):void {
				var instance:SimpleClassWithCustomNamespaceMethod = _proxyFactory.createProxy(SimpleClassWithCustomNamespaceMethod) as SimpleClassWithCustomNamespaceMethod;
				var instance2:SimpleClassWithCustomNamespaceMethod = new SimpleClassWithCustomNamespaceMethod();
				assertNotNull(instance);
				assertEquals('interceptedGetterValue', instance.as3commons_bytecode::customProp);
				instance.as3commons_bytecode::customSetProp = "test";
				assertEquals('interceptedSetterValue', instance.checkCustomSetter());
			};

			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyWithRestParameters():void {
			_proxyFactory.defineProxy(SimpleClassWithRestParameters, null, _applicationDomain);

			var handler:Function = function(event:Event, data:*):void {
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
			};

			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createRestArgumentsMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassAccessors():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithAccessors, null, _applicationDomain);
			classProxyInfo.proxyAccessor("getter");
			classProxyInfo.proxyAccessor("setter");
			classProxyInfo.makeDynamic = true;

			var handler:Function = function(event:Event, data:*):void {
				var instance:SimpleClassWithAccessors = _proxyFactory.createProxy(SimpleClassWithAccessors) as SimpleClassWithAccessors;
				instance['dynamicProperty'] = "test";
				assertEquals("test", instance['dynamicProperty']);
				assertNotNull(instance);
				assertEquals(100, instance.getter);
				instance.setter = 1000;
				assertEquals(100, instance.checkSetter());
			};

			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createAccessorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testLoadProxyClassForClassWithMetadata():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithMetadata, null, _applicationDomain);
			classProxyInfo.proxyMethod("simpleMethod");
			classProxyInfo.proxyAccessor("getter");


			var handler:Function = function(event:Event, data:*):void {
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
			};

			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createAccessorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testDefineMultipleProxies():void {
			_proxyFactory.defineProxy(Flavour, null, _applicationDomain);
			_proxyFactory.defineProxy(IFlavour, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithAccessors, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithCustomNamespaceMethod, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithMetadata, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithMethodWithOptionalArgs, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithoutConstructorArgument, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithProtectedMethod, null, _applicationDomain);
			_proxyFactory.defineProxy(SimpleClassWithTwoMethods, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createAccessorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleMultipleProxiesTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test]
		public function testBusyGeneratingError():void {
			_proxyFactory.defineProxy(Flavour, null, _applicationDomain);
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

		[Test(async)]
		public function testSerialization():void {
			var handler:Function = function(event:Event, data:*):void {
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
			};

			_proxyFactory.defineProxy(Flavour, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handler, 1000, null, handleSerializationTestFail));
			_proxyFactory.addEventListener(IOErrorEvent.VERIFY_ERROR, Async.asyncHandler(this, handleSerializationTestError, 1000, null, handleSerializationTestErrorFail));
			_proxyFactory.loadProxyClasses();
		}

		protected static function handleSerializationTestError(event:IOErrorEvent):void {
			assertEquals("", event.text);
		}

		protected static function handleSerializationTestErrorFail(event:Event):void {
			assertTrue(true);
		}

		protected static function handleSerializationTestFail(event:Event):void {
			assertTrue(true);
		}

		[Test(async)]
		public function testNestedSerialization():void {
			_embeddedName = null;
			_proxyFactory.addEventListener(ProxyFactoryBuildEvent.AFTER_PROXY_BUILD, addProxiedProperty);
			_proxyFactory.defineProxy(Inline, null, _applicationDomain);
			_proxyFactory.defineProxy(Flavour, null, _applicationDomain);
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleNestedSerializationTestComplete, 1000));
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

		protected static function handleNestedSerializationTestComplete(event:Event, data:*):void {
			var proxyFactory:IProxyFactory = event.target as IProxyFactory;
			var instance:Flavour = proxyFactory.createProxy(Flavour) as Flavour;
			assertNotNull(instance);
			assertNotNull(instance['testNest']);
			var cls:Class = Object(instance).constructor as Class;
			var cls2:Class = Object(instance['testNest']).constructor as Class;
			registerClassAlias("org.as3commons.bytecode.testclasses.Flavour", cls);
			registerClassAlias("org.as3commons.bytecode.testclasses.Inline", cls2);

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

		[Test(async)]
		public function testIntroduction():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(Flavour, null, _applicationDomain);
			classProxyInfo.introduce(IntroductionImpl);
			var abcBuilder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleIntroductionTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testEventDispatcherIntroduction():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(EventDispatcher, null, _applicationDomain);
			classProxyInfo.introduce(EventDispatcherExImpl);
			classProxyInfo.proxyMethod("addEventListener");
			classProxyInfo.proxyMethod("removeEventListener");
			var abcBuilder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			//var abcFile:AbcFile = abcBuilder.build();
			//var ba:ByteArray = new AbcSerializer().serializeAbcFile(abcFile);
			//abcFile = new AbcDeserializer(ba).deserialize();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createEventDispatcherIntroductionInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleEventDispatcherIntroductionTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testEventDispatcherImplementInterface():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(EventDispatcher, null, _applicationDomain);
			classProxyInfo.implementInterface(IEventDispatcherEx);
			classProxyInfo.proxyMethod("addEventListener");
			classProxyInfo.proxyMethod("removeEventListener");
			var abcBuilder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			//var abcFile:AbcFile = abcBuilder.build();
			//var ba:ByteArray = new AbcSerializer().serializeAbcFile(abcFile);
			//abcFile = new AbcDeserializer(ba).deserialize();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createEventDispatcherIntroductionInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleEventDispatcherImplementInterfaceTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		[Test(async)]
		public function testMultipleIntroductions():void {
			var classProxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(EventDispatcherSubclass, null, _applicationDomain);
			classProxyInfo.introduce(EventDispatcherExImpl);
			classProxyInfo.proxyMethod("addEventListener");
			classProxyInfo.proxyMethod("removeEventListener");

			classProxyInfo = _proxyFactory.defineProxy(EventDispatcherSubclass2, null, _applicationDomain);
			classProxyInfo.introduce(EventDispatcherExImpl);
			classProxyInfo.proxyMethod("addEventListener");
			classProxyInfo.proxyMethod("removeEventListener");

			var abcBuilder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createEventDispatcherIntroductionInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, Async.asyncHandler(this, handleMultipleIntroductionTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		protected static function handleMultipleProxiesTestComplete(event:Event, data:*):void {
			assertTrue(true);
		}

		protected static function createEventDispatcherIntroductionInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new EventDispatcherExInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function handleEventDispatcherIntroductionTestComplete(event:Event, data:*):void {
			var instance:EventDispatcher = _proxyFactory.createProxy(EventDispatcher) as EventDispatcher;
			assertNotNull(instance);
			var testInterface:IEventDispatcherEx = instance as IEventDispatcherEx;
			assertNotNull(testInterface);
			var func1:Function = function(event:Event):void {
			};
			instance.addEventListener(Event.ACTIVATE, func1, false, 0, true);
			assertEquals(1, testInterface.getCountListeners(Event.ACTIVATE));
		}

		protected function handleEventDispatcherImplementInterfaceTestComplete(event:Event, data:*):void {
			var instance:EventDispatcher = _proxyFactory.createProxy(EventDispatcher) as EventDispatcher;
			assertNotNull(instance);
			var testInterface:IEventDispatcherEx = instance as IEventDispatcherEx;
			assertNotNull(testInterface);
			assertEquals(10, testInterface.getCountListeners(Event.ACTIVATE));
		}

		protected function handleMultipleIntroductionTestComplete(event:Event, data:*):void {
			var instance:EventDispatcherSubclass = _proxyFactory.createProxy(EventDispatcherSubclass) as EventDispatcherSubclass;
			assertNotNull(instance);
			var testInterface:IEventDispatcherEx = instance as IEventDispatcherEx;
			assertNotNull(testInterface);
			var func1:Function = function(event:Event):void {
			};
			instance.addEventListener(Event.ACTIVATE, func1, false, 0, true);
			assertEquals(1, testInterface.getCountListeners(Event.ACTIVATE));

			var instance2:EventDispatcherSubclass2 = _proxyFactory.createProxy(EventDispatcherSubclass2) as EventDispatcherSubclass2;
			assertNotNull(instance2);
			testInterface = instance2 as IEventDispatcherEx;
			assertNotNull(testInterface);
			instance2.addEventListener(Event.ACTIVATE, func1, false, 0, true);
			assertEquals(1, testInterface.getCountListeners(Event.ACTIVATE));
		}

		protected function handleIntroductionTestComplete(event:Event, data:*):void {
			var instance:Flavour = _proxyFactory.createProxy(Flavour) as Flavour;
			assertNotNull(instance);
			var testInterface:ITestIntroduction = instance as ITestIntroduction;
			assertNotNull(testInterface);
			assertEquals("1", testInterface.testSwitch(1));
			assertEquals("test", testInterface.getTest());
			assertEquals("testString", testInterface.testString);
			assertNotNull(testInterface.testObject);
		}

		protected static function createCanvasInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new CanvasInterceptorImpl();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createAccessorInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new AccessorInterceptorImpl();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createProtectedMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new ProtectedInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createConstructorInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new InterceptorImpl();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createOptionalArgInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new OptionalArgInterceptorImpl();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new MethodInterceptorImpl();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createRestArgumentsMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new RestMethodInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createInterfaceMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new InterfaceMethodInterceptorImpl();
			event.methodInvocationInterceptor = interceptor;
		}

		protected static function createClassWithExtraInterfaceMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new InterfaceMethodInterceptorImpl();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function handleCanvasTestComplete(event:Event, data:*):void {
			var instance:Canvas = _proxyFactory.createProxy(Canvas) as Canvas;
			assertNotNull(instance);
		}

		protected function handleClassInDefaultPackageTestComplete(event:Event, data:*):void {
			var instance:ClassInDefaultPackage = _proxyFactory.createProxy(ClassInDefaultPackage);
			assertNotNull(instance);
		}

		protected function handleConstructorTestComplete(event:Event, data:*):void {
			var instance:SimpleClassWithOneConstructorArgument = _proxyFactory.createProxy(SimpleClassWithOneConstructorArgument, ["testarg"]) as SimpleClassWithOneConstructorArgument;
			assertNotNull(instance);
			assertEquals('intercepted', instance.string);
		}


		protected function handleConstructorTwoParamsTestComplete(event:Event, data:*):void {
			var instance:SimpleClassWithTwoConstructorArguments = _proxyFactory.createProxy(SimpleClassWithTwoConstructorArguments, ["testarg", 1]) as SimpleClassWithTwoConstructorArguments;
			assertNotNull(instance);
			assertEquals('intercepted', instance.string);
		}

		protected function handleCustomFactoryConstructorTestComplete(event:Event, data:*):void {
			var instance:SimpleClassWithOneConstructorArgument = _proxyFactory.createProxy(SimpleClassWithOneConstructorArgument, ["testarg"]) as SimpleClassWithOneConstructorArgument;
			assertNotNull(instance);
			assertEquals('testarg', instance.string);
		}

		protected function handleProtectedMethodTestComplete(event:Event, data:*):void {
			var instance:SimpleClassWithProtectedMethod = _proxyFactory.createProxy(SimpleClassWithProtectedMethod) as SimpleClassWithProtectedMethod;
			var xml:XML = describeType(instance);
			assertNotNull(instance);
			instance.doMultiply();
			assertEquals(1000, instance.result);
			assertEquals("intercepted", instance.stringVal);
		}

	}
}
