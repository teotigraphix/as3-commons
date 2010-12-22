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

	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.interception.BasicMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.testclasses.ProxySubClass;
	import org.as3commons.bytecode.testclasses.SimpleClassWithOneConstructorArgument;
	import org.as3commons.bytecode.testclasses.SimpleClassWithOneMethod;
	import org.as3commons.bytecode.testclasses.TestProxiedClass;
	import org.as3commons.bytecode.testclasses.interceptors.TestInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestMethodInterceptor;
	import org.as3commons.bytecode.util.ApplicationUtils;

	public class ProxyFactoryTest extends TestCase {

		private var _proxyFactory:ProxyFactory;

		public function ProxyFactoryTest(methodName:String = null) {
			super(methodName);
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
			var builder:IAbcBuilder = _proxyFactory.createProxyClasses();
			assertNotNull(builder);
		}

		public function testLoadProxyClassForClassWithOneCtorParam():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneConstructorArgument, null, applicationDomain);
			classProxyInfo.onlyProxyConstructor = true;
			_proxyFactory.createProxyClasses();
			_proxyFactory.methodInvocationInterceptorFunction = createConstructorInterceptor;
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleConstructorTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		public function testLoadProxyClassForClassWithOneMethod():void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var classProxyInfo:ClassProxyInfo = _proxyFactory.defineProxy(SimpleClassWithOneMethod, null, applicationDomain);
			classProxyInfo.proxyMethod("returnString");
			_proxyFactory.createProxyClasses();
			_proxyFactory.methodInvocationInterceptorFunction = createMethodInterceptor;
			_proxyFactory.addEventListener(Event.COMPLETE, addAsync(handleMethodTestComplete, 1000));
			_proxyFactory.loadProxyClasses();
		}

		protected function createConstructorInterceptor(proxiedClass:Class, constructorArgs:Array, methodInvocationInterceptorClass:Class):IMethodInvocationInterceptor {
			var interceptor:BasicMethodInvocationInterceptor = new methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestInterceptor();
			return interceptor;
		}

		protected function createMethodInterceptor(proxiedClass:Class, constructorArgs:Array, methodInvocationInterceptorClass:Class):IMethodInvocationInterceptor {
			var interceptor:BasicMethodInvocationInterceptor = new methodInvocationInterceptorClass() as BasicMethodInvocationInterceptor;
			interceptor.interceptors[interceptor.interceptors.length] = new TestMethodInterceptor();
			return interceptor;
		}

		protected function handleConstructorTestComplete(event:Event):void {
			var instance:SimpleClassWithOneConstructorArgument = _proxyFactory.createProxy(SimpleClassWithOneConstructorArgument, ["testarg"]) as SimpleClassWithOneConstructorArgument;
			assertNotNull(instance);
			assertEquals('intercepted', instance.string);
		}

		protected function handleMethodTestComplete(event:Event):void {
			var instance:SimpleClassWithOneMethod = _proxyFactory.createProxy(SimpleClassWithOneMethod) as SimpleClassWithOneMethod;
			assertNotNull(instance);
			assertEquals('interceptedReturnValue', instance.returnString());
		}

	}
}