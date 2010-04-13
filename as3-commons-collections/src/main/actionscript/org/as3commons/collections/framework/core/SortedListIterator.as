package org.as3commons.collections.framework.core {
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.core.AbstractListIterator;

	/**
	 * Internal <code>SortedList</code> iterator implementation.
	 * 
	 * @author jes 01.04.2010
	 */
	public class SortedListIterator extends AbstractListIterator {
		
		/**
		 * SortedListIterator constructor.
		 * 
		 * <p>If <code>index</code> is specified, the iterator returns the item at that
		 * index with the first call to <code>next()</code> and the item at <code>index -1</code>
		 * with the first call to <code>previous()</code>.</p>
		 * 
		 * @param array The list.
		 * @param index Start position of enumeration.
		 */
		public function SortedListIterator(sortedList : SortedList, index : uint = 0) {
			super(sortedList, index);
		}
	}
}
