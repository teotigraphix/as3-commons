package org.as3commons.collections.mocks {
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.ITestDuplicates;

	/**
	 * @author jes 23.03.2010
	 */
	public dynamic class MapMock extends Map implements
		ITestDuplicates
	{

		override public function iterator(cursor : * = undefined) : IIterator {
			return new MapIteratorMock(this);
		}

		public function addMock(item : *) : void {
			add(UniqueMapKey.key, item);
		}

	}
}
