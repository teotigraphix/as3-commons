package org.as3commons.collections.framework {
	import org.as3commons.collections.framework.ICollection;

	/**
	 * Definition of a collection that may contain duplicates.
	 * 
	 * @author jes 12.04.2010
	 */
	public interface IDuplicates extends ICollection {

		/**
		 * Returns the number of occurrences of an item.
		 * 
		 * @return Number of occurrences of the given item.
		 */
		function count(item : *) : uint;

		/**
		 * Removes all occurrences of a particular item from the collection.
		 * 
		 * <p>The items are removed in the order they are stored.</p>
		 * 
		 * @param item The item to remove completely from the collection.
		 * @return Number of items removed.
		 */
		function removeAll(item : *) : uint;

	}
}
