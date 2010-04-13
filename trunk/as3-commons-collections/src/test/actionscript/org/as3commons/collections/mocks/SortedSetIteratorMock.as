package org.as3commons.collections.mocks {
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.core.SortedNode;
	import org.as3commons.collections.framework.core.SortedSetIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 01.04.2010
	 */
	public class SortedSetIteratorMock extends SortedSetIterator implements
		ITestIteratorNextPreviousLookup
	{
		public function SortedSetIteratorMock(sortedSet : SortedSet, node : SortedNode) {
			super(sortedSet, node);
		}

		public function get previousMock() : * {
			return previousItem;
		}
		
		public function get nextMock() : * {
			return nextItem;
		}

	}
}
