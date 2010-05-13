/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.emit.bytecode {

	import flash.utils.Dictionary;

	import org.as3commons.emit.reflect.EmitMethod;
	import org.as3commons.emit.reflect.EmitType;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IEquals;


	public class ByteCodeLayoutBuilder implements IByteCodeLayoutBuilder {

		private var _types:Array = [];
		private var _methods:Dictionary = new Dictionary();

		private var _ignoredPackages:Array = ["flash.*", "mx.*", "fl.*", ":Object"];

		public function ByteCodeLayoutBuilder() {
			super();
		}

		public function registerType(type:EmitType):void {
			Assert.notNull(type, "type argument must not be null");
			if (_types.indexOf(type) == -1) {
				/* if (type.isGeneric)
				   {
				   registerType(type.genericTypeDefinition);
				 } */

				if (type.superClassType != type && type.superClassType != null) {
					registerType(type.superClassType);
				}

				for each (var interfaze:Class in type.interfaces) {
					var interfaceType:EmitType = EmitType.forClass(interfaze);
					registerType(interfaceType);
				}

				_types.push(type);
			}
		}

		public function registerMethodBody(method:EmitMethod, methodBody:DynamicMethod):void {
			Assert.notNull(method, "method argument must not be null");
			Assert.notNull(methodBody, "methodBody argument must not be null");
			_methods[method] = methodBody;
		}

		public function createLayout():IByteCodeLayout {
			var layout:ByteCodeLayout = new ByteCodeLayout();

			for each (var type:EmitType in this._types) {
				var dynamicClass:DynamicClass = type as DynamicClass;

				if (isIgnored(type) || dynamicClass == null) {
					layout.registerMultiname(type.multiname);
					layout.registerMultiname(type.multiNamespaceName);
				} else {
					layout.registerClass(type);

					//if (dynamicClass != null)
					{
						for each (var methodBody:DynamicMethod in dynamicClass.getMethodBodies()) {
							layout.registerMethodBody(methodBody.method, methodBody);
						}
					}
				}
			}

			return layout;
		}

		private function isIgnored(type:EmitType):Boolean {
			Assert.notNull(type, "type argument must not be null");
			for each (var ignoredPackage:String in _ignoredPackages) {
				if (ByteCodeUtils.packagesMatch(ignoredPackage, type.fullName)) {
					return true;
				}
			}

			return false;
		}

		private function pushUniqueValue(array:Array, value:IEquals):uint {
			Assert.notNull(array, "array argument must not be null");
			Assert.notNull(value, "value argument must not be null");
			for (var i:uint = 0; i < array.length; i++) {
				if (value.equals(array[i]))
					return i;
			}

			array[array.length] = value;

			return array.length - 1;
		}
	}
}