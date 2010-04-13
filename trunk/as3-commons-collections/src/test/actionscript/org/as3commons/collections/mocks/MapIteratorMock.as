package org.as3commons.collections.mocks {
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.core.MapIterator;
	import org.as3commons.collections.units.iterators.ITestIteratorNextPreviousLookup;

	/**
	 * @author jes 01.04.2010
	 */
	public class MapIteratorMock extends MapIterator implements
		ITestIteratorNextPreviousLookup
	{
		public function MapIteratorMock(map : Map) {
			super(map);
		}

		public function get previousMock() : * {
			return _map.itemFor(previousKey);
		}
		
		public function get nextMock() : * {
			return _map.itemFor(nextKey);
		}

	}
}
