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
	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class PackageBuilder implements IPackageBuilder {

		private var _classBuilders:Array;
		private var _interfaceBuilders:Array;
		private var _methodBuilders:Array;
		private var _variableBuilders:Array;

		/**
		 * Creates a new <code>PackageBuilder</code> instance.
		 * @param name The fully qualified name of the package. I.e. <code>com.myclasses.generated</code>
		 */
		public function PackageBuilder(name:String) {
			super();
			init(name);
		}

		private function init(name:String):void {
			Assert.hasText(name, "name argument must not be null or empty");
			_packageName = removeTrailingPeriod(name);
			_classBuilders = [];
			_interfaceBuilders = [];
			_methodBuilders = [];
			_variableBuilders = [];
		}

		private var _packageName:String;

		/**
		 * @inheritDoc
		 */
		public function get packageName():String {
			return _packageName;
		}

		/**
		 * @inheritDoc
		 */
		public function defineClass(name:String, superClassName:String = null):IClassBuilder {
			var cb:ClassBuilder = new ClassBuilder();
			cb.name = name;
			cb.packageName = packageName;
			cb.superClassName = superClassName;
			_classBuilders[_classBuilders.length] = cb;
			return cb;
		}

		/**
		 * @inheritDoc
		 */
		public function defineInterface(name:String, superInterfaceName:String = null):IInterfaceBuilder {
			var ib:InterfaceBuilder = new InterfaceBuilder();
			ib.name = name;
			ib.superClassName = superInterfaceName;
			ib.packageName = packageName;
			_interfaceBuilders[_interfaceBuilders.length] = ib;
			return ib;
		}

		/**
		 * @inheritDoc
		 */
		public function defineMethod(name:String):IMethodBuilder {
			var mb:MethodBuilder = new MethodBuilder();
			mb.name = name;
			mb.packageName = packageName;
			_methodBuilders[_methodBuilders.length] = mb;
			return mb;
		}

		/**
		 * @inheritDoc
		 */
		public function defineProperty(name:String = null, type:String = null, initialValue:* = undefined):IPropertyBuilder {
			var vb:PropertyBuilder = new PropertyBuilder();
			vb.name = name;
			vb.packageName = packageName;
			_variableBuilders[_variableBuilders.length] = vb;
			return vb;
		}

		/**
		 * @inheritDoc
		 */
		public function build(applicationDomain:ApplicationDomain):Array {
			var result:Array = [];
			for each (var cb:IClassBuilder in _classBuilders) {
				result = result.concat(cb.build(applicationDomain));
			}
			for each (var ib:IInterfaceBuilder in _interfaceBuilders) {
				result[result.length] = ib.build(applicationDomain)[1];
			}
			for each (var mb:IMethodBuilder in _methodBuilders) {
				result[result.length] = mb.build();
			}
			for each (var vb:IPropertyBuilder in _variableBuilders) {
				result[result.length] = vb.build();
			}
			return result;
		}

		/**
		 * If the specified input has a trailing period ('.') it will be removed from the string
		 * and the result will be returned. Otherwise the original string is returned.
		 * @param input The specified input string.
		 * @return The input without a trailing period.
		 */
		protected function removeTrailingPeriod(input:String):String {
			if (input[input.length - 1] == '.') {
				return input.substring(0, input.length - 2);
			}
			return input;
		}
	}
}