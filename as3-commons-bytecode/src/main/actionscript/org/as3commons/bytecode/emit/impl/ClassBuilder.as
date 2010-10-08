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
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IVariableBuilder;

	public class ClassBuilder extends BaseBuilder implements IClassBuilder {

		private static const MULTIPLE_CONSTRUCTORS_ERROR:String = "A class can only have one constructor defined";
		private static const OBJECT_BASE_CLASS_NAME:String = "Object";

		private var _ctorBuilder:ICtorBuilder;
		private var _implementedInterfaceNames:Array;
		private var _methodBuilders:Array;
		private var _accessorBuilders:Array;
		private var _variableBuilders:Array;
		private var _extendsType:String = OBJECT_BASE_CLASS_NAME;

		public function ClassBuilder() {
			super();
			initClassBuilder();
		}

		protected function initClassBuilder():void {
			_methodBuilders = [];
			_accessorBuilders = [];
			_variableBuilders = [];
			_implementedInterfaceNames = [];
		}

		public function get superClassName():String {
			return _extendsType;
		}

		public function set superClassName(value:String):void {
			_extendsType = value;
		}

		public function implementInterface(name:String):void {
			if (_implementedInterfaceNames.indexOf(name) < 0) {
				_implementedInterfaceNames[_implementedInterfaceNames.length] = name;
			}
		}

		public function defineConstructor():ICtorBuilder {
			if (_ctorBuilder != null) {
				throw new IllegalOperationError(MULTIPLE_CONSTRUCTORS_ERROR);
			}
			return new CtorBuilder(this.name);
		}

		public function defineMethod():IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			_methodBuilders[_methodBuilders.length] = mb;
			return mb;
		}

		public function defineAccessor():IAccessorBuilder {
			var ab:AccessorBuilder = new AccessorBuilder();
			_accessorBuilders[_accessorBuilders.length] = ab;
			return ab;
		}

		public function defineVariable():IVariableBuilder {
			var vb:VariableBuilder = new VariableBuilder();
			_variableBuilders[_variableBuilders.length] = vb;
			return vb;
		}

		public function build():ClassInfo {
			var ci:ClassInfo = new ClassInfo();
			return ci;
		}
	}
}