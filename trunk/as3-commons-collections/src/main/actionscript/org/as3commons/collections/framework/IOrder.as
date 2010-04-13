package org.as3commons.collections.framework {
	import org.as3commons.collections.framework.ICollection;

	/**
	 * Definition of a collection whose items are stored in a stable (insertion or sort) order. 
	 * 
	 * @author jes 12.04.2010
	 */
	public interface IOrder extends ICollection {

		/**
		 * The first item or <code>undefined</code> if the collection is empty.
		 */
		function get first() : *;

		/**
		 * The last item or <code>undefined</code> if the collection is empty.
		 */
		function get last() : *;
		
		/**
		 * Removes the first item of the ordered collection.
		 * 
		 * @return The formerly first item or <code>undefined</code> if the collection is empty.
		 */
		function removeFirst() : *;

		/**
		 * Removes the last item of the ordered collection.
		 * 
		 * @return The formerly last item or <code>undefined</code> if the collection is empty.
		 */
		function removeLast() : *;

	}
}
