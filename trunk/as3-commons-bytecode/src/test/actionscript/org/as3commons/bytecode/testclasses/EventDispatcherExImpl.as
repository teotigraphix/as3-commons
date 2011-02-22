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
package org.as3commons.bytecode.testclasses {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.as3commons_bytecode;

	public class EventDispatcherExImpl implements IEventDispatcherEx {

		as3commons_bytecode var listenersLookup:Dictionary;

		private var _testAccessor:Object;

		public var myPropertyWithMetadata:String;

		public function EventDispatcherExImpl() {
			super();
			this.as3commons_bytecode::listenersLookup = new Dictionary();
		}

		public function get testAccessor():Object {
			return _testAccessor;
		}

		public function set testAccessor(value:Object):void {
			_testAccessor = value;
		}

		public function removeAll():void {
			for each (var type:String in this.as3commons_bytecode::listenersLookup) {
				var listeners:Array = this.as3commons_bytecode::listenersLookup[type] as Array;
				for each (var func:Function in listeners) {
					this['removeEventListener'](type, func);
				}
			}
		}

		public function removeListeners(eventType:String):void {
			var listeners:Array = this.as3commons_bytecode::listenersLookup[eventType] as Array;
			if (listeners != null) {
				for each (var func:Function in listeners) {
					this['removeEventListener'](eventType, func);
				}
			}
		}

		public function getCountListeners(eventType:String = null):uint {
			var result:uint = 0;
			var listeners:Array;
			if (eventType == null) {
				for each (var type:String in this.as3commons_bytecode::listenersLookup) {
					listeners = this.as3commons_bytecode::listenersLookup[type] as Array;
					result += listeners.length;
				}
			} else {
				listeners = this.as3commons_bytecode::listenersLookup[eventType] as Array;
				if (listeners != null) {
					result += listeners.length;
				}
			}
			return result;
		}

		public function getListeners(eventType:String = null):Array {
			return this.as3commons_bytecode::listenersLookup[eventType] as Array;
		}
	}
}