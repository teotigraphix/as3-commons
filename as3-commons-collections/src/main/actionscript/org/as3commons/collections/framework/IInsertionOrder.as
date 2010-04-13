package org.as3commons.collections.framework {
	import org.as3commons.collections.framework.IComparator;

	/**
	 * Definition of a collection that enables precise control over where items are inserted.
	 * 
	 * @author jes 09.04.2010
	 */
	public interface IInsertionOrder extends IOrder {
		
		/**
		 * Reverses the collection order.
		 * 
		 * <p>If the collection size is less than 2, the method aborts with <code>false</code>.</p>
		 * 
		 * @return <code>true</code> if the collection has been reversed.
		 */
		function reverse() : Boolean;

		/**
		 * Sorts the linked collection using the given comparator.
		 * 
		 * <p>The sort algorithm used by implementors of this interface is stable which
		 * means that equal items are sorted in the same order they had before the sorting.</p>
		 * 
		 * <p>If the collection size is less than 2, the method aborts with <code>false</code>.</p>
		 * 
		 * @param comparator The sort criterion.
		 * @return <code>true</code> if the linked collection has been sorted.
		 */
		function sort(comparator : IComparator) : Boolean;

	}
}
