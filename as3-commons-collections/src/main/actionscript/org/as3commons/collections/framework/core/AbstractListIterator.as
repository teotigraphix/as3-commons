package org.as3commons.collections.framework.core {
	import org.as3commons.collections.framework.IListIterator;
	import org.as3commons.collections.iterators.ArrayIterator;

	/**
	 * Abstract list iterator implementation.
	 * 
	 * @author jes 05.03.2010
	 */
	public class AbstractListIterator extends ArrayIterator implements IListIterator {
		
		use namespace as3commons_collections;

		/**
		 * The list to enumerate.
		 */
		protected var _list : AbstractList;
		
		/**
		 * ListIterator constructor.
		 * 
		 * <p>If <code>index</code> is specified, the iterator returns the item at that
		 * index with the first call to <code>next()</code> and the item at <code>index -1</code>
		 * with the first call to <code>previous()</code>.</p>
		 * 
		 * @param list The list to be enumerated.
		 * @param index Start position of enumeration.
		 */
		public function AbstractListIterator(list : AbstractList, index : uint = 0) {
			_list = list;

			super(_list.array_internal, index);
		}
		
		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function removeCurrent() : void {
			_list.removeAt(_current);
		}

	}
}
