package org.as3commons.collections.mocks {
	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.units.ITestDuplicates;
	import org.as3commons.collections.units.ITestInsertionOrder;

	/**
	 * @author jes 25.03.2010
	 */
	public class LinkedListMock extends LinkedList implements
		ITestInsertionOrder,
		ITestDuplicates
	{

		override public function iterator(cursor : * = undefined) : IIterator {
			return new LinkedListIteratorMock(this);
		}

		public function addMock(item : *) : void {
			add(item);
		}

		public function addFirstMock(item : *) : void {
			addFirst(item);
		}
		
		public function addLastMock(item : *) : void {
			addLast(item);
		}
	}
}
