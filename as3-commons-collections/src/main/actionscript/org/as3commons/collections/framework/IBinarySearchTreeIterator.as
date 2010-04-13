package org.as3commons.collections.framework {

	/**
	 * Binary search tree data structure iterator definition.
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>Additionally to the base collection iterator the <code>IBinarySearchTreeIterator</code>
	 * provides information about the item at the current iterator position:</p>
	 * 
	 * <ul>
	 * <li>Lookup for the next or previous item.<br />
	 * <code>nextItem, previousItem</code></li>
	 * </ul>
	 * 
	 * @author jes 01.04.2010
	 * @see ICollectionIterator ICollectionIterator interface - Detailed description of the base collection iterator features.
	 */
	public interface IBinarySearchTreeIterator extends ICollectionIterator {

		/**
		 * The item left to the current cursor position.
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at start or
		 * the tree is emtpy.</p>
		 */
		function get previousItem() : *;

		/**
		 * The item right to the current cursor position.
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at end or
		 * the tree is emtpy.</p>
		 */
		function get nextItem() : *;

	}
}
