package org.as3commons.collections.framework.core {
	import org.as3commons.collections.SortedMap;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.framework.core.AbstractSortedCollectionIterator;
	import org.as3commons.collections.framework.core.SortedMapNode;
	import org.as3commons.collections.framework.core.as3commons_collections;

	/**
	 * Internal <code>SortedMap</code> iterator implementation.
	 * 
	 * @author jes 01.04.2010
	 */
	public class SortedMapIterator extends AbstractSortedCollectionIterator implements IMapIterator {

		use namespace as3commons_collections;
	
		/**
		 * SortedMapIterator constructor.
		 * 
		 * <p>If <code>next</code> is specified, the iterator returns the item of that
		 * node with the first call to <code>next()</code> and its predecessor
		 * with the first call to <code>previous()</code>.</p>
		 * 
		 * @param sortedMap The map to be enumerated.
		 * @param next The node to start the iteration with.
		 */
		public function SortedMapIterator(sortedMap : SortedMap, next : SortedMapNode) {
			super(sortedMap, next);
		}
		
		/*
		 * IMapIterator
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get previousKey() : * {
			if (_next) {
				var previous : SortedMapNode = _collection.previousNode_internal(_next) as SortedMapNode;
				return previous ? previous.key : undefined;
			} else {
				return _collection.size ? SortedMapNode(_collection.mostRightNode_internal()).key : undefined;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nextKey() : * {
			return _next ? SortedMapNode(_next).key : undefined;
		}
	
		/**
		 * @inheritDoc
		 */
		public function get key() : * {
			return _current ? SortedMapNode(_current).key : undefined;
		}

	}
}
