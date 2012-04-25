/*
* Copyright 2007-2012 the original author or authors.
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

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class ProxyNameCreationEvent extends Event {

		public static const CREATE_PACKAGE_NAME:String = "createProxyPackageName";
		public static const CREATE_CLASS_NAME:String = "createProxyClassName";

		private var _originalName:String;
		private var _proxyName:String = null;

		/**
		 * Creates a new <code>ProxyNameCreationEvent</code> instance.
		 */
		public function ProxyNameCreationEvent(type:String, name:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_originalName = name;
		}

		public function get proxyName():String {
			return _proxyName;
		}

		public function set proxyName(value:String):void {
			_proxyName = value;
		}

		public function get originalName():String {
			return _originalName;
		}

		override public function clone():Event {
			var evt:ProxyNameCreationEvent = new ProxyNameCreationEvent(type, originalName, bubbles, cancelable);
			evt.proxyName = proxyName;
			return evt;
		}

	}
}
