package org.as3commons.collections.mocks {
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.units.ITestSortOrderDuplicateEquals;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedSetMock extends SortedSet implements
		ITestSortOrderDuplicateEquals
	{
		public function SortedSetMock(comparator : IComparator) {
			super(comparator);
		}
		
		override public function iterator(cursor : * = undefined) : IIterator {
			return new SortedSetIteratorMock(this, getNode(cursor));
		}

		public function addMock(item : *) : void {
			add(item);
		}
	}
}
