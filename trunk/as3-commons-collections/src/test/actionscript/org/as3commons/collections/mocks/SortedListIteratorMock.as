package org.as3commons.collections.mocks {
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.core.SortedListIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 01.04.2010
	 */
	public class SortedListIteratorMock extends SortedListIterator implements
		ITestIteratorNextPreviousLookup
	{
		public function SortedListIteratorMock(sortedList : SortedList, index : uint = 0) {
			super(sortedList, index);
		}

		public function get previousMock() : * {
			return _array[previousIndex];
		}
		
		public function get nextMock() : * {
			return _array[nextIndex];
		}

	}
}
