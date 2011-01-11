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
package org.as3commons.bytecode.proxy.event {
	import flash.events.Event;

	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.impl.BaseBuilder;
	import org.as3commons.bytecode.interception.InvocationKind;

	/**
	 * Dispatched at various stages of proxy building. Enables third parties to intercept certain
	 * stages of proxy building and add cusotm behaviour to the generated proxy classes.
	 * @author Roland Zwaga
	 */
	public class ProxyFactoryBuildEvent extends Event {

		/**
		 * Dispatched after a proxy class has been generated.
		 */
		public static const AFTER_PROXY_BUILD:String = "afterProxyBuild";
		/**
		 * Dispatched before the constructor body will be built.
		 */
		public static const BEFORE_CONSTRUCTOR_BODY_BUILD:String = "beforeConstructorBodyBuild";
		/**
		 * Dispatched before a method body will be built.
		 */
		public static const BEFORE_METHOD_BODY_BUILD:String = "beforeMethodBodyBuild";
		/**
		 * Dispatched before a getter body will be built.
		 */
		public static const BEFORE_GETTER_BODY_BUILD:String = "beforeGetterBodyBuild";
		/**
		 * Dispatched before a setter body will be built.
		 */
		public static const BEFORE_SETTER_BODY_BUILD:String = "beforeSetterBodyBuild";

		private var _methodBuilder:IMethodBuilder;
		private var _classBuilder:IClassBuilder;
		private var _proxiedClass:Class;

		/**
		 * Creates a new <code>ProxyFactoryBuildEvent</code> instance.
		 * @param type
		 * @param methodBuilder
		 * @param classBuilder
		 * @param proxiedClass
		 * @param bubbles
		 * @param cancelable
		 */
		public function ProxyFactoryBuildEvent(type:String, methodBuilder:IMethodBuilder, classBuilder:IClassBuilder = null, proxiedClass:Class = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			initProxyFactoryBuildEvent(methodBuilder, classBuilder, proxiedClass);
		}

		/**
		 * Initializes the current <code>ProxyFactoryBuildEvent</code> instance.
		 * @param methodBuilder
		 * @param classBuilder
		 * @param proxiedClass
		 *
		 */
		protected function initProxyFactoryBuildEvent(methodBuilder:IMethodBuilder, classBuilder:IClassBuilder, proxiedClass:Class):void {
			_methodBuilder = methodBuilder;
			_classBuilder = classBuilder;
			_proxiedClass = proxiedClass;
		}

		/**
		 * A reference to the <code>Class</code> that is being proxied.
		 */
		public function get proxiedClass():Class {
			return _proxiedClass;
		}

		/**
		 * A reference to the <code>IClassBuilder</code> that is used to generate the proxy class.
		 */
		public function get classBuilder():IClassBuilder {
			return _classBuilder;
		}

		/**
		 * A reference to the <code>IMethodBuilder</code> that is used to generate a proxy method.
		 */
		public function get methodBuilder():IMethodBuilder {
			return _methodBuilder;
		}

		/**
		 * Returns an exact copy of the current <code>ProxyFactoryBuildEvent</code>.
		 * @return An exact copy of the current <code>ProxyFactoryBuildEvent</code>.
		 */
		public override function clone():Event {
			return new ProxyFactoryBuildEvent(this.type, this.methodBuilder, this.classBuilder, this.proxiedClass, this.bubbles, this.cancelable);
		}

	}
}