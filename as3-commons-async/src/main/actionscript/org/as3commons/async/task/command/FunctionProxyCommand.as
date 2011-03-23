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
package org.as3commons.async.task.command {

	import org.as3commons.async.command.ICommand;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.MethodInvoker;

	/**
	 * <code>ICommand</code> wrapper for <code>MethodInvoker</code> instances.
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#tasks
	 */
	public class FunctionProxyCommand implements ICommand {

		private var _methodInvoker:MethodInvoker;

		public function get methodInvoker():MethodInvoker {
			return _methodInvoker;
		}

		public function set methodInvoker(value:MethodInvoker):void {
			_methodInvoker = value;
		}

		/**
		 * Creates a new <code>FunctionProxyCommand</code> instance.
		 */
		public function FunctionProxyCommand(target:Object = null, methodName:String = "", arguments:Array = null) {
			super();
			init(target, methodName, arguments);
		}

		/**
		 * Initializes the <code>FunctionProxyCommand</code>.
		 * @param target
		 * @param methodName
		 * @param arguments
		 */
		protected function init(target:Object, methodName:String, arguments:Array):void {
			if ((target != null) && (methodName.length > 0)) {
				_methodInvoker = new MethodInvoker();
				_methodInvoker.target = target;
				_methodInvoker.method = methodName;
				_methodInvoker.arguments = arguments;
			}
		}

		public function execute():* {
			Assert.state((_methodInvoker != null), "methodInvoker must not be null");
			return _methodInvoker.invoke();
		}

	}
}