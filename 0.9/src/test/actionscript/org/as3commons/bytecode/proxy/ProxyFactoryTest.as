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
	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.interception.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.testclasses.ProxySubClass;
	import org.as3commons.bytecode.testclasses.SimpleClassWithAccessors;
	import org.as3commons.bytecode.testclasses.SimpleClassWithCustomNamespaceMethod;
	import org.as3commons.bytecode.testclasses.SimpleClassWithMetadata;
	import org.as3commons.bytecode.testclasses.SimpleClassWithOneConstructorArgument;
	import org.as3commons.bytecode.testclasses.SimpleClassWithProtectedMethod;
	import org.as3commons.bytecode.testclasses.SimpleClassWithTwoMethods;
	import org.as3commons.bytecode.testclasses.TestProxiedClass;
	import org.as3commons.bytecode.testclasses.interceptors.TestAccessorInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestMethodInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestProtectedInterceptor;
	import org.as3commons.bytecode.util.ApplicationUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;

	public class ProxyFactoryTest extends TestCase {

		private var _proxyFactory:ProxyFactory;

		public function ProxyFactoryTest(methodName:String = null) {
			super(methodName);
			ProxySubClass;
		}

		override public function setUp():void {
			ByteCodeType.getTypeProvider().clearCache();
			ByteCodeType.fromLoader(ApplicationUtils.application.loaderInfo);
			_proxyFactory = new ProxyFactory();
		}

		override public function tearDown():void {
			ByteCodeType.getTypeProvider().clearCache();
		}

		public function testDefineProxy():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(TestProxiedClass, null, applicationDomain);
			assertStrictlyEquals(TestProxiedClass, classProxyInfo.proxiedClass);
			assertEquals(true, classProxyInfo.proxyAll);
			for (var domain:* in _proxyFactory.domains) {
				assertStrictlyEquals(applicationDomain, domain);
			}
		}

		public function testCreateProxyClasses():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(TestProxiedClass, null, applicationDomain);
			var builder:IAbcBuilder = _proxyFactory.generateProxyClasses();
			assertNotNull(builder);
		}

		public function testLoadProxyClassForClassWithOneCtorParam():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			classProxyInfo.onlyProxyConstructor = true;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithoutCtorParams():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			classProxyInfo.onlyProxyConstructor = true;
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createConstructorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		/*public function testLoadProxyClassForClassWithProtectedMethod():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithProtectedMethod, null, applicationDomain);
			classProxyInfo.proxyMethod("multiply");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createProtectedMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleProtectedMethodTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}*/

		public function testLoadProxyClassForClassWithTwoMethods():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithTwoMethods, null, applicationDomain);
			classProxyInfo.proxyMethod("returnString");
			classProxyInfo.proxyMethod("returnStringWithParam");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMethodTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		/*public function testLoadProxyClassForClassWithCustomnamespaceMethod():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithCustomNamespaceMethod, null, applicationDomain);
			classProxyInfo.proxyMethod("custom");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createMethodInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMethodCustomNamespaceTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}*/

		public function testLoadProxyClassForClassAccessors():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithAccessors, null, applicationDomain);
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
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithMetadata, null, applicationDomain);
			classProxyInfo.proxyMethod("simpleMethod");
			classProxyInfo.proxyAccessor("getter");
			_proxyFactory.generateProxyClasses();
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createAccessorInterceptor);
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMetadataTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
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

		protected function createMethodInterceptor(event:ProxyFactoryEvent):void {
			var interceptor:BasicMethodInvocationInterceptor = new event.methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestMethodInterceptor();
			event.methodInvocationInterceptor = interceptor;
		}

		protected function handleConstructorTestComplete(event:Event):void {
			var instance:SimpleClassWithOneConstructorArgument = _proxyFactory.createProxy(SimpleClassWithOneConstructorArgument, ["testarg"]) as SimpleClassWithOneConstructorArgument;
			assertNotNull(instance);
			assertEquals('intercepted', instance.string);
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
			assertEquals('interceptedReturnValue', instance.as3commons_bytecode::custom());
		}

		protected function handleProtectedMethodTestComplete(event:Event):void {
			var instance:SimpleClassWithProtectedMethod = _proxyFactory.createProxy(SimpleClassWithProtectedMethod) as SimpleClassWithProtectedMethod;
			assertNotNull(instance);
			instance.doMultiply();
			assertEquals(100, instance.result);
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
			assertTrue(type.hasMetaData('Transient'));
			var metadata:MetaData = type.getMetaData('Transient')[0];
			assertEquals(1, metadata.arguments.length);
			assertEquals('arg', metadata.arguments[0].key);
			assertEquals('classtest', metadata.arguments[0].value);

			var method:Method = type.getMethod('simpleMethod');
			assertTrue(method.hasMetaData('Transient'));
			metadata = method.getMetaData('Transient')[0];
			assertEquals(1, metadata.arguments.length);
			assertEquals('arg', metadata.arguments[0].key);
			assertEquals('methodtest', metadata.arguments[0].value);

			var accessor:Accessor = type.getField('getter') as Accessor;
			assertTrue(accessor.hasMetaData('Transient'));
			metadata = accessor.getMetaData('Transient')[0];
			assertEquals(1, metadata.arguments.length);
			assertEquals('arg', metadata.arguments[0].key);
			assertEquals('accessortest', metadata.arguments[0].value);
		}
	}
}