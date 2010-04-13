package org.as3commons.collections.framework.core {
	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.framework.ILinkedListIterator;
	import org.as3commons.collections.framework.core.AbstractLinkedCollectionIterator;
	import org.as3commons.collections.framework.core.LinkedNode;
	import org.as3commons.collections.framework.core.as3commons_collections;
	

	/**
	 * Internal <code>LinkedList</code> iterator implementation.
	 * 
	 * @author jes 04.03.2010
	 */
	public class LinkedListIterator extends AbstractLinkedCollectionIterator implements ILinkedListIterator {

		use namespace as3commons_collections;

		/**
		 * LinkedListIterator constructor.
		 * 
		 * @param array The linked list.
		 */
		public function LinkedListIterator(list : LinkedList) {
			super(list);
		}
		
		/*
		 * ILinkedListIterator
		 */

		/**
		 * @inheritDoc
		 */
		public function get previousItem() : * {
			return _next
				? _next.left ? _next.left.item : undefined
				: _collection.size ? _collection.lastNode_internal.item : undefined;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nextItem() : * {
			return _next ? _next.item : undefined;
		}

		/**
		 * @inheritDoc
		 */
		public function addBefore(item : *) : void {
			_current = null;
			LinkedList(_collection).addNodeBefore_internal(_next, new LinkedNode(item));
		}
		
		/**
		 * @inheritDoc
		 */
		public function addAfter(item : *) : void {
			_current = null;

			if (_next) { // before the end
				LinkedList(_collection).addNodeBefore_internal(_next, new LinkedNode(item));
				_next = _next.left;
			} else { // at end or empty list
				LinkedList(_collection).addNodeBefore_internal(null, new LinkedNode(item));
				_next = _collection.lastNode_internal;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function replace(item : *) : Boolean {
			if (!_current) return false;
			
			if (_current.item === item) return false;
			_current.item = item;
			return true;
		}

		/*
		 * AbstractLinkedCollectionIterator protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function removeCurrent() : void {
			LinkedList(_collection).removeNode_internal(_current);
		}

	}
}
