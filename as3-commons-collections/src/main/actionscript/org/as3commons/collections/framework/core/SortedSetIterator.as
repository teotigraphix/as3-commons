package org.as3commons.collections.framework.core {
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.ISetIterator;
	import org.as3commons.collections.framework.core.AbstractSortedCollectionIterator;
	import org.as3commons.collections.framework.core.SortedNode;
	import org.as3commons.collections.framework.core.as3commons_collections;

	/**
	 * Internal <code>SortedSet</code> iterator implementation.
	 * 
	 * @author jes 01.04.2010
	 */
	public class SortedSetIterator extends AbstractSortedCollectionIterator implements ISetIterator {

		use namespace as3commons_collections;

		/**
		 * SortedMapIterator constructor.
		 * 
		 * <p>If <code>next</code> is specified, the iterator returns the item of that
		 * node with the first call to <code>next()</code> and its predecessor
		 * with the first call to <code>previous()</code>.</p>
		 * 
		 * @param sortedSet The set to be enumerated.
		 * @param next The node to start the iteration with.
		 */
		public function SortedSetIterator(sortedSet : SortedSet, next : SortedNode = null) {
			super(sortedSet, next);
		}
		
		/*
		 * ISetIterator
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get previousItem() : * {
			if (_next) {
				var previous : SortedNode = _collection.previousNode_internal(_next);
				return previous ? previous.item : undefined;
			} else {
				return _collection.size ? _collection.mostRightNode_internal().item : undefined;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nextItem() : * {
			return _next ? _next.item : undefined;
		}
	}
}
