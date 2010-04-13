package org.as3commons.collections.framework.core {
	import org.as3commons.collections.framework.IDuplicates;

	/**
	 * Abstract linked list based collection implementation with permission of duplicates.
	 * 
	 * @author jes 12.04.2010
	 */
	public class AbstractLinkedDuplicatesCollection extends AbstractLinkedCollection implements IDuplicates {

		/**
		 * @inheritDoc
		 */
		public function count(item : *) : uint {
			var count : uint = 0;
			var node : LinkedNode = _first;
			while (node) {
				if (node.item === item) count++;
				node = node.right;
			}
			return count;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAll(item : *) : uint {
			var size : uint = _size;
			var node : LinkedNode = _first;
			var right : LinkedNode;
			while (node) {
				right = node.right;
				if (node.item === item) {
					removeNode(node);
				}
				node = right;
			}
			return size - _size;
		}
		
	}
}
