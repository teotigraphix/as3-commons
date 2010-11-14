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
package org.as3commons.eventbus.impl {

	import org.as3commons.lang.SoftReference;

	/**
	 * Collection that holds a list of weakly and hard referenced event listeners or proxies.
	 * @author Roland Zwaga
	 */
	public class ListenerCollection {

		private var _collection:Array;

		/**
		 * Creates a new <code>ListenerCollection</code> instance.
		 */
		public function ListenerCollection() {
			super();
			_collection = [];
		}

		public function add(item:Object, useWeakReference:Boolean):void {
			if (!useWeakReference) {
				_collection[_collection.length] = item;
			} else {
				_collection[_collection.length] = new SoftReference(item);
			}
		}

		public function remove(item:Object):void {
			var idx:int = indexOf(item);
			if (idx > -1) {
				var sf:SoftReference = _collection[idx] as SoftReference;
				if (sf != null) {
					sf.value = null;
				}
				_collection.splice(idx, 1);
			}
		}

		public function get(index:uint):Object {
			if (index < _collection.length) {
				var obj:Object = _collection[index];
				if (obj is SoftReference) {
					return SoftReference(obj).value;
				} else {
					return obj;
				}
			}
			return null;
		}

		public function indexOf(item:Object):int {
			for (var i:uint = 0; i < _collection.length; i++) {
				var obj:Object = _collection[i];
				if (obj === item) {
					return i;
				} else if ((obj is SoftReference) && (SoftReference(obj).value === item)) {
					return i;
				}
			}
			return -1;
		}

		public function get length():uint {
			return _collection.length;
		}

	}
}