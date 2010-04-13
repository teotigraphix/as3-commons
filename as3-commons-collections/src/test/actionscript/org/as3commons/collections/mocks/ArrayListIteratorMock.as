package org.as3commons.collections.mocks {
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.core.ArrayListIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorInsertionOrder;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 19.03.2010
	 */
	public class ArrayListIteratorMock extends ArrayListIterator implements
		ITestIteratorInsertionOrder,
		ITestIteratorNextPreviousLookup
	{

		public function ArrayListIteratorMock(list : ArrayList, index : uint = 0) {
			super(list, index);
		}
		
		public function addBeforeMock(item : *) : Boolean {
			var index : int = addBefore(item);
			return index > - 1;
		}
		
		public function addAfterMock(item : *) : Boolean {
			var index : int = addAfter(item);
			return index > -1;
		}
		
		public function replaceMock(item : *) : Boolean {
			return replace(item);
		}
		
		public function get previousMock() : * {
			return _array[previousIndex];
		}
		
		public function get nextMock() : * {
			return _array[nextIndex];
		}
	}
}
