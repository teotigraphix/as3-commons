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
package org.as3commons.lang {
	import flash.utils.Dictionary;

	public class HashArray {
		private static const UNDERSCORE_CHAR:String = '_';
		private static const _SUFFIX:String = UNDERSCORE_CHAR + (9999 + Math.floor(Math.random() * 9999)).toString();

		//These are all the properties and method names of Object, these are illegal names to be used as a key in a Dictionary:
		private static const illegalKeys:Object = {hasOwnProperty_: true, //
				isPrototypeOf_: true, //
				propertyIsEnumerable_: true, //
				setPropertyIsEnumerable_: true, //
				toLocaleString_: true, //
				toString_: true, //
				valueOf_: true, //
				prototype_: true, //
				constructor_: true};

		public function HashArray(lookUpPropertyName:String, allowDuplicates:Boolean=false, items:Array=null) {
			super();
			init(lookUpPropertyName, allowDuplicates, items);
		}

		private var _allowDuplicates:Boolean = false;

		private var _list:Array;
		private var _lookUpPropertyName:String;
		private var _lookup:Object;

		public function get allowDuplicates():Boolean {
			return _allowDuplicates;
		}

		public function set allowDuplicates(value:Boolean):void {
			_allowDuplicates = value;
		}

		public function get length():uint {
			return _list.length;
		}

		public function get(lookupPropertyValue:String):* {
			lookupPropertyValue = makeValidKey(lookupPropertyValue);
			return _lookup[lookupPropertyValue];
		}

		public function getArray():Array {
			return _list.concat();
		}

		public function pop():* {
			var value:* = _list.pop();
			removeFromLookup(value);
			return value;
		}

		public function push(... parameters):uint {
			var len:uint = parameters.length;
			var args:Array;
			if (len == 1 && parameters[0] is Array) {
				args = parameters[0] as Array;
				len = args.length;
			} else {
				args = parameters;
			}
			for (var i:uint = 0; i < len; i++) {
				pushOne(args[i]);
			}
			return _list.length;
		}

		public function rehash():void {
			_lookup = new Dictionary();
			var len:uint = _list.length;
			var val:*;
			for (var i:uint; i < len; i++) {
				val = _list[i];
				if (val != null) {
					addToLookup(val);
				}
			}
		}

		public function shift():* {
			var item:* = _list.shift();
			removeFromLookup(item);
			return item;
		}

		public function splice(... parameters):* {
			var result:* = _list.splice.apply(_list, parameters);
			rehash();
			return result;
		}

		protected function add(items:Array):void {
			if (items != null) {
				var len:uint = items.length;
				for (var i:uint = 0; i < len; i++) {
					pushOne(items[i]);
				}
			}
		}

		protected function addToLookup(newItem:*):void {
			var validKey:* = makeValidKey(newItem[_lookUpPropertyName]);
			if (_allowDuplicates) {
				var items:* = _lookup[validKey];
				var arr:Array;
				if (items == null) {
					_lookup[validKey] = [newItem];
				} else if (items is Array) {
					arr = (items as Array);
					arr[arr.length] = newItem;
				} else {
					arr = [];
					arr[arr.length] = items;
					arr[arr.length] = newItem;
					_lookup[validKey] = arr;
				}
			} else {
				var oldItem:* = _lookup[validKey];
				if (oldItem != null) {
					ArrayUtils.removeFirstOccurance(_list, oldItem);
				}
				_lookup[validKey] = newItem;
			}
		}

		protected function init(lookUpPropertyName:String, allowDuplicates:Boolean, items:Array):void {
			_lookup = {};
			_lookUpPropertyName = makeValidKey(lookUpPropertyName);
			_allowDuplicates = allowDuplicates;
			_list = [];
			add(items);
		}

		protected function makeValidKey(propertyValue:*):* {
			if (!(propertyValue is String)) {
				return propertyValue;
			} else if (illegalKeys.hasOwnProperty(String(propertyValue) + UNDERSCORE_CHAR)) {
				return String(propertyValue) + _SUFFIX;
			}
			return propertyValue;
		}

		protected function pushOne(item:*):void {
			addToLookup(item);
			_list[_list.length] = item;
		}

		protected function removeFromLookup(item:*):void {
			var value:* = _lookup[item[_lookUpPropertyName]];
			if ((value is Array) && (_allowDuplicates)) {
				var arr:Array = (value as Array);
				arr.splice(arr.length - 1, 1);
				if (arr.length < 1) {
					delete _lookup[item[_lookUpPropertyName]];
				}
			} else {
				delete _lookup[item[_lookUpPropertyName]];
			}
		}
	}
}
