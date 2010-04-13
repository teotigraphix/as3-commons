package org.as3commons.collections.mocks {
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.fx.SortedListFx;
	import org.as3commons.collections.units.ITestDuplicates;
	import org.as3commons.collections.units.ITestSortOrderDuplicateEquals;

	/**
	 * @author jes 22.03.2010
	 */
	public class SortedListFxMock extends SortedListFx implements 
		ITestSortOrderDuplicateEquals,
		ITestDuplicates
	{
		public function SortedListFxMock(comparator : IComparator) {
			super(comparator);
		}
		
		public function addMock(item : *) : void {
			add(item);
		}

		public function lesser(item : *) : * {
			return itemAt(lesserIndex(item));
		}
		
		public function higher(item : *) : * {
			return itemAt(higherIndex(item));
		}
		
		public function equalItems(item : *) : Array {
			var indices : Array = equalIndices(item);
			var items : Array = new Array();
			for each (var index : uint in indices) {
				items.push(itemAt(index));
			}
			return items;
		}
	}
}
