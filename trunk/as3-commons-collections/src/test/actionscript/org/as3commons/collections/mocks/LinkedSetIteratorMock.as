package org.as3commons.collections.mocks {
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.core.LinkedNode;
	import org.as3commons.collections.framework.core.LinkedSetIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorInsertionOrder;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 25.03.2010
	 */
	public class LinkedSetIteratorMock extends LinkedSetIterator implements
		ITestIteratorInsertionOrder,
		ITestIteratorNextPreviousLookup
	{
		public function LinkedSetIteratorMock(map : LinkedSet, next : LinkedNode = null) {
			super(map, next);
		}

		public function addBeforeMock(item : *) : Boolean {
			return addBefore(item);
		}
		
		public function addAfterMock(item : *) : Boolean {
			return addAfter(item);
		}
		
		public function get previousMock() : * {
			return previousItem;
		}
		
		public function get nextMock() : * {
			return nextItem;
		}

	}
}
