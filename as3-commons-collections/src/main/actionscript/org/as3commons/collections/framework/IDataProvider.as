package org.as3commons.collections.framework {

	/**
	 * Data provider definition.
	 * 
	 * <p><strong>Description</strong></p>
	 * 
	 * <p>A data provider is a data structure with a known size and an index
	 * based read access. The data provider interface is required by data
	 * driven user interface controls.</p>
	 * 
	 * <p><strong>Note</strong></p>
	 * 
	 * <p>This library provides only two implementors of this interface (<code>ArrayList,
	 * SortedList</code>).</p>
	 * 
	 * @author jes 09.03.2010
	 */
	public interface IDataProvider {
		
		/**
		 * The number of items contained by the data provider.
		 */
		function get size() : uint;
		
		/**
		 * Returns the item at the specified position.
		 * 
		 * @param index The position of the item to get.
		 * @return The item or <code>undefined</code> if the position is invalid.
		 */
		function itemAt(index : uint) : *;

	}
	
}
