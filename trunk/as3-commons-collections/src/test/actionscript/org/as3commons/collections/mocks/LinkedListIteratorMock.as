package org.as3commons.collections.mocks {
	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.framework.core.LinkedListIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorInsertionOrder;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 25.03.2010
	 */
	public class LinkedListIteratorMock extends LinkedListIterator implements
		ITestIteratorInsertionOrder,
		ITestIteratorNextPreviousLookup
	{
		public function LinkedListIteratorMock(list : LinkedList) {
			super(list);
		}

		public function addBeforeMock(item : *) : Boolean {
			addBefore(item);
			return true;
		}
		
		public function addAfterMock(item : *) : Boolean {
			addAfter(item);
			return true;
		}
		
		public function replaceMock(item : *) : Boolean {
			return replace(item);
		}
		
		public function get previousMock() : * {
			return previousItem;
		}
		
		public function get nextMock() : * {
			return nextItem;
		}
	}
}
