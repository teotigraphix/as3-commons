package org.as3commons.collections.mocks {
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.fx.SortedSetFx;
	import org.as3commons.collections.units.ITestSortOrderDuplicateEquals;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedSetFxMock extends SortedSetFx implements
		ITestSortOrderDuplicateEquals
	{
		public function SortedSetFxMock(comparator : IComparator) {
			super(comparator);
		}
		
		public function addMock(item : *) : void {
			add(item);
		}
	}
}
