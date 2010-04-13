package org.as3commons.collections.framework {

	/**
	 * Linked list data structure iterator definition.
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>An <code>ILinkedListIterator</code> provides additionally to the base collection iterator:</p>
	 * 
	 * <ul>
	 * <li>Insertion operations.<br />
	 * <code>addBefore(), addAfter()</code></li>
	 * <li>Replacing of items.<br />
	 * <code>replace()</code></li></li>
	 * </ul>
	 * 
	 * @author jes 04.03.2010
	 * @see ICollectionIterator ICollectionIterator interface - Detailed description of the base collection iterator features.
	 */
	public interface ILinkedListIterator extends ICollectionIterator {

		/**
		 * The item left to the current cursor position.
		 * 
		 * <p>This item is returned with the next call to <code>previous()</code>.</p>
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at start or
		 * the list is emtpy.</p>
		 */
		function get previousItem() : *;

		/**
		 * The item right to the current cursor position.
		 * 
		 * <p>This item is returned with the next call to <code>next()</code>.</p>
		 * 
		 * <p><code>undefined</code> if the iterator is positioned at end or
		 * the list is emtpy.</p>
		 */
		function get nextItem() : *;

		/**
		 * Adds an item before the current cursor position.
		 * 
		 * <p>The item added will be returned with a subsequent call to <code>previous()</code>.</p>
		 * 
		 * @param item The item to add.
		 */
		function addBefore(item : *) : void;

		/**
		 * Adds an item after the current cursor position.
		 * 
		 * <p>The item added will be returned with a subsequent call to <code>next()</code>.</p>
		 * 
		 * @param item The item to add.
		 */
		function addAfter(item : *) : void;

		/**
		 * Replaces the current item if any.
		 * 
		 * <p>If the iterator has no current item or the replacing item
		 * strictly equals the existing one, this method aborts with <code>false</code>.</p>
		 * 
		 * @param item The replacing item.
		 * @return <code>true</code> if the current item has been replaced.
		 */
		function replace(item : *) : Boolean;

	}
}
