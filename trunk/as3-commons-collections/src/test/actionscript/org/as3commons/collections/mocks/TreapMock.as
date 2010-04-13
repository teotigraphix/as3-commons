package org.as3commons.collections.mocks {
	import org.as3commons.collections.Treap;
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.units.ITestSortOrder;

	/**
	 * @author jes 29.03.2010
	 */
	public class TreapMock extends Treap implements 
		ITestSortOrder
	{
		public function TreapMock(comparator : IComparator) {
			super(comparator);
		}
		
		override public function iterator(cursor : * = undefined) : IIterator {
			return new TreapIteratorMock(this, getNode(cursor));
		}

		public function addMock(item : *) : void {
			add(item);
		}
		
		public function equalItems(item : *) : Array {
			var equalItems : Array = new Array();
			var equal : * = equalItem(item);
			if (equal !== undefined) equalItems.push(equal);
			return equalItems;
		}
	}
}
