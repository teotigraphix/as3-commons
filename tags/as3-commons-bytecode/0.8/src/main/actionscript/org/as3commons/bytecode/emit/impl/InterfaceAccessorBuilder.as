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
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.lang.StringUtils;

	public class InterfaceAccessorBuilder extends AccessorBuilder {

		private static const INTERFACE_ACCESSOR_NAME:String = "{0}:{1}/{0}:{1}:{2}{3}";

		public var interfaceName:String;

		public function InterfaceAccessorBuilder() {
			super();
		}

		override protected function createMethod():IMethodBuilder {
			var mb:InterfaceMethodBuilder = new InterfaceMethodBuilder();
			mb.name = name;
			mb.packageName = packageName;
			mb.interfaceName = interfaceName;
			return mb;
		}

		override protected function createSlotTrait():SlotOrConstantTrait {
			//interface won't have a private slot for an accessor
			return null;
		}

		override protected function createAccessorName(suffix:String):String {
			return StringUtils.substitute(INTERFACE_ACCESSOR_NAME, packageName, interfaceName, name, suffix);
		}

		override protected function addGetterOpcodes(mb:IMethodBuilder, trait:SlotOrConstantTrait):void {
			//Do nothing, interface methods have no bodies
		}

		override protected function addSetterOpcodes(mb:IMethodBuilder, trait:SlotOrConstantTrait):void {
			//Do nothing, interface methods have no bodies
		}

	}
}