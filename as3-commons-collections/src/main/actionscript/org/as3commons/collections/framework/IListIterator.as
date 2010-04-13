package org.as3commons.collections.framework {
	
	/**
	 * Base list iterator definition.
	 * 
	 * <p><strong>Description</strong></p>
	 * 
	 * <p>An <code>IListIterator</code> is an extended <code>ICollectionIterator</code> available
	 * for all list collections.</p>
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>Additionally to the base collection iterator the <code>IListIterator</code>
	 * provides information about the index of the item at the current iterator position:</p>
	 * 
	 * <ul>
	 * <li>Index of the last returned item.<br />
	 * <code>index</code></li>
	 * <li>Lookup for the index of the next or previous item.<br />
	 * <code>nextIndex, previousIndex</code></li>
	 * </ul>
	 * 
	 * @author jes 18.03.2010
	 * @see ICollectionIterator ICollectionIterator interface - Detailed description of the base collection iterator features.
	 */
	public interface IListIterator extends ICollectionIterator {

		/**
		 * The index of the item left to the current cursor position.
		 * 
		 * <p>The item at this index is returned with the next call
		 * to <code>previous()</code>.</p>
		 * 
		 * <p><code>-1</code> if the iterator is positioned at start or
		 * the list is emtpy.</p>
		 */
		function get previousIndex() : int;

		/**
		 * The index of the item right to the current cursor position.
		 * 
		 * <p>The item at this index is returned with the next call
		 * to <code>next()</code>.</p>
		 * 
		 * <p><code>-1</code> if the iterator is positioned at end or
		 * the list is emtpy.</p>
		 */
		function get nextIndex() : int;

		/**
		 * The index of the last returned item.
		 * 
		 * <p><code>-1</code> if the iterator points to the postion before the first
		 * or after the last item or the list is empty.</p>
		 * 
		 * <p>The index is reset to <code>-1</code> after all operations that modify the underlying
		 * list order (<code>add(), remove()</code>) or modify the cursor position
		 * (<code>start(), end()</code>).</p>
		 * 
		 * <p>Initially <code>-1</code>.</p>
		 */
		function get index() : int;

	}
}
