package org.as3commons.collections.framework {

	/**
	 * Base map iterator iterator definition.
	 * 
	 * <p><strong>Description</strong></p>
	 * 
	 * <p>An <code>IMapIterator</code> is an extended <code>ICollectionIterator</code> available
	 * for all map collections.</p>
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>Additionally to the base collection iterator the <code>IListIterator</code>
	 * provides information about the key of the item at the current iterator position:</p>
	 * 
	 * <ul>
	 * <li>Key of the last returned item.<br />
	 * <code>key</code></li>
	 * <li>Lookup for the key of the next or previous item.<br />
	 * <code>nextKey, previousKey</code></li>
	 * </ul>
	 * 
	 * @author jes 18.03.2010
	 * @see ICollectionIterator ICollectionIterator interface - Detailed description of the base collection iterator features.
	 */
	public interface IMapIterator extends ICollectionIterator {
		
		/**
		 * The key of the item left to the current cursor position.
		 * 
		 * <p>The item stored under this key is returned with the next call
		 * to <code>previous()</code>.</p>
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at start or
		 * the map is emtpy.</p>
		 */
		function get previousKey() : *;

		/**
		 * The key of the item right to the current cursor position.
		 * 
		 * <p>The item stored under this key is returned with the next call
		 * to <code>next()</code>.</p>
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at end or
		 * the map is emtpy.</p>
		 */
		function get nextKey() : *;

		/**
		 * The key of the last returned item.
		 * 
		 * <p><code>undefined</code> if the iterator points to the postion before the first
		 * or after the last item or the map is empty.</p>
		 * 
		 * <p>The key is reset to <code>undefined</code> after all operations that modify the underlying
		 * map order (<code>add(), remove()</code>) or modify the cursor position
		 * (<code>start(), end()</code>).</p>
		 * 
		 * <p>Initially <code>undefined</code>.</p>
		 */
		function get key() : *;

		
	}
}
