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
package org.as3commons.bytecode.interception {
	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.testclasses.TestBlockingInterceptor;
	import org.as3commons.bytecode.testclasses.TestInterceptor;

	public class BasicMethodInvocationInterceptorTest extends TestCase {

		private var _interceptor:BasicMethodInvocationInterceptor;
		private var _testResult:String;

		public function BasicMethodInvocationInterceptorTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_interceptor = new BasicMethodInvocationInterceptor();
			_testResult = null;
		}

		public function testInterceptWithoutInterceptors():void {
			_interceptor.intercept(this, "testMethod", testMethod, ['test']);
			assertEquals('test', _testResult);
		}

		public function testInterceptWithoutInterceptorThatChangesParameter():void {
			_interceptor.interceptors[_interceptor.interceptors.length] = new TestInterceptor();
			_interceptor.intercept(this, "testMethod", testMethod, ['test']);
			assertEquals('intercepted', _testResult);
		}

		public function testInterceptWithoutBlockingInterceptor():void {
			_interceptor.interceptors[_interceptor.interceptors.length] = new TestBlockingInterceptor();
			_interceptor.intercept(this, "testMethod", testMethod, ['test']);
			assertNull(_testResult);
		}

		protected function testMethod(str:String):void {
			_testResult = str;
		}
	}
}