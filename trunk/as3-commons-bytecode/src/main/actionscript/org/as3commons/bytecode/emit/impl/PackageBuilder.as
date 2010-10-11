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
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
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
			_packageName = name;
			_classBuilders = [];
			_interfaceBuilders = [];
			_methodBuilders = [];
			_variableBuilders = [];
		}

		private var _packageName:String;

		public function get packageName():String {
			return _packageName;
		}

		public function defineClass(name:String):IClassBuilder {
			var cb:ClassBuilder = new ClassBuilder();
			cb.name = name;
			cb.packageName = packageName;
			_classBuilders[_classBuilders.length] = cb;
			return cb;
		}

		public function defineInterface(name:String):IInterfaceBuilder {
			var ib:InterfaceBuilder = new InterfaceBuilder();
			ib.name = name;
			ib.packageName = packageName;
			_interfaceBuilders[_interfaceBuilders.length] = ib;
			return ib;
		}

		public function defineMethod(name:String):IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.name = name;
			mb.packageName = packageName;
			_methodBuilders[_methodBuilders.length] = mb;
			return mb;
		}

		public function defineVariable(name:String):IVariableBuilder {
			var vb:VariableBuilder = new VariableBuilder();
			vb.name = name;
			vb.packageName = packageName;
			_variableBuilders[_variableBuilders.length] = vb;
			return vb;
		}

		public function build():Array {
			var result:Array = [];
			for each (var cb:IClassBuilder in _classBuilders) {
				result = result.concat(cb.build());
			}
			for each (var ib:IInterfaceBuilder in _interfaceBuilders) {
				result[result.length] = ib.build()[1];
			}
			for each (var mb:IMethodBuilder in _methodBuilders) {
				result[result.length] = mb.build();
			}
			for each (var vb:IVariableBuilder in _variableBuilders) {
				result[result.length] = vb.build();
			}
			return result;
		}
	}
}