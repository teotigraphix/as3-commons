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

	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IVariableBuilder;
	import org.as3commons.lang.Assert;

	public class PackageBuilder implements IPackageBuilder {

		private var _classBuilders:Array;
		private var _interfaceBuilders:Array;
		private var _methodBuilders:Array;
		private var _variableBuilders:Array;

		public function PackageBuilder(name:String) {
			super();
			init(name);
		}

		private function init(name:String):void {
			Assert.hasText(name, "name argument must not be null or empty");
			_name = name;
			_classBuilders = [];
			_interfaceBuilders = [];
			_methodBuilders = [];
			_variableBuilders = [];
		}

		private var _name:String;

		public function get name():String {
			return _name;
		}

		public function defineClass():IClassBuilder {
			return null;
		}

		public function defineInterface():IInterfaceBuilder {
			return null;
		}

		public function defineMethod():IMethodBuilder {
			return null;
		}

		public function defineVariable():IVariableBuilder {
			return null;
		}

		public function build():Array {
			return null;
		}
	}
}