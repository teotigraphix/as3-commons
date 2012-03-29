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
package org.as3commons.bytecode.interception.impl {
	import org.as3commons.bytecode.interception.IMethodInvocation;
	import org.as3commons.lang.Assert;

	/**
	 * @inheritDoc
	 */
	public class BasicMethodInvocation implements IMethodInvocation {

		private var _kind:InvocationKind;
		private var _targetInstance:Object;
		private var _targetMember:QName;
		private var _targetMethod:Function;
		private var _proceed:Boolean = true;
		private var _arguments:Array;
		private var _returnValue:*;

		/**
		 * Creates a new <code>BasicMethodInvocation</code> instance.
		 * @param instance
		 * @param kind
		 * @param method
		 * @param args
		 */
		public function BasicMethodInvocation(instance:Object, kind:InvocationKind, member:QName, method:Function, args:Array = null) {
			super();
			initBasicMethodInvocation(instance, kind, member, method, args);
		}

		/**
		 * Initializes the current <code>BasicMethodInvocation</code> instance.
		 * @param instance
		 * @param kind
		 * @param member
		 * @param method
		 * @param args
		 */
		protected function initBasicMethodInvocation(instance:Object, kind:InvocationKind, member:QName, method:Function, args:Array):void {
			Assert.notNull(instance, "instance argument must not be null");
			Assert.notNull(kind, "kind argument must not be null");
			_kind = kind;
			_targetInstance = instance;
			_targetMember = member;
			_targetMethod = method;
			_arguments = args;
		}

		/**
		 * @inheritDoc
		 */
		public function get kind():InvocationKind {
			return _kind;
		}

		/**
		 * @inheritDoc
		 */
		public function get targetInstance():Object {
			return _targetInstance;
		}

		/**
		 * @inheritDoc
		 */
		public function get targetMember():QName {
			return _targetMember;
		}

		/**
		 * @inheritDoc
		 */
		public function get targetMethod():Function {
			return _targetMethod;
		}

		/**
		 * @inheritDoc
		 */
		public function get arguments():Array {
			return _arguments;
		}

		/**
		 * @inheritDoc
		 */
		public function get returnValue():* {
			return _returnValue;
		}

		/**
		 * @private
		 */
		public function set returnValue(value:*):void {
			_returnValue = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get proceed():Boolean {
			return _proceed;
		}

		/**
		 * @private
		 */
		public function set proceed(value:Boolean):void {
			_proceed = value;
		}

		public function toString():String {
			return "BasicMethodInvocation{_kind:" + _kind + ", _targetInstance:" + _targetInstance + ", _targetMember:" + _targetMember + ", _targetMethod:" + _targetMethod + ", _proceed:" + _proceed + ", _arguments:[" + _arguments + "], _returnValue:" + _returnValue + "}";
		}

	}
}