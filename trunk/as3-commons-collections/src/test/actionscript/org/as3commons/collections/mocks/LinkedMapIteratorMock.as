package org.as3commons.collections.mocks {
	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.core.LinkedMapNode;
	import org.as3commons.collections.framework.core.LinkedMapIterator;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.iterators.ITestIteratorInsertionOrder;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 25.03.2010
	 */
	public class LinkedMapIteratorMock extends LinkedMapIterator implements
		ITestIteratorInsertionOrder,
		ITestIteratorNextPreviousLookup
	{
		public function LinkedMapIteratorMock(map : LinkedMap, next : LinkedMapNode = null) {
			super(map, next);
		}

		public function addBeforeMock(item : *) : Boolean {
			return addBefore(UniqueMapKey.key, item);
		}
		
		public function addAfterMock(item : *) : Boolean {
			return addAfter(UniqueMapKey.key, item);
		}
		
		public function get previousMock() : * {
			return LinkedMap(_collection).itemFor(previousKey);
		}
		
		public function get nextMock() : * {
			return LinkedMap(_collection).itemFor(nextKey);
		}

	}
}
