/**
 * Copyright 2011 The original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.eventbus.impl.collection {

	import org.as3commons.collections.framework.core.AbstractLinkedCollection;
	import org.as3commons.collections.framework.core.AbstractLinkedCollectionIterator;
	import org.as3commons.collections.framework.core.as3commons_collections;

	public final class WeakLinkedListIterator extends AbstractLinkedCollectionIterator implements IWeakLinkedListIterator {

		use namespace as3commons_collections;

		public function WeakLinkedListIterator(collection:AbstractLinkedCollection) {
			super(collection);
		}

		/**
		 * @inheritDoc
		 */
		public function get previousItem():* {
			return _next ? _next.left ? _next.left.item : undefined : _collection.size ? _collection.lastNode_internal.item : undefined;
		}

		/**
		 * @inheritDoc
		 */
		public function get nextItem():* {
			return _next ? _next.item : undefined;
		}

		/**
		 * @inheritDoc
		 */
		public function addBefore(item:*, useWeakReference:Boolean = false):void {
			_current = null;
			WeakLinkedList(_collection).addNodeBefore_internal(_next, new WeakLinkedNode(item));
		}

		/**
		 * @inheritDoc
		 */
		public function addAfter(item:*, useWeakReference:Boolean = false):void {
			_current = null;

			if (_next) { // before the end
				WeakLinkedList(_collection).addNodeBefore_internal(_next, new WeakLinkedNode(item, useWeakReference));
				_next = _next.left;
			} else { // at end or empty list
				WeakLinkedList(_collection).addNodeBefore_internal(null, new WeakLinkedNode(item, useWeakReference));
				_next = _collection.lastNode_internal;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function replace(item:*, useWeakReference:Boolean = false):Boolean {
			if (!_current) {
				return false;
			}

			if (_current.item === item) {
				return false;
			}

			_current.item = item;
			return true;
		}

		/*
		* AbstractLinkedCollectionIterator protected
		*/

		/**
		 * @inheritDoc
		 */
		override protected function removeCurrent():void {
			WeakLinkedList(_collection).removeNode_internal(_current);
		}
	}
}