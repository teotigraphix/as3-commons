/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// Compile with: asc -md MethodInvocation.as
package org.as3commons.bytecode.template {
	import org.as3commons.bytecode.as3commons_bytecode;

	public class MethodInvocation {
		public static const REGULAR_METHOD:int = 0;
		public static const GETTER:int = 1;
		public static const SETTER:int = 2;

		private var _instance:*;
		private var _methodName:*;
		private var _args:*;
		private var _originalMethodReference:Function;
		private var _getterSetter:int;

		public function MethodInvocation(instance:*, methodName:String, args:Array, originalMethodReference:Function, getterSetter:int = 0) {
			_instance = instance;
			_methodName = methodName;
			_args = args;
			_originalMethodReference = originalMethodReference;
			_getterSetter = getterSetter;
		}

		public function proceed():* {
			switch (_getterSetter) {
				case REGULAR_METHOD:
					return originalMethodReference.apply(instance, args);

				case GETTER:
					return instance.as3commons_bytecode::getProperty.apply(instance, [methodName]);

				case SETTER:
					instance.as3commons_bytecode::setProperty.apply(instance, [methodName, args[0]]);
					return;
			}
		}

		public function toString():String {
			var argumentString:String = (args) ? args.join(", ") : "";
			return (_methodName + "(" + argumentString + ")");
		}

		public function get instance():* {
			return _instance;
		}

		public function get methodName():String {
			return _methodName;
		}

		public function get args():Array {
			return _args;
		}

		public function get originalMethodReference():Function {
			return _originalMethodReference;
		}
	}
}