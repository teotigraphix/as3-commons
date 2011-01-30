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
package org.as3commons.eventbus.impl {
	import flash.utils.Dictionary;

	import org.as3commons.collections.LinkedList;
	import org.as3commons.eventbus.IBusCollectionLookup;
	import org.as3commons.lang.ObjectUtils;

	public class BusCollectionLookup implements IBusCollectionLookup {

		private var _mainList:LinkedList = new LinkedList();
		private var _topicLists:Dictionary = new Dictionary();
		private var _weakTopicLists:Dictionary = new Dictionary(true);

		public function BusCollectionLookup() {
			super();
		}

		public function remove(item:Object, topic:Object = null):void {
		}

		public function getCollectionCount(topic:Object = null):uint {
			return 0;
		}

		public function getCollection(topic:Object = null):Object {
			return null;
		}

		public function add(item:Object, useWeakReference:Boolean = false, topic:Object = null):void {
			var list:LinkedList = getList(topic);
		}

		protected function getList(topic:Object):LinkedList {
			if (topic == null) {
				return _mainList;
			} else {
				if (ObjectUtils.isSimple(topic)) {

				} else {

				}
			}
			return null;
		}
	}
}