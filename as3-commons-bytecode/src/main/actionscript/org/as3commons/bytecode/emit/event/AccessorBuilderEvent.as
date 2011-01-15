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
package org.as3commons.bytecode.emit.event {
	import flash.events.Event;

	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.impl.AccessorBuilder;

	public class AccessorBuilderEvent extends Event {

		public static const BUILD_GETTER:String = "buildGetter";
		public static const BUILD_SETTER:String = "buildSetter";

		private var _accessorBuilder:IAccessorBuilder;
		private var _trait:SlotOrConstantTrait;
		private var _builder:IMethodBuilder;

		public function AccessorBuilderEvent(type:String, accessorBuilder:IAccessorBuilder, trait:SlotOrConstantTrait, methodBuilder:IMethodBuilder = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_accessorBuilder = accessorBuilder;
			_trait = trait;
			_builder = methodBuilder;
		}

		public function get accessorBuilder():IAccessorBuilder {
			return _accessorBuilder;
		}

		public function get trait():SlotOrConstantTrait {
			return _trait;
		}

		public function get builder():IMethodBuilder {
			return _builder;
		}

		public function set builder(value:IMethodBuilder):void {
			_builder = value;
		}

		override public function clone():Event {
			return new AccessorBuilderEvent(this.type, this.accessorBuilder, this.trait, this.builder, this.bubbles, this.cancelable);
		}

	}
}