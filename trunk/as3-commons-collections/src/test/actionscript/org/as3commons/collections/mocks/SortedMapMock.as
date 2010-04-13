package org.as3commons.collections.mocks {
	import org.as3commons.collections.SortedMap;
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.ITestDuplicates;
	import org.as3commons.collections.units.ITestSortOrderDuplicateEquals;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedMapMock extends SortedMap implements
		ITestSortOrderDuplicateEquals,
		ITestDuplicates
	{
		public function SortedMapMock(comparator : IComparator) {
			super(comparator);
		}
		
		override public function iterator(cursor : * = undefined) : IIterator {
			return new SortedMapIteratorMock(this, getNode(cursor));
		}

		public function addMock(item : *) : void {
			add(UniqueMapKey.key, item);
		}
		
		public function lesser(item : *) : * {
			return itemFor(lesserKey(item));
		}
		
		public function higher(item : *) : * {
			return itemFor(higherKey(item));
		}

		public function equalItems(item : *) : Array {
			var keys : Array = equalKeys(item);
			var items : Array = new Array();
			for each (var key : * in keys) {
				items.push(itemFor(key));
			}
			return items;
		}
	}
}
