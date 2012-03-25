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
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.eventbus.IEventBusCollectionLookup;
	import org.as3commons.eventbus.impl.collection.WeakLinkedList;
	import org.as3commons.eventbus.impl.collection.WeakLinkedListIterator;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.ObjectUtils;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public final class EventBusCollectionLookup implements IEventBusCollectionLookup, IDisposable {

		/**
		 * Creates a new <code>BusCollectionLookup</code> instance.
		 */
		public function EventBusCollectionLookup() {
			super();
		}

		private var _isDisposed:Boolean;

		private var _mainList:WeakLinkedList = new WeakLinkedList();
		private var _topicLists:Dictionary = new Dictionary();
		private var _weakTopicLists:Dictionary = new Dictionary(true);

		/**
		 * @inheritDoc
		 */
		public function add(item:Object, useWeakReference:Boolean=false, topic:Object=null):void {
			var list:WeakLinkedList = getList(topic);
			if (!list.has(item)) {
				list.add(item, useWeakReference);
			}
		}

		public function dispose():void {
			if (!_isDisposed) {
				disposeLinkedList(_mainList);
				var item:*;
				for (item in _topicLists) {
					disposeLinkedList(_topicLists[item]);
					delete _topicLists[item];
				}
				for (item in _weakTopicLists) {
					disposeLinkedList(_weakTopicLists[item]);
					delete _weakTopicLists[item];
				}
				_mainList = null;
				_topicLists = null;
				_weakTopicLists = null;
				_isDisposed = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getCollection(topic:Object=null):WeakLinkedList {
			return getList(topic, false);
		}

		/**
		 * @inheritDoc
		 */
		public function getCollectionCount(topic:Object=null):uint {
			var linkedList:WeakLinkedList = getList(topic, false);
			return (linkedList != null) ? linkedList.size : 0;
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(item:Object, topic:Object=null):void {
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

		protected function disposeLinkedList(list:WeakLinkedList):void {
			var iterator:IIterator = list.iterator();
			while (iterator.hasNext()) {
				var disposable:IDisposable = iterator.next() as IDisposable;
				if (disposable != null) {
					disposable.dispose();
				}
			}
			list.clear();
		}

		protected function getLinkedList(dictionary:Dictionary, topic:Object, createIfNotExists:Boolean):WeakLinkedList {
			if ((dictionary[topic] == null) && (createIfNotExists)) {
				dictionary[topic] = new WeakLinkedList();
			}
			return dictionary[topic] as WeakLinkedList;
		}

		protected function getList(topic:Object, createIfNotExists:Boolean=true):WeakLinkedList {
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

		protected function getTopicList(topic:Object, createIfNotExists:Boolean=true):WeakLinkedList {
			return getLinkedList(_topicLists, topic, createIfNotExists);
		}

		protected function getWeakTopicList(topic:Object, createIfNotExists:Boolean=true):WeakLinkedList {
			return getLinkedList(_weakTopicLists, topic, createIfNotExists);
		}
	}
}
