package org.as3commons.collections.framework {

	/**
	 * Base set iterator definition.
	 * 
	 * <p><strong>Description</strong></p>
	 * 
	 * <p>An <code>ISetIterator</code> is an extended <code>ICollectionIterator</code> available
	 * for all set collections.</p>
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>Additionally to the base collection iterator the <code>ISetIterator</code>
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
	public interface ISetIterator extends ICollectionIterator {
		
		/**
		 * The item left to the current cursor position.
		 * 
		 * <p>This item is returned with the next call to <code>previous()</code>.</p>
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at start or
		 * the set is emtpy.</p>
		 */
		function get previousItem() : *;

		/**
		 * The item right to the current cursor position.
		 * 
		 * <p>This item is returned with the next call to <code>next()</code>.</p>
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at end or
		 * the set is emtpy.</p>
		 */
		function get nextItem() : *;
		
	}
}
