package org.as3commons.collections {
	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.mocks.MapMock;
	import org.as3commons.collections.testhelpers.AbstractCollectionTestCase;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.IMapTests;

	/**
	 * @author jes 23.03.2010
	 */
	public class MapTest extends AbstractCollectionTestCase {

		/*
		 * AbstractCollectionTest
		 */

		override public function createCollection() : ICollection {
			return new MapMock();
		}

		override public function fillCollection(items : Array) : void {
			collection.clear();
			for each (var item : * in items) {
				Map(collection).add(UniqueMapKey.key, item);
			}
		}

		/*
		 * Units
		 */

		/*
		 * Map tests
		 */

		public function test_map() : void {
			new IMapTests(this).runAllTests();
		}

	}
}
