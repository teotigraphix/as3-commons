package org.as3commons.collections.framework.core {
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IOrderedList;
	import org.as3commons.collections.framework.IOrderedListIterator;
	import org.as3commons.collections.framework.core.AbstractListIterator;

	/**
	 * Internal <code>ArrayList</code> iterator implementation.
	 * 
	 * @author jes 19.02.2010
	 */
	public class ArrayListIterator extends AbstractListIterator implements IOrderedListIterator {
		
		/**
		 * ArrayListIterator constructor.
		 * 	
		 * <p>If <code>index</code> is specified, the iterator returns the item at that
		 * index with the first call to <code>next()</code> and the item at <code>index -1</code>
		 * with the first call to <code>previous()</code>.</p>
		 * 
		 * @param array The list.
		 * @param index Start position of enumeration.
		 */
		public function ArrayListIterator(list : ArrayList, index : uint = 0) {
			super(list, index);
		}
		
		/*
		 * IOrderedListIterator
		 */
		
		/**
		 * @inheritDoc
		 */
		public function addBefore(item : *) : uint {
			var index : uint;
			
			_current = -1;

			if (_next == -1) {
				index = _arrayList.size;
			} else {
				index = _next;
				_next++;
			}
			
			_arrayList.addAt(index, item);
			return index;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addAfter(item : *) : uint {
			_current = -1;

			var index : uint;
			
			if (_next == -1) {
				index = _arrayList.size;
				_next = index;
			} else {
				index = _next;
			}
			
			_arrayList.addAt(index, item);
			return index;
		}
		
		/**
		 * @inheritDoc
		 */
		public function replace(item : *) : Boolean {
			if (_current == -1) return false;
			
			return _arrayList.replaceAt(_current, item);
		}

		/*
		 * Private
		 */
		
		/**
		 * Casts the <code>IList</code> of the <code>AbstractListIterator</code> into an <code>IOrderedList</code>.
		 */
		private function get _arrayList() : IOrderedList {
			return _list as IOrderedList;
		}
	}
}
