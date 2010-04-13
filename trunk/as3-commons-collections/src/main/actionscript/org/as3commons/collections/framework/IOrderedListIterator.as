package org.as3commons.collections.framework {

	/**
	 * Insertion ordered list iterator definition.
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>An <code>IOrderedListIterator</code> provides additionally to the base list iterator:</p>
	 * 
	 * <ul>
	 * <li>Insertion operations.<br />
	 * <code>addBefore(), addAfter()</code></li>
	 * <li>Replacing of items.<br />
	 * <code>replace()</code></li></li>
	 * </ul>
	 * 
	 * @author jes 08.03.2010
	 * @see IListIterator IListIterator interface - Detailed description of the base list iterator features.
	 */
	public interface IOrderedListIterator extends IListIterator {

		/**
		 * Adds an item before the current cursor position.
		 * 
		 * <p>The item added will be returned with a subsequent call to <code>previous()</code>.</p>
		 * 
		 * @param item The item to add.
		 * @return The position where the item has been added.
		 */
		function addBefore(item : *) : uint;

		/**
		 * Adds an item after the current cursor position.
		 * 
		 * <p>The item added will be returned with a subsequent call to <code>next()</code>.</p>
		 * 
		 * @param item The item to add.
		 * @return The position where the item has been added.
		 */
		function addAfter(item : *) : uint;

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
