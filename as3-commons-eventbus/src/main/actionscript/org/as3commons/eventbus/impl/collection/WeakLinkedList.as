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
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IWeakLinkedList;
	import org.as3commons.collections.framework.core.AbstractLinkedDuplicatesCollection;
	import org.as3commons.collections.framework.core.LinkedNode;
	import org.as3commons.collections.framework.core.as3commons_collections;

	public final class WeakLinkedList extends AbstractLinkedDuplicatesCollection implements IWeakLinkedList {

		public function WeakLinkedList() {
			super();
		}

		public function add(item:*, useWeakReference:Boolean = false):void {
			addNodeLast(new WeakLinkedNode(item, useWeakReference));
		}

		public function addFirst(item:*, useWeakReference:Boolean = false):void {
			addNodeFirst(new WeakLinkedNode(item, useWeakReference));
		}

		public function addLast(item:*, useWeakReference:Boolean = false):void {
			addNodeLast(new WeakLinkedNode(item, useWeakReference));
		}

		/**
		 * @inheritDoc
		 */
		override public function iterator(cursor:* = undefined):IIterator {
			return new WeakLinkedListIterator(this);
		}

		/**
		 * Framework internal method to remove a node from the list.
		 *
		 * @param node The node to remove.
		 */
		as3commons_collections function removeNode_internal(node:LinkedNode):void {
			removeNode(node);
		}

		/**
		 * Framework internal method to add a node before an existing one.
		 *
		 * @param next The node to add before.
		 * @param node The node to add.
		 */
		as3commons_collections function addNodeBefore_internal(next:LinkedNode, node:LinkedNode):void {
			addNodeBefore(next, node);
		}

	}
}