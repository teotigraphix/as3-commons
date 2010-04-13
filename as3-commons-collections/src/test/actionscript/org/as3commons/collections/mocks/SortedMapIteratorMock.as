package org.as3commons.collections.mocks {
	import org.as3commons.collections.SortedMap;
	import org.as3commons.collections.framework.core.SortedMapIterator;
	import org.as3commons.collections.framework.core.SortedMapNode;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 01.04.2010
	 */
	public class SortedMapIteratorMock extends SortedMapIterator implements
		ITestIteratorNextPreviousLookup
	{
		public function SortedMapIteratorMock(sortedMap : SortedMap, node : SortedMapNode) {
			super(sortedMap, node);
		}

		public function get previousMock() : * {
			return SortedMap(_collection).itemFor(previousKey);
		}
		
		public function get nextMock() : * {
			return SortedMap(_collection).itemFor(nextKey);
		}

	}
}
