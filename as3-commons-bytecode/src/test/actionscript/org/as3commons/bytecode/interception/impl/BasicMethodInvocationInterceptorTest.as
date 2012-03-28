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
package org.as3commons.bytecode.interception.impl {

	import org.as3commons.bytecode.testclasses.interceptors.TestBlockingInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestInterceptor;
	import org.as3commons.bytecode.testclasses.interceptors.TestMethodInterceptor;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;

	public class BasicMethodInvocationInterceptorTest {

		private var _interceptor:BasicMethodInvocationInterceptor;
		private var _testResult:String;

		public function BasicMethodInvocationInterceptorTest() {

		}

		[Before]
		public function setUp():void {
			_interceptor = new BasicMethodInvocationInterceptor();
			_testResult = null;
		}

		[Test]
		public function testInterceptWithoutInterceptors():void {
			_interceptor.intercept(this, InvocationKind.METHOD, new QName("", "testMethod"), ['test'], testMethod);
			assertEquals('test', _testResult);
		}

		[Test]
		public function testInterceptWithInterceptorThatChangesParameter():void {
			_interceptor.interceptors[_interceptor.interceptors.length] = new TestInterceptor();
			_interceptor.intercept(this, InvocationKind.METHOD, new QName("", "testMethod"), ['test'], testMethod);
			assertEquals('intercepted', _testResult);
		}

		[Test]
		public function testInterceptWithInterceptorThatChangesReturnValue():void {
			_interceptor.interceptors[_interceptor.interceptors.length] = new TestMethodInterceptor();
			var returnValue:String = _interceptor.intercept(this, InvocationKind.METHOD, new QName("", "testMethod"), null, testMethod);
			assertEquals('interceptedReturnValue', returnValue);
		}

		[Test]
		public function testInterceptWithBlockingInterceptor():void {
			_interceptor.interceptors[_interceptor.interceptors.length] = new TestBlockingInterceptor();
			_interceptor.intercept(this, InvocationKind.METHOD, new QName("", "testMethod"), ['test'], testMethod);
			assertNull(_testResult);
		}

		protected function testMethod(str:String):void {
			_testResult = str;
		}

		protected function testMethodWithReturnValue():String {
			return "test";
		}
	}
}