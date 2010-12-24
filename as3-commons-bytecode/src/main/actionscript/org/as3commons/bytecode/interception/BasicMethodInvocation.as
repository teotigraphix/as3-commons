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
	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class BasicMethodInvocation implements IMethodInvocation {

		private var _kind:InvocationKind;
		private var _targetInstance:Object;
		private var _targetMethodName:String;
		private var _targetMethod:Function;
		private var _proceed:Boolean = true;
		private var _arguments:Array;
		private var _returnValue:*;

		/**
		 * Creates a new <code>BasicMethodInvocation</code> instance.
		 * @param instance
		 * @param methodName
		 * @param method
		 * @param args
		 */
		public function BasicMethodInvocation(instance:Object, kind:InvocationKind, methodName:String, method:Function, args:Array = null) {
			super();
			initBasicMethodInvocation(instance, kind, methodName, method, args);
		}

		protected function initBasicMethodInvocation(instance:Object, kind:InvocationKind, methodName:String, method:Function, args:Array):void {
			Assert.notNull(instance, "instance argument must not be null");
			Assert.notNull(kind, "kind argument must not be null");
			Assert.hasText(methodName, "methodName argument must not be empty or null");
			_kind = kind;
			_targetInstance = instance;
			_targetMethodName = methodName;
			_targetMethod = method;
			_arguments = args;
		}

		public function get kind():InvocationKind {
			return _kind;
		}

		public function get targetInstance():Object {
			return _targetInstance;
		}

		public function get targetMethodName():String {
			return _targetMethodName;
		}

		public function get targetMethod():Function {
			return _targetMethod;
		}

		public function get arguments():Array {
			return _arguments;
		}

		public function get returnValue():* {
			return _returnValue;
		}

		public function set returnValue(value:*):void {
			_returnValue = value;
		}

		public function get proceed():Boolean {
			return _proceed;
		}

		public function set proceed(value:Boolean):void {
			_proceed = value;
		}

	}
}