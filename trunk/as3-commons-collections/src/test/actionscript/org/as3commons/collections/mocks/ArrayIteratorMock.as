package org.as3commons.collections.mocks {
	import org.as3commons.collections.iterators.ArrayIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 01.04.2010
	 */
	public class ArrayIteratorMock extends ArrayIterator implements
		ITestIteratorNextPreviousLookup
	{
		public function ArrayIteratorMock(array : Array, index : uint = 0) {
			super(array, index);
		}
		
		public function get previousMock() : * {
			return _array[previousIndex];
		}
		
		public function get nextMock() : * {
			return _array[nextIndex];
		}

	}
}
