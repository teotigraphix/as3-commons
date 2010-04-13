package org.as3commons.collections.framework {

	/**
	 * Base set definition.
	 * 
	 * <p><strong>Description</strong></p>
	 * 
	 * <p>A set cannot contain duplicate elements:</p>
	 * 
	 * <ul>
	 * <li>Elements are addressed by instance directly or sequentially accessed using an iterator.</li>
	 * <li>No predefined oder of items.</li>
	 * <li>Cannot contain duplicates.</li>
	 * </ul>
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>Additionally to the <code>ICollection</code>, a set offers:</p>
	 * 
	 * <ul>
	 * <li>Rich sequential access using an <code>ISetIterator</code>.<br />
	 * <code>iterator()</code></li>
	 * <li>Adding of items.<br />
	 * <code>add()</code></li>
	 * </ul>
	 * 
	 * @author jes 17.03.2010
	 * @see ICollection ICollection interface - Detailed description of the base collection features.
	 */
	public interface ISet extends ICollection {

		/**
		 * Adds an item to the set.
		 * 
		 * <p>If the set already contains the given item, the method abords with <code>false</code>.</p>
		 * 
		 * <p>The <code>LinkedSet</code> appends the item.</p>
		 * 
		 * <p>The position of items that are added to a <code>SortedSet</code>
		 * depends on its sort order.</p>
		 * 
		 * @param item The item to add.
		 * @return <code>true</code> if the item has been added.
		 */
		function add(item : *) : Boolean;

	}

}
