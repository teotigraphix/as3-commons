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
package org.as3commons.bytecode.testclasses.interceptors {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.interception.IMethodInvocation;
	import org.as3commons.bytecode.interception.impl.InvocationKind;

	public class EventDispatcherExInterceptor extends AssertingInterceptor {

		public function EventDispatcherExInterceptor() {
			super();
		}

		override public function intercept(invocation:IMethodInvocation):void {
			if (invocation.kind === InvocationKind.METHOD) {
				switch (invocation.targetMember.localName) {
					case 'addEventListener':
						interceptAddEventListener(invocation);
						break;
					case 'removeEventListener':
						interceptRemoveEventListener(invocation);
						break;
					default:
						break;
				}
			}
		}

		public function interceptAddEventListener(invocation:IMethodInvocation):void {
			if (invocation.targetInstance.as3commons_bytecode::listenersLookup == null) {
				invocation.targetInstance.as3commons_bytecode::listenersLookup = new Dictionary();
			}
			var eventType:String = String(invocation.arguments[0]);
			if (invocation.targetInstance.as3commons_bytecode::listenersLookup[eventType] == null) {
				invocation.targetInstance.as3commons_bytecode::listenersLookup[eventType] = [];
			}
			var arr:Array = invocation.targetInstance.as3commons_bytecode::listenersLookup[eventType];
			arr[arr.length] = invocation.arguments[1];
		}

		public function interceptRemoveEventListener(invocation:IMethodInvocation):void {
			var eventType:String = String(invocation.arguments[0]);
			if (invocation.targetInstance.as3commons_bytecode::listenersLookup[eventType] != null) {
				var arr:Array = invocation.targetInstance.as3commons_bytecode::listenersLookup[eventType];
				var idx:int = arr.indexOf(eventType);
				arr.splice(idx, 1);
			}
		}

	}
}