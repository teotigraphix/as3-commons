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
package org.as3commons.bytecode.emit.impl {

	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.reflect.AccessorAccess;

	public class AccessorBuilder extends VariableBuilder implements IAccessorBuilder {

		public function AccessorBuilder() {
			super();
		}

		private var _access:AccessorAccess = AccessorAccess.READ_WRITE;

		public function get access():AccessorAccess {
			return _access;
		}

		public function set access(value:AccessorAccess):void {
			_access = value;
		}

		override public function build():Object {
			return null;
		}
	}
}