package org.as3commons.collections.mocks {
	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.core.as3commons_collections;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.ITestDuplicates;
	import org.as3commons.collections.units.ITestInsertionOrder;

	/**
	 * @author jes 26.03.2010
	 */
	public class LinkedMapMock extends LinkedMap implements
		ITestInsertionOrder,
		ITestDuplicates
	{

		use namespace as3commons_collections;

		override public function iterator(cursor : * = undefined) : IIterator {
			return new LinkedMapIteratorMock(this, getNode(cursor));
		}

		public function addMock(item : *) : void {
			add(UniqueMapKey.key, item);
		}

		public function addFirstMock(item : *) : void {
			addFirst(UniqueMapKey.key, item);
		}
		
		public function addLastMock(item : *) : void {
			addLast(UniqueMapKey.key, item);
		}

	}
}
