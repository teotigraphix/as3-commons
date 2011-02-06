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

	import org.as3commons.collections.WeakLinkedList;
	import org.as3commons.collections.framework.core.WeakLinkedListIterator;
	import org.as3commons.eventbus.IEventBusCollectionLookup;
	import org.as3commons.lang.ObjectUtils;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class EventBusCollectionLookup implements IEventBusCollectionLookup {

		private var _mainList:WeakLinkedList = new WeakLinkedList();
		private var _topicLists:Dictionary = new Dictionary();
		private var _weakTopicLists:Dictionary = new Dictionary(true);

		/**
		 * Creates a new <code>BusCollectionLookup</code> instance.
		 */
		public function EventBusCollectionLookup() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function remove(item:Object, topic:Object = null):void {
			var linkedList:WeakLinkedList = getList(topic, false);
			if (linkedList != null) {
				var iterator:WeakLinkedListIterator = new WeakLinkedListIterator(linkedList);
				while (iterator.hasNext()) {
					iterator.next();
					if (iterator.current === item) {
						iterator.remove();
						break;
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getCollectionCount(topic:Object = null):uint {
			var linkedList:WeakLinkedList = getList(topic, false);
			return (linkedList != null) ? linkedList.size : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function getCollection(topic:Object = null):WeakLinkedList {
			return getList(topic, false);
		}

		/**
		 * @inheritDoc
		 */
		public function add(item:Object, useWeakReference:Boolean = false, topic:Object = null):void {
			var list:WeakLinkedList = getList(topic);
			list.add(item, useWeakReference);
		}

		protected function getList(topic:Object, createIfNotExists:Boolean = true):WeakLinkedList {
			if (topic == null) {
				return _mainList;
			} else {
				if (ObjectUtils.isSimple(topic)) {
					return getTopicList(topic, createIfNotExists);
				} else {
					return getWeakTopicList(topic, createIfNotExists);
				}
			}
		}

		protected function getTopicList(topic:Object, createIfNotExists:Boolean = true):WeakLinkedList {
			return getLinkedList(_topicLists, topic, createIfNotExists);
		}

		protected function getWeakTopicList(topic:Object, createIfNotExists:Boolean = true):WeakLinkedList {
			return getLinkedList(_weakTopicLists, topic, createIfNotExists);
		}

		protected function getLinkedList(dictionary:Dictionary, topic:Object, createIfNotExists:Boolean):WeakLinkedList {
			if ((dictionary[topic] == null) && (createIfNotExists)) {
				dictionary[topic] = new WeakLinkedList();
			}
			return dictionary[topic] as WeakLinkedList;
		}

	}
}