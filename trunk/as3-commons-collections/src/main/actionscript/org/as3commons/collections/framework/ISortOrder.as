package org.as3commons.collections.framework {

	/**
	 * Definition of a collection whose items are stored in a sorted order. 
	 * 
	 * @author jes 09.04.2010
	 */
	public interface ISortOrder extends IOrder {

		/**
		 * Tests if the collection contains an item that is equal to the given item.
		 * 
		 * <p>Returns of course <code>true</code> if the given item is contained.</p>
		 * 
		 * @param item The item to test.
		 * @return <code>true</code> if there is an equal item contained.
		 */
		function hasEqual(item : *) : Boolean;

	}
}
