package org.as3commons.collections.mocks {
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.core.as3commons_collections;
	import org.as3commons.collections.units.ITestInsertionOrder;

	/**
	 * @author jes 19.03.2010
	 */
	public class LinkedSetMock extends LinkedSet implements
		ITestInsertionOrder
	{

		use namespace as3commons_collections;
		
		override public function iterator(cursor : * = undefined) : IIterator {
			return new LinkedSetIteratorMock(this, getNode(cursor));
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
